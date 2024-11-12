//
//  ChatView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ChatView: View {

    @Bindable var store: StoreOf<ChatStore>
    
    @State private var wave = false
    
    var body: some View {
        VStack {
            if store.messages.isEmpty {
                Spacer()
                handWave()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(store.messages) { message in
                            ChatBubbleView(message: message)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollIndicators(.hidden)
            }
            
            Spacer()
            userInputView()
                .padding(.horizontal)
        }
        .background(Color.background)
    }
    
    @State var inputValue: String = ""
    
    @ViewBuilder
    fileprivate func userInputView() -> some View {
        HStack {
            MinimalTextField(text: $inputValue, placeholder: "Say hello")
            
            Button(action: {
                store.send(.submitTapped(inputValue))
                inputValue = ""
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20))
                    .padding(12)
                    .foregroundColor(
                        inputValue.isEmpty ? Color.textPrimary : Color.buttonPrimary
                    )
                    .cornerRadius(12)
                    .animation(.easeInOut(duration: 0.3), value: inputValue.isEmpty)
            }
            .disabled(inputValue.isEmpty)
        }
    }
    
    @ViewBuilder
    fileprivate func handWave() -> some View {
        Image(systemName: "hand.wave")
            .resizable()
            .frame(width: 200, height: 200)
            .foregroundStyle(Color.platinum)
            .rotationEffect(.degrees(wave ? 10 : -10), anchor: .center)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.3)
                        .repeatCount(5, autoreverses: true)
                ) {
                    wave.toggle()
                }
            }
    }
}

#Preview {
    ChatView(store: .init(
        initialState: ChatStore.State(messages: (0..<8).map { _ in Message.random() }),
        reducer: { ChatStore() }))
    .background(Color.background)
}
