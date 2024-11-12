//
//  MinimalTextField.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/2/24.
//

import SwiftUI

/// Simple TextField wrapper to contain simplistic styling.
/// A single line underneath the TextField.
struct MinimalTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack {
            TextField("",
                      text: $text,
                      prompt: Text(placeholder)
                .foregroundColor(Color.textPrimary)
            )
                .foregroundColor(Color.textPrimary)
                .padding(.vertical, 8)
                .tint(Color.myrtleGreen)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.textPrimary),
                    alignment: .bottom
                )
        }
    }
}

#Preview {
    @State var text: String = ""
    return VStack {
        Spacer()
        MinimalTextField(text: $text, placeholder: "Enter text...")
            .padding()
        Spacer()
    }
    .background(Color.background)
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
}

