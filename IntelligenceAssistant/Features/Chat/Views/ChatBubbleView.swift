//
//  ChatBubbleView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/29/24.
//

import Foundation
import SwiftUI

struct ChatBubbleView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.source == .user {
                Spacer()
                    .frame(minWidth: 24, maxWidth: .infinity)
            }
            
            textView()
                .padding(6)
                .foregroundStyle(textColor)
                .background(backgroundColor)
                .cornerRadius(8)
                .layoutPriority(1.0)
            
            if message.source == .model {
                Spacer()
                    .frame(minWidth: 24, maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder
    fileprivate func textView() -> some View {
        switch message.source {
        case .user, .unknown:
            Text(message.body)
        case .model:
            TypewriterText(message.body)
        }
    }
}

// MARK: - Styling
fileprivate extension ChatBubbleView {
    var backgroundColor: Color {
        switch message.source {
        case .user, .unknown:
                .myrtleGreen
        case .model:
                .arylideYellow
        }
    }
    
    var textColor: Color {
        switch message.source {
        case .user, .unknown:
                .textPrimary
        case .model:
                .textSecondary
        }
    }
}

#Preview {
    VStack {
        ChatBubbleView(message: Message.random())
        ChatBubbleView(message: Message.random())
        ChatBubbleView(message: Message.random())
        ChatBubbleView(message: Message.random())
    }
    .background(Color.background)
}
