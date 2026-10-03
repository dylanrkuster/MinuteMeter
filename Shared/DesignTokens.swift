//  DesignTokens.swift
//  Design tokens for the light design (cream plastic, red accent).
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
    static let ink           = Color(hex: 0x1D1A16) // text, icons
    static let secondary     = Color(hex: 0x7A7163) // labels, status line
    static let unlockedText  = Color(hex: 0xB8361F) // "UNLOCKED" status
    static let onRed         = Color(hex: 0xFFFDF8) // text on the red button

    // Red accent
    static let red           = Color(hex: 0xD2402A) // live status dot

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

// MARK: - Typography
//
// Chivo SemiBold for all text. The font file
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
    /// The faint grain on the plastic, drawn as a noise overlay.
    static let grainOpacity: Double = 0.05
}
