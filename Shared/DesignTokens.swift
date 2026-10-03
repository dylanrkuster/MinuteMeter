//  DesignTokens.swift
//  Design tokens for the wind-up timer design (light cream plastic, red accent).
//  Source of truth: the design's SVG and HTML files. Values are copied from them.
//
//  Font: Chivo, a variable font that covers every weight in one file (SIL Open
//  Font License). Add it to the app target and the Live Activity target and list
//  it under UIAppFonts in Info.plist.

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
    // Text and marks
    static let ink           = Color(hex: 0x1D1A16) // text, dial ticks and numbers, icons
    static let secondary     = Color(hex: 0x7A7163) // labels, status line
    static let unlockedText  = Color(hex: 0xB8361F) // "UNLOCKED" status
    static let onRed         = Color(hex: 0xFFFDF8) // text on the red button

    // Red accent
    static let red           = Color(hex: 0xD2402A) // pointer, live status dot

    // Status dot when locked, and the thin ring around it
    static let idleDot       = Color(hex: 0xB3A994)
    static let idleDotRing   = Color.black.opacity(0.15)

    // Warm brown used for every drop shadow
    static let shadow        = Color(hex: 0x3B2F1E)
}

/// Gradients, as color stops. Views build the SwiftUI gradient from these.
enum Gradients {
    /// Screen background: an ellipse centered at 30% across and 22% down,
    /// with radii of 120% of the width and 80% of the height.
    static let background: [Gradient.Stop] = [
        .init(color: Color(hex: 0xF2ECE1), location: 0),
        .init(color: Color(hex: 0xE6DECF), location: 0.55),
        .init(color: Color(hex: 0xD9CFBE), location: 1),
    ]
    static let backgroundCenter = UnitPoint(x: 0.30, y: 0.22)
    static let backgroundRadii = CGSize(width: 1.2, height: 0.8) // fractions of width and height

    /// Round plastic buttons (Settings): radial, lit from the top left.
    static let plastic: [Gradient.Stop] = [
        .init(color: Color(hex: 0xFFFEFB), location: 0),
        .init(color: Color(hex: 0xF1EBDF), location: 0.6),
        .init(color: Color(hex: 0xE2D9C9), location: 1),
    ]
    static let plasticCenter = UnitPoint(x: 0.42, y: 0.30)

    /// Unlock button, top to bottom.
    static let redButton: [Gradient.Stop] = [
        .init(color: Color(hex: 0xE4553C), location: 0),
        .init(color: Color(hex: 0xC9391F), location: 1),
    ]

    /// Lock now button, top to bottom.
    static let creamButton: [Gradient.Stop] = [
        .init(color: Color(hex: 0xFBF8F2), location: 0),
        .init(color: Color(hex: 0xE9E2D5), location: 1),
    ]

    /// Live status dot: radial, lit from the top left.
    static let redDot: [Gradient.Stop] = [
        .init(color: Color(hex: 0xFF8A6E), location: 0),
        .init(color: Color(hex: 0xD2402A), location: 0.6),
    ]
}

/// The wind-up timer's colors, from the outer housing inward.
enum DialColors {
    // Housing: the round base the dial sits in
    static let housingTop: [Gradient.Stop] = [          // radial, center (0.36, 0.28)
        .init(color: Color(hex: 0xFFFEFB), location: 0),
        .init(color: Color(hex: 0xF6F1E8), location: 0.45),
        .init(color: Color(hex: 0xE9E1D3), location: 0.85),
        .init(color: Color(hex: 0xDAD0BE), location: 1),
    ]
    static let housingSide: [Gradient.Stop] = [         // left to right
        .init(color: Color(hex: 0xCFC6B5), location: 0),
        .init(color: Color(hex: 0xE6DECF), location: 0.28),
        .init(color: Color(hex: 0xC8BDAA), location: 0.62),
        .init(color: Color(hex: 0xA09481), location: 1),
    ]
    static let housingSideShade = Palette.shadow        // 0 → 28% opacity, from 55% down to the bottom
    static let bevelLight        = Color.white           // 95% opacity at the top left
    static let bevelDark         = Color(hex: 0x8F826C)  // 55% opacity at the bottom right
    static let ringLight         = Color.white           // 70% opacity
    static let ringDark          = Color(hex: 0xC9BEAB)  // 80% opacity

    // Turning dial: its side, rim, and ridged grip ring
    static let dialRim           = Color(hex: 0x8E826F)
    static let dialSide: [Gradient.Stop] = [            // left to right
        .init(color: Color(hex: 0xD9D0C0), location: 0),
        .init(color: Color(hex: 0xE8E1D4), location: 0.35),
        .init(color: Color(hex: 0xA99D89), location: 1),
    ]
    static let sideTick          = Color(hex: 0x4A3D2A)  // 22–38% opacity, darker toward the bottom right
    static let knurlBase         = Color(hex: 0xEEE7DA)
    static let knurlDark         = Color(hex: 0x4E412D)  // 20–52% opacity, darker toward the bottom right
    static let knurlLight        = Color.white           // 25–90% opacity, brighter toward the top left

    // Face: the numbered disc
    static let faceRim           = Color(hex: 0xB8AC97)
    static let face: [Gradient.Stop] = [                // radial, center (0.40, 0.32)
        .init(color: Color(hex: 0xFFFFFD), location: 0),
        .init(color: Color(hex: 0xF8F3EA), location: 0.6),
        .init(color: Color(hex: 0xEDE5D7), location: 1),
    ]
    static let faceEdgeShade     = Color(hex: 0x46371F)  // 0 → 16% opacity over the outer 14%

    // Grip: the raised bar in the middle of the face
    static let gripTop: [Gradient.Stop] = [
        .init(color: .white, location: 0),
        .init(color: Color(hex: 0xF4EEE4), location: 0.5),
        .init(color: Color(hex: 0xDDD3C2), location: 1),
    ]
    static let gripSide: [Gradient.Stop] = [
        .init(color: Color(hex: 0xD3C9B7), location: 0),
        .init(color: Color(hex: 0xA89C87), location: 1),
    ]
    static let gripRimDark       = Color(hex: 0x9C907C)  // 60% opacity

    // Pointer: the fixed red flag at the top, and its rivet
    static let pointer: [Gradient.Stop] = [             // left to right
        .init(color: Color(hex: 0xEE6A4F), location: 0),
        .init(color: Color(hex: 0xD2402A), location: 0.45),
        .init(color: Color(hex: 0xA42C1B), location: 1),
    ]
    static let pointerShadow     = Color(hex: 0x2A1A10)  // 45% opacity
    static let rivet: [Gradient.Stop] = [               // radial, center (0.35, 0.30)
        .init(color: .white, location: 0),
        .init(color: Color(hex: 0xC9CCCF), location: 0.5),
        .init(color: Color(hex: 0x7D8286), location: 1),
    ]
}

// MARK: - Typography
//
// Chivo SemiBold for all text, Chivo Medium for the dial numbers. The font file
// has no separate files per weight, so styles use the family name plus a weight.
// Always use monospaced digits for times.

enum Typeface {
    static func chivo(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        .custom("Chivo", size: size).weight(weight)
    }
}

/// Named text styles from the design. `tracking` is in points.
struct TextStyle {
    let font: Font
    /// The font's point size. Stored because SwiftUI's `Font` doesn't expose it.
    let size: CGFloat
    let tracking: CGFloat
    let uppercase: Bool

    init(size: CGFloat, weight: Font.Weight = .semibold, monospacedDigits: Bool = false, tracking: CGFloat, uppercase: Bool) {
        let font = Typeface.chivo(size, weight)
        self.font = monospacedDigits ? font.monospacedDigit() : font
        self.size = size
        self.tracking = tracking
        self.uppercase = uppercase
    }

    static let date       = TextStyle(size: 13, tracking: 1.82, uppercase: true)                             // "SAT 26 SEP"
    static let status     = TextStyle(size: 11, tracking: 1.54, uppercase: true)                             // "6 APPS LOCKED"
    static let label      = TextStyle(size: 12, tracking: 1.68, uppercase: true)                             // "LEFT TODAY"
    static let heroTime   = TextStyle(size: 112, monospacedDigits: true, tracking: -3.36, uppercase: false)  // "1:12"
    static let button     = TextStyle(size: 17, tracking: 0.34, uppercase: false)                            // "Unlock 15 min"
    static let dialNumber = TextStyle(size: 27, weight: .medium, tracking: 0, uppercase: false)              // "15"
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.font(style.font)
            .tracking(style.tracking)
            .textCase(style.uppercase ? .uppercase : nil)
    }

    /// Matches a CSS `line-height` from the design, such as 0.92 on the hero
    /// number. Chivo's natural line height is 1.19 times the font size, so this
    /// trims or adds the difference evenly above and below.
    func lineHeight(_ multiple: CGFloat, fontSize: CGFloat) -> some View {
        padding(.vertical, (multiple - 1.19) / 2 * fontSize)
    }
}

// MARK: - Metrics (points, on a 390 pt wide screen)

enum Metrics {
    static let screenPadding: CGFloat = 24
    /// Content starts at least this far from the top of the screen. Only phones
    /// with a short status bar (home-button iPhones) need the extra room.
    static let minimumTopInset: CGFloat = 36
    static let minTapTarget: CGFloat = 44

    // Header
    static let headerLineGap: CGFloat = 3        // between the date and the status line
    static let statusDotSize: CGFloat = 7
    static let statusDotGap: CGFloat = 6         // between the dot and the status text
    static let idleDotRingWidth: CGFloat = 0.8

    // Vertical spacing down the screen
    static let labelTopSpacing: CGFloat = 24     // header → "LEFT TODAY"
    static let heroTopSpacing: CGFloat = 6       // label → hero number
    static let heroLineHeight: CGFloat = 0.92
    static let dialTopSpacing: CGFloat = 4       // hero number → dial

    // Round plastic button (Settings)
    static let roundButton: CGFloat = 44
    static let roundButtonLip: CGFloat = 2       // solid edge below, in `roundButtonLipColor`
    static let roundButtonLipColor = Color(hex: 0xCDC3B1)
    static let roundButtonIcon: CGFloat = 20
    static let roundButtonIconStroke: CGFloat = 1.5
    static let roundButtonGradientRadius: CGFloat = 0.75 // fraction of the button's width

    // Pill button (Unlock, Lock now)
    static let pillWidth: CGFloat = 200
    static let pillHeight: CGFloat = 54
    static let pillRadius: CGFloat = 27
    static let pillLip: CGFloat = 3              // solid edge below
    static let redPillLip = Color(hex: 0x97291A)
    static let creamPillLip = Color(hex: 0xC9BFAE)

    /// The wind-up timer. Its frame is 360 x 360 pt with the center at (180, 180).
    enum Dial {
        static let size: CGFloat = 360
        static let housingRadius: CGFloat = 170
        static let housingDepth: CGFloat = 17      // how far the housing's side shows below its top
        static let dialRadius: CGFloat = 151       // turning dial, including the ridged ring
        static let dialDepth: CGFloat = 5          // how far the dial's side shows below it
        static let knurlInnerRadius: CGFloat = 143.2
        static let knurlOuterRadius: CGFloat = 150.6
        static let knurlRidges = 96
        static let faceRadius: CGFloat = 142.4

        static let tickCount = 30                  // one per minute
        static let tickOuterRadius: CGFloat = 137.5
        static let majorTickInnerRadius: CGFloat = 114   // every 5 minutes
        static let minorTickInnerRadius: CGFloat = 124
        static let majorTickWidth: CGFloat = 3.4
        static let minorTickWidth: CGFloat = 1.9
        static let numberRadius: CGFloat = 96      // number centers, rotated to face outward

        static let degreesPerMinute: Double = 12   // the face turns this far per minute
        static let maxMinutes = 29                 // 0 is the first tick, so a full turn can't be set

        static let gripSize = CGSize(width: 168, height: 46)
        static let gripRadius: CGFloat = 23
        static let gripDepth: CGFloat = 7

        static let pointerWidth: CGFloat = 24
        static let pointerTop: CGFloat = 11        // from the top of the frame
        static let pointerTip: CGFloat = 46
        static let rivetRadius: CGFloat = 3.8
        static let rivetCenterY: CGFloat = 20
    }
}

// MARK: - Effects

enum Effects {
    /// Shadow under the round Settings button.
    static let roundButtonShadow = (color: Palette.shadow.opacity(0.16), radius: CGFloat(6), y: CGFloat(6))
    /// Shadow under the red Unlock button.
    static let redPillShadow = (color: Color(hex: 0x782814).opacity(0.25), radius: CGFloat(7), y: CGFloat(8))
    /// Shadow under the cream Lock now button.
    static let creamPillShadow = (color: Palette.shadow.opacity(0.18), radius: CGFloat(7), y: CGFloat(8))
    /// Glow around the live status dot.
    static let redDotGlow = (color: Palette.red.opacity(0.7), radius: CGFloat(3))
    /// Soft shadow the timer casts on the background.
    static let dialShadow = (color: Palette.shadow.opacity(0.2), radius: CGFloat(20), x: CGFloat(4), y: CGFloat(30))
    /// The faint grain on the plastic, drawn as a noise overlay.
    static let grainOpacity: Double = 0.05
}
