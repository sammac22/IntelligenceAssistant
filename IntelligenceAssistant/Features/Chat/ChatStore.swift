//
//  ChatStore.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChatStore {
    @ObservableState
    struct State: Equatable {
        var messages: [Message] = []
        var error: ClaudeAPIError? = nil
    }
    
    enum Action {
        /// User submits message
        case submitTapped(String)
        /// Valid message received from API
        case messageReceived(Message)
        /// Error received from API
        case errorReceived(ClaudeAPIError)
    }
    
    @Dependency(\.claudeAPIClient) var claudeApiClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .submitTapped(let userInput):
                let newMessage = Message(id: Date.now.description, body: userInput, source: .user)
                state.messages.append(newMessage)
                let currentMessages = state.messages
                return .run { send in
                    let response = await claudeApiClient.sendMessage(currentMessages)
                    switch response {
                    case .success(let message):
                        return await send(.messageReceived(message))
                    case .failure(let error):
                        return await send(.errorReceived(error))
                    }
                }
            case .messageReceived(let message):
                state.error = nil
                state.messages.append(message)
                return .none
            case .errorReceived(let error):
                state.error = error
                return .none
            }
        }
    }
}
