//
//  AccountView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/2/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct AccountView: View {
    @Bindable var store: StoreOf<Account>
    
    @State private var selectedProvider: ModelProvider = .anthropic
    @State private var newAPIKey: String = ""
    @State private var presentSuccessPop: Bool = false
    
    var body: some View {
        VStack {
            FunAnimationView()
            
            List {
                Section {
                    Picker("Edit your API key for:", selection: $selectedProvider) {
                        ForEach(ModelProvider.allProviders, id: \.self) { provider in
                            Text(provider.displayName)
                        }
                    }
                    TextField("API Key", text: $newAPIKey)
                    Button(action: {
                        presentSuccessPop = true
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Submit")
                            Spacer()
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                    .disabled(newAPIKey.isEmpty)
                } header: {
                    Text("Model Settings")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .confirmationDialog("Are you sure you want to overwrite your \(selectedProvider.displayName) API key?", isPresented: $presentSuccessPop, presenting: newAPIKey) { newKey in
            Button {
                store.send(.updateAPIKey(selectedProvider, newAPIKey))
                newAPIKey = ""
            } label: {
                Text("Set key as \(newKey)")
            }
            Button("Cancel", role: .cancel) {
                presentSuccessPop = false
            }
            
        }
    }
}

/// A fun animation of circles to make an otherwise boring account page pop.
fileprivate struct FunAnimationView: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)

            ForEach(0..<5) { index in
                Circle()
                    .fill(self.getColor(for: index))
                    .frame(width: animate ? CGFloat(100 + index * 50) : CGFloat(200 - index * 40),
                           height: animate ? CGFloat(100 + index * 50) : CGFloat(200 - index * 40))
                    .scaleEffect(animate ? 1.5 : 0.5)
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .opacity(animate ? 0.6 : 1)
                    .animation(
                        .easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate.toggle()
        }
    }
    
    private func getColor(for index: Int) -> Color {
        switch index {
        case 0: return .arylideYellow
        case 1: return .myrtleGreen
        case 2: return .coral
        case 3: return .platinum
        default: return .jet
        }
    }
}
