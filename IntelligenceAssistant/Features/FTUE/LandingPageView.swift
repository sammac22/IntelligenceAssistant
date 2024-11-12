//
//  LandingPageView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct LandingPageView: View {
    
    @Bindable var store: StoreOf<LandingPage>
    
    @State var apiKey: String = ""
    @State var showInput: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            consistentContent()
            
            if showInput {
                fadeInContent()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    fileprivate func consistentContent() -> some View {
        Image(systemName: "leaf")
            .resizable()
            .frame(width: 200, height: 200)
            .foregroundStyle(Color.platinum)
        Text("Intelligence Assistant")
            .font(.largeTitle)
            .foregroundStyle(Color.textPrimary)
        TypewriterText("Everyone needs an assistant for their assistants", delay: .milliseconds(50)) {
            withAnimation(.easeIn(duration: 1)) {
                showInput = true
            }
        }
            .font(.subheadline)
            .foregroundStyle(Color.textPrimary)
    }
    
    @ViewBuilder
    fileprivate func fadeInContent() -> some View {
        VStack(spacing: 12) {
            Spacer()
                .frame(height: 50)
            
            MinimalTextField(text: $apiKey, placeholder: "Enter your Anthropic API key")

            Button("Let's Go") {
                store.send(.submitAPIKey(apiKey))
            }
            .padding(8)
            .background(apiKey.isEmpty ? Color.background : Color.buttonPrimary)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .disabled(apiKey.isEmpty)
            .animation(.easeInOut(duration: 0.3), value: apiKey.isEmpty)

        }
        .frame(maxWidth: 300)
    }
}

#Preview {
    LandingPageView(store: .init(initialState: LandingPage.State(), reducer: { LandingPage() }))
    .background(Color.background)
}
