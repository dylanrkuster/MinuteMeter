//  DesignTokens.swift
//  Design tokens for the B3 Night design (dark UI, Brass accent).
//  Source of truth: design/source/*.html. Values are copied from those files.
//
//  Fonts: add Fonts/*.ttf to the app target (and any extension that renders text,
//  such as the Live Activity widget) and list them under UIAppFonts in Info.plist.
//  Barlow is licensed under the SIL Open Font License (Fonts/OFL.txt).

import SwiftUI

// MARK: - Color

extension Color {
    /// Creates a color from a 0xRRGGBB value.
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum Palette {
    // Surfaces
    static let background     = Color(hex: 0x161615) // screen background
    static let panel          = Color(hex: 0x1C1C1B) // raised list panels
    static let recess         = Color(hex: 0x0E0E0D) // sunken panels, segmented tracks, readouts
    static let hairline       = Color(hex: 0x262624) // row dividers
    static let track          = Color(hex: 0x2C2C2A) // unfilled bars, empty pie wedge
    static let tick           = Color(hex: 0x55534E) // minor ticks on tapes and the knob arc

    // Raised controls (round header buttons, selected segment)
    static let raisedTop      = Color(hex: 0x383835)
    static let raisedBottom   = Color(hex: 0x2A2A28)
    static let knobButtonTop  = Color(hex: 0x353533)
    static let knobButtonBase = Color(hex: 0x242422)

    // Knob
    static let knurlDark      = Color(hex: 0x232321)
    static let knurlLight     = Color(hex: 0x3A3A37)
    static let faceHighlight  = Color(hex: 0x3C3C39)
    static let faceMid        = Color(hex: 0x282826)
    static let faceShadow     = Color(hex: 0x1C1C1A)

    // Text
    static let textPrimary    = Color(hex: 0xEDEBE4)
    static let textSecondary  = Color(hex: 0x9A978F)
    static let textDisabled   = Color(hex: 0x6E6B64)
    static let onAccent       = Color(hex: 0x161615) // text on Brass fills

    // "Lock now" light button
    static let lightButtonTop    = Color(hex: 0xFFFFFF)
    static let lightButtonMid    = Color(hex: 0xEDEBE4)
    static let lightButtonBottom = Color(hex: 0xD2CFC7)
    static let lightButtonLip    = Color(hex: 0x6E6B64)

    // Used-time marks in Trends (pie wedges)
    static let usedMark       = Color(hex: 0x8A8780)
}

/// Brass accent. `base` is the brand color; the others are derived from it
/// (text = 12% toward white, highlight = 35% toward white, deep = 12% toward black,
/// lip = 42% toward black). Keep the derivation if you ever swap the accent.
enum Accent {
    static let base      = Color(hex: 0xD8A95B)
    static let text      = Color(hex: 0xDDB36F) // accent-colored text on dark
    static let highlight = Color(hex: 0xE6C794) // top of button gradients
    static let deep      = Color(hex: 0xBE9550) // bottom of button gradients
    static let lip       = Color(hex: 0x7D6235) // 4 pt "key" edge under primary buttons
    static let glow      = Color(hex: 0xD8A95B, opacity: 0.5)
}

// MARK: - Typography
//
// Two families: Barlow (numbers, headlines, body) and Barlow Semi Condensed
// (uppercase labels and button text). Always use monospaced digits for times.

enum Typeface {
    static func barlow(_ size: CGFloat, _ weight: Weight = .semibold) -> Font {
        .custom(weight.barlow, size: size)
    }
    static func condensed(_ size: CGFloat, _ weight: Weight = .semibold) -> Font {
        .custom(weight.condensed, size: size)
    }

    enum Weight {
        case regular, medium, semibold, bold
        var barlow: String {
            switch self {
            case .regular: "Barlow-Regular"
            case .medium: "Barlow-Medium"
            case .semibold: "Barlow-SemiBold"
            case .bold: "Barlow-Bold"
            }
        }
        var condensed: String {
            switch self {
            case .regular, .medium: "BarlowSemiCondensed-Medium"
            case .semibold: "BarlowSemiCondensed-SemiBold"
            case .bold: "BarlowSemiCondensed-Bold"
            }
        }
    }
}

/// Named text styles used in the mockups. `tracking` is in points.
struct TextStyle {
    let font: Font
    let tracking: CGFloat
    let uppercase: Bool

    static let heroTime      = TextStyle(font: Typeface.barlow(116).monospacedDigit(), tracking: -2.3, uppercase: false) // Today "1:12"
    static let heroCountdown = TextStyle(font: Typeface.barlow(104).monospacedDigit(), tracking: -2.1, uppercase: false) // Unlocked "11:42"
    static let statNumber    = TextStyle(font: Typeface.barlow(72).monospacedDigit(), tracking: -0.7, uppercase: false)  // Trends "1:34"
    static let limitValue    = TextStyle(font: Typeface.barlow(64).monospacedDigit(), tracking: 0, uppercase: false)     // Settings "2:00"
    static let liveCountdown = TextStyle(font: Typeface.barlow(50).monospacedDigit(), tracking: 0, uppercase: false)
    static let headline      = TextStyle(font: Typeface.barlow(32), tracking: -0.3, uppercase: false)                    // onboarding titles
    static let body          = TextStyle(font: Typeface.barlow(17, .regular), tracking: 0, uppercase: false)
    static let row           = TextStyle(font: Typeface.barlow(16, .medium), tracking: 0, uppercase: false)
    static let detent        = TextStyle(font: Typeface.barlow(18).monospacedDigit(), tracking: 0, uppercase: false)    // knob labels
    static let label         = TextStyle(font: Typeface.condensed(12), tracking: 1.7, uppercase: true)                   // "LEFT TODAY"
    static let smallLabel    = TextStyle(font: Typeface.condensed(11), tracking: 1.5, uppercase: true)
    static let title         = TextStyle(font: Typeface.condensed(14, .bold), tracking: 2.5, uppercase: true)            // "USAGE", "SETTINGS"
    static let buttonLarge   = TextStyle(font: Typeface.condensed(18, .bold), tracking: 2.5, uppercase: true)            // "GET STARTED"
    static let knobCenter    = TextStyle(font: Typeface.condensed(17, .bold), tracking: 2.0, uppercase: true)            // "UNLOCK"
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.font(style.font)
            .tracking(style.tracking)
            .textCase(style.uppercase ? .uppercase : nil)
    }
}

// MARK: - Metrics (points, on a 390 pt wide screen)

enum Metrics {
    static let screenPadding: CGFloat = 24
    static let minTapTarget: CGFloat = 44

    // Primary "key" button (GET STARTED, CONTINUE, LOCK MY APPS)
    static let keyHeight: CGFloat = 64
    static let keyRadius: CGFloat = 17
    static let keyLip: CGFloat = 4          // solid edge drawn 4 pt below, in Accent.lip

    // Panels
    static let panelRadius: CGFloat = 18
    static let readoutRadius: CGFloat = 16
    static let rowHeight: CGFloat = 48

    // Round header buttons (Trends, Settings, Back)
    static let headerButton: CGFloat = 44

    // Limit / session tape
    static let tapeHeight: CGFloat = 62
    static let tapeBandHeight: CGFloat = 10
    static let tapeBandRadius: CGFloat = 2

    // Rotary knob (Today, Unlocked, Out of time, onboarding limit).
    // Container is 342 x 322 pt; knob center sits at (171, 185).
    enum Knob {
        static let knurlDiameter: CGFloat = 250     // ridged outer ring, 2.5° stripes
        static let faceDiameter: CGFloat = 214
        static let centerButtonDiameter: CGFloat = 116
        static let pointerInnerRadius: CGFloat = 78
        static let pointerOuterRadius: CGFloat = 102
        static let pointerWidth: CGFloat = 5
        static let tickArcRadius: CGFloat = 136     // tick arc spans -70° ... +70° (0° = 12 o'clock)
        static let detentRadius: CGFloat = 152      // label centers
        static let detentAngles: [Double] = [-60, -20, 20, 60]
        static let unlockDetents = [5, 15, 30, 60]            // minutes
        static let limitDetents = [30, 60, 120, 180]          // minutes (onboarding)
        static let progressRingRadius: CGFloat = 136          // Unlocked screen ring
        static let progressRingWidth: CGFloat = 7
    }
}

// MARK: - Effects

enum Effects {
    /// Soft glow on accent marks (bands, pointer, LED dots).
    static let accentGlowRadius: CGFloat = 6
    /// Drop shadow under the knob.
    static let knobShadow = (color: Color.black.opacity(0.7), radius: CGFloat(22), y: CGFloat(20))
}
