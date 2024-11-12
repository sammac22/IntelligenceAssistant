//
//  Account.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/2/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Account {
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
        /// A user tapped the submit button with an API key to update
        case updateAPIKey(ModelProvider, String)
    }
    
    @Dependency(\.apiKeyManager) var apiKeyManager
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .updateAPIKey(let provider, let apiKey):
                apiKeyManager.setKey(provider, apiKey)
                return .none
            }
        }
    }
}
