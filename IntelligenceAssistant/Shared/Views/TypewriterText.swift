//
//  TypewriterText.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import SwiftUI

/// Text view that "types" out the content, simulating a typewriter printing.
struct TypewriterText: View {
    let text: String
    let onTypingFinished: () -> Void
    var delay: Duration
    @State fileprivate var finalText: String = ""
    
    /// Create a Text view that types out its content like a typewriter.
    /// - Parameters:
    ///   - text: Text to display.
    ///   - delay: Time in between each letter getting typed.
    ///   - onTypingFinished: Callback to inform consumer the typing is finished.
    init(_ text: String, delay: Duration = .milliseconds(10), onTypingFinished: @escaping () -> Void = { }) {
        self.text = text
        self.delay = delay
        self.onTypingFinished = onTypingFinished
    }
    
    var body: some View {
        Text(finalText)
            .onAppear {
                Task {
                    await animateText()
                }
            }
            .onChange(of: finalText) {
                if finalText == text {
                    onTypingFinished()
                }
            }
    }
    
    fileprivate func animateText() async {
        for character in text {
            finalText.append(character)
            try? await Task.sleep(for: delay)
        }
    }
}
