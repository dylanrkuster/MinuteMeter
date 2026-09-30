# Minute Meter

A minimal iOS screen time app. The apps you pick stay locked. When you need one, turn the dial to unlock them for a few minutes, up to a daily limit.

## Build

Requires Xcode 26 and [XcodeGen](https://github.com/yonaskolb/XcodeGen). `project.yml` is the source of truth for the Xcode project:

```bash
xcodegen generate
```

Screen Time features only work on a real device.

## License

The code is source-available under the [PolyForm Noncommercial License 1.0.0](LICENSE.md): you can read, run, and modify it for noncommercial purposes. The Chivo font in `Shared/Fonts` are under the [SIL Open Font License](Shared/Fonts/OFL.txt).
