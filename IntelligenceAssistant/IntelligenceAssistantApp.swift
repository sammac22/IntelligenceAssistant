//
//  IntelligenceAssistantApp.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct IntelligenceAssistantApp: App {
    let store = Store(initialState: .init()) {
        IntelligenceAssistant()
    }
    
    init() {
        store.send(.initialize)
    }

    var body: some Scene {
        WindowGroup {
            IntelligenceAssistantView(store: store)
        }
    }
}
