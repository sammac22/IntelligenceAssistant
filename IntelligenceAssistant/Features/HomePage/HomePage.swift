//
//  HomePage.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/29/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

@Reducer
struct HomePage {
    @ObservableState
    struct State: Equatable {
        var chat: ChatStore.State = .init()
    }
    
    enum Action {
        /// User tapps the account icon in the top right
        case accountTapped
        case chat(ChatStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .accountTapped:
                return .none
            case .chat:
                return .none
            }
        }
        Scope(state: \.chat, action: \.chat) {
            ChatStore()
        }
    }
}
