//
//  Coloring.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/1/24.
//

import Foundation
import SwiftUI

// MARK: - Base Colors
extension Color {
    static var arylideYellow: Color = Color(hex: "E9D758")
    static var myrtleGreen: Color = Color(hex: "297373")
    static var coral: Color = Color(hex: "FF8552")
    static var platinum: Color = Color(hex: "E6E6E6")
    static var jet: Color = Color(hex: "39393A")
}

// MARK: - Semantic Colors
extension Color {
    static var background: Color { .jet }
    static var buttonPrimary: Color { .myrtleGreen }
    static var textPrimary: Color { .platinum }
    static var textSecondary: Color { .jet }
}


// MARK: - Helpers
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, int >> 24 & 0xFF)
        default:
            (r, g, b, a) = (1, 1, 1, 1) // Default to white for invalid input
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
