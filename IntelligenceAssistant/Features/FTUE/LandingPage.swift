//
//  LandingPage.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct LandingPage {
    @ObservableState
    struct State: Equatable { }
    
    enum Action {
        /// User submits API key
        case submitAPIKey(String)
    }
    
    @Dependency(\.apiKeyManager) var apiKeyManager
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .submitAPIKey(let apiKey):
                apiKeyManager.setKey(.anthropic, apiKey)
                return .none
            }
        }
    }
}
