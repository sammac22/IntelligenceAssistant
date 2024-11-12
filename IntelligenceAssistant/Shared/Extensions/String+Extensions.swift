//
//  String+Extensions.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/2/24.
//

import Foundation

extension String {
    
    /// Generate filler text
    /// - Parameter length: Text length desired.
    /// - Returns: String containing generated text.
    static func loremIpsum(length: Int) -> String {
        let loremText = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        
        // Repeat the text to ensure we have enough length to work with
        var generatedText = String(repeating: loremText, count: (length / loremText.count) + 1)
        
        // Truncate to the specified length
        generatedText = String(generatedText.prefix(length))
        
        // Trim any incomplete word at the end
        if let lastSpaceIndex = generatedText.lastIndex(of: " ") {
            generatedText = String(generatedText[..<lastSpaceIndex])
        }
        
        return generatedText
    }
}
