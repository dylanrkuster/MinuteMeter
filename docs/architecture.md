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
2. It adds the minutes to today's history entry right away, so time left drops at the start. It saves the current unlock (start and end).
3. It starts the Live Activity and sends the activity's push token and end time to the server. It doesn't wait for the server, so unlocking works offline.
4. It removes the shields.
5. It schedules the Monitor to relock at the end.

**Lock now** relocks, cancels the schedule, ends the Live Activity, and subtracts the unused minutes from today's entry. The server's push later does nothing, because the activity has already ended.

## Relock

Only the Monitor relocks, using a one-time DeviceActivity schedule that ends when the unlock ends.

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

Removals and limit changes wait until midnight so they can't be used to get more time today. Adding apps takes effect immediately. If the phone was off at midnight, the app runs the same step the next time it opens.

## Data

JSON files in the App Group. There are no accounts and nothing is stored on a server, so deleting the app deletes its history.

- **State:** the limit, the pending limit, the picked apps (`FamilyActivitySelection`), pending removals, and the current unlock.
- **History:** one entry per day, holding minutes used, that day's limit, and the number of blocked apps and categories.

Time left today is today's limit minus today's minutes used.

## Paid version

A one-time purchase through StoreKit 2 ($9.99 for now). The free version allows up to 3 apps and no categories.

## Testing

- Unit tests cover the limit math and the data layer.
- XCUITest covers UI flows in the Simulator. Screen Time will sit behind a small interface that tests replace with a fake (planned).
- Shields, relocking, and the app picker only work on a device, so they get a manual checklist.
