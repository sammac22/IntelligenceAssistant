//
//  ChatTests.swift
//  IntelligenceAssistantTests
//
//  Created by Sam MacGinty on 11/11/24.
//

import ComposableArchitecture
import Foundation
import XCTest

@testable import IntelligenceAssistant

final class ChatStoreTests: XCTestCase {

    func testSubmitTappedAndMessageReceived() async {
        let mockMessage = Message(id: "123", body: "Hello, world!", source: .model)
        let mockAPIClient = ClaudeAPIClient { _ in
            return .success(mockMessage)
        }

        let store = await TestStore(initialState: ChatStore.State()) {
            ChatStore()
        } withDependencies: {
            $0.claudeAPIClient = mockAPIClient
        }

        let userMessage = "Test message"
        await store.send(.submitTapped(userMessage)) {
            $0.messages = [Message(id: Date.now.description, body: userMessage, source: .user)]
        }
        
        await store.receive {
            guard case .messageReceived(mockMessage) = $0 else { return false }
            return true
        } assert: { state in
            state.messages.append(mockMessage)
            state.error = nil
        }
    }

    func testSubmitTappedAndErrorReceived() async {
        let mockMessage = ClaudeAPIError.httpError("Mock error")
        let mockAPIClient = ClaudeAPIClient { _ in
            return .failure(mockMessage)
        }

        let store = await TestStore(initialState: ChatStore.State()) {
            ChatStore()
        } withDependencies: {
            $0.claudeAPIClient = mockAPIClient
        }

        let userMessage = "Test message"
        await store.send(.submitTapped(userMessage)) {
            $0.messages = [Message(id: Date.now.description, body: userMessage, source: .user)]
        }
        
        await store.receive {
            guard case .errorReceived(mockMessage) = $0 else { return false }
            return true
        } assert: { state in
            state.error = mockMessage
        }
    }

    func testMessageReceivedClearsError() async {
        let initialError = ClaudeAPIError.httpError("Initial error")
        let mockMessage = Message(id: "456", body: "API response", source: .model)
        
        let store = await TestStore(
            initialState: ChatStore.State(
                messages: [],
                error: initialError
            )) {
                ChatStore()
            }

        await store.send(.messageReceived(mockMessage)) {
            $0.messages.append(mockMessage)
            $0.error = nil
        }
    }

    func testErrorReceivedSetsError() async {
        let mockError = ClaudeAPIError.noApiKey

        let store = await TestStore(
            initialState: ChatStore.State(
                messages: [],
                error: nil
            )) {
                ChatStore()
            }

        await store.send(.errorReceived(mockError)) {
            $0.error = mockError
        }
    }
}

