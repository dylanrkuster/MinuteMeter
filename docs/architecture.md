# Architecture

Minute Meter keeps the apps you pick locked. You pick 1 to 29 minutes on a scroll wheel and slide to unlock all of them at once, up to a daily limit. Sliding again locks them early. When the time runs out, they lock again.

## Pieces

| Piece | Job |
|---|---|
| App | All screens. Starts unlocks and handles slide to lock. Writes the stored state. |
| Shield Configuration | Draws the shield over a locked app, with time left. Shows Unlock only when time left is above 0. If notifications are off, tells the user to open the app instead. |
| Shield Action | Handles shield taps. Unlock posts a local notification that opens the app. |
| Monitor | The only code that runs in the background. Relocks when an unlock ends. At midnight, applies next-day changes and resets today's minutes used. |
| Live Activity | A countdown on the Lock Screen and in the Dynamic Island. It lives in a widget extension because iOS requires that, but there's no home screen widget. |
| Server | One endpoint. Sends the push that ends the Live Activity when an unlock ends. |

All targets share one App Group, where the shared data lives.

## Unlock

1. The app checks the chosen length against time left.
2. It schedules the Monitor to relock at the end. If scheduling fails, the unlock stops here and the apps stay locked.
3. It adds the minutes to today's minutes used right away, so time left drops at the start. It saves the current unlock: its start and end times.
4. It removes the shields.
5. It starts the Live Activity and sends the activity's push token and end time to the server. It doesn't wait for the server, so unlocking works offline.

The relock is scheduled before the shields come off. In the other order, a failed schedule would leave the apps unlocked with nothing to relock them.

**Slide to lock** (ending early) relocks, cancels the schedule, ends the Live Activity, and clears the current unlock. It refunds the unused minutes, rounded down, but only if the unlock started today. An unlock that started before midnight was charged to yesterday, which midnight already reset, so refunding it would create extra time on the new day. Minutes used never goes below 0. The server's push later does nothing, because the activity has already ended.

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

- The pending limit, if there is one, becomes the limit.
- Pending app removals, if there are any, take effect.
- Today's minutes used resets to 0.
- The state's day is set to today.

Removals and limit changes wait until midnight so they can't be used to get more time today. Adding apps takes effect immediately.

**Catching up a missed midnight.** If the phone was off at midnight, the Monitor may not run. So whenever the app opens, it compares today's date with the state's day. If they match, nothing happens. If they differ, midnight was missed and the app runs the same step. Because the step sets the day, running it twice does nothing. The check and the write happen inside one coordinated write, so the app and the Monitor can't both run it.

Until the step has run, anything reading the state and finding an older day treats it as already rolled over: 0 minutes used, at the pending limit if there is one.

## Data

One small JSON file in the App Group. There are no accounts, no history, and nothing is stored on a server. It holds only:

- **The day** the state belongs to, as calendar-day text such as `"2026-09-29"`. The midnight step uses it to know whether it has run.
- **The limit,** and an optional **pending limit** that the Monitor applies at midnight.
- **The picked apps** (`FamilyActivitySelection`), and optional **pending removals** that the Monitor applies at midnight.
- An optional **current unlock:** its start and end times.
- **Minutes used today:** a single number.

Time left today is the limit minus minutes used today.

The app and the Monitor are separate processes that write the same files, and the shield reads them at any time. Every write replaces the whole file atomically and goes through `NSFileCoordinator`, so a write is never lost or read half-finished.

A missing file just means no data yet. Any other read failure is an error: screens show an unknown value instead of the full limit, and nothing saves over a file it couldn't read.

## Accepted bypasses

These are obvious to anyone who tries them, and the app stops working when they do:

- **Turning off Screen Time access** in iOS Settings removes every shield.
- **Deleting the app** removes the shields and the stored state.
- **Setting the clock forward** starts a new day early.

## Known issues

- **Time zone changes** move midnight, which can start a new day early or make one longer. Tracked in #3.

## Paid version

A one-time purchase through StoreKit 2 ($9.99 for now). The free version allows up to 3 apps and no categories.

## Testing

- Unit tests cover the limit math and the data layer.
- XCUITest covers UI flows in the Simulator. Screen Time will sit behind a small interface that tests replace with a fake (planned).
- Shields, relocking, and the app picker only work on a device, so they get a manual checklist.
