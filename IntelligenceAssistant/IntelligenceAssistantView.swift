//
//  IntelligenceAssistantView.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct IntelligenceAssistantView: View {
    @Bindable var store: StoreOf<IntelligenceAssistant>
    
    var body: some View {
        Group {
            if store.hasAPIKey {
                NavigationStack(
                    path: $store.scope(state: \.path, action: \.path),
                    root: {
                        IfLetStore(store.scope(state: \.homePageState, action: \.homePage)) { store in
                            HomePageView(store: store)
                        }
                    },
                    destination: { store in
                        switch store.case {
                        case .accountPage(let store):
                            AccountView(store: store)
                        case .chat(let store):
                            ChatView(store: store)
                        }
                    }
                )
                .transition(.opacity)
                .background(Color.background)
                .tint(.buttonPrimary)
            } else {
                IfLetStore(store.scope(state: \.landingPageState, action: \.landingPage)) { store in
                    LandingPageView(store: store)
                }
                .transition(.opacity)
                .background(Color.background)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.hasAPIKey)
    }
}
