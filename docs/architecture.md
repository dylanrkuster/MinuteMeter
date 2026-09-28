# Architecture

Minute Meter keeps the apps you pick locked. You unlock all of them at once for 1 to 60 minutes, up to a daily limit. When the time runs out, they lock again.

## Pieces

| Piece | Job |
|---|---|
| App | All screens. Starts unlocks and handles Lock now. Writes settings and history. |
| Shield Configuration | Draws the shield over a locked app, with time left. Shows Unlock only when time left is above 0. If notifications are off, tells the user to open the app instead. |
| Shield Action | Handles shield taps. Unlock posts a local notification that opens the app. |
| Monitor | The only code that runs in the background. Relocks when an unlock ends. At midnight, applies next-day changes and starts the new day's history entry. |
| Live Activity | A countdown on the Lock Screen and in the Dynamic Island. It lives in a widget extension because iOS requires that, but there's no home screen widget. |
| Server | One endpoint. Sends the push that ends the Live Activity when an unlock ends. |

All targets share one App Group, where the shared data lives.

## Unlock

1. The app checks the chosen length against time left.
2. It schedules the Monitor to relock at the end. If scheduling fails, the unlock stops here and the apps stay locked.
3. It adds the minutes to today's history entry right away, so time left drops at the start. It saves the current unlock: start, end, and the day it was charged to.
4. It removes the shields.
5. It starts the Live Activity and sends the activity's push token and end time to the server. It doesn't wait for the server, so unlocking works offline.

The relock is scheduled before the shields come off. In the other order, a failed schedule would leave the apps unlocked with nothing to relock them.

**Lock now** relocks, cancels the schedule, ends the Live Activity, and clears the current unlock. It refunds the unused minutes, rounded down, to the day the unlock was charged to, and never takes that day's minutes used below 0. That way an unlock that crosses midnight can't create extra time on the new day. The server's push later does nothing, because the activity has already ended.

## Relock

Only the Monitor relocks, using a one-time DeviceActivity schedule that ends when the unlock ends. It also clears the current unlock, so a finished unlock can't be refunded later.

- **Why not the server:** a server can only reach the app through silent pushes. iOS doesn't guarantee their delivery and never delivers them to an app the user has swiped away, so swiping the app away would keep apps unlocked. iOS runs the Monitor on schedule either way.
- **Under 15 minutes:** DeviceActivity's minimum interval is 15 minutes. For shorter unlocks we schedule 15 minutes and relock on the schedule's warning callback, which fires at the real end.
- **Failure mode:** if the callback never fires, the apps stay unlocked. We measure this on a device before building on it.

## Live Activity

Only the running app or a push from a server can end a Live Activity. An extension can't; this was confirmed in LockedIn. So the server sends the end push.

If the server can't be reached, the countdown stops at 0:00 and stays visible until the app next opens. Relocking never depends on the server.

## Midnight

The Monitor's daily schedule runs at 00:00:

- A pending limit change becomes the limit.
- Pending app removals take effect.
- A new history entry starts for the day.

Removals and limit changes wait until midnight so they can't be used to get more time today. Adding apps takes effect immediately.

If the phone was off at midnight, the app runs the same step the next time it opens.

Only the midnight step creates a day's entry; everything else updates an existing one. So today's entry existing means the step already ran, and running it twice does nothing. The check and the write happen inside one coordinated write, so the app and the Monitor can't both create the entry.

Until today's entry exists, the shield reads today as 0 minutes used, at the pending limit if one is waiting and otherwise the current limit.

## Data

JSON files in the App Group. There are no accounts and nothing is stored on a server, so deleting the app deletes its history.

- **State:** the limit, the pending limit, the picked apps (`FamilyActivitySelection`), pending removals, and the current unlock.
- **History:** `history.json`, a dictionary keyed by calendar day as text (`"2026-09-28"`), so there's one entry per day and today's is a direct lookup. Each entry holds minutes used, that day's limit, and the number of blocked apps and categories. Days are text rather than timestamps because a day means "this calendar day where you are", and a timestamp needs a time zone to become a day (see #3).

Time left today is today's limit minus today's minutes used.

The app and the Monitor are separate processes that write the same files, and the shield reads them at any time. Every write replaces the whole file atomically and goes through `NSFileCoordinator`, so a write is never lost or read half-finished.

A missing file just means no data yet. Any other read failure is an error: screens show an unknown value instead of the full limit, and nothing saves over a file it couldn't read.

## Accepted bypasses

These are obvious to anyone who tries them, and the app stops working when they do:

- **Turning off Screen Time access** in iOS Settings removes every shield.
- **Deleting the app** removes the shields and the history.
- **Setting the clock forward** starts a new day early.

## Known issues

- **Time zone changes** move midnight, which can start a new day early or make one longer. Tracked in #3.

## Paid version

A one-time purchase through StoreKit 2 ($9.99 for now). The free version allows up to 3 apps and no categories.

## Testing

- Unit tests cover the limit math and the data layer.
- XCUITest covers UI flows in the Simulator. Screen Time will sit behind a small interface that tests replace with a fake (planned).
- Shields, relocking, and the app picker only work on a device, so they get a manual checklist.
