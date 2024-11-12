//
//  AccountTests.swift
//  IntelligenceAssistantTests
//
//  Created by Sam MacGinty on 11/11/24.
//

import ComposableArchitecture
import Foundation
import XCTest

@testable import IntelligenceAssistant

final class AccountTests: XCTestCase {
    func testUpdateAPIKey() async {
        var keyStorage: [ModelProvider: String] = [:]

        let store = await TestStore(initialState: Account.State()) {
            Account()
        } withDependencies: {
            $0.apiKeyManager = .init(
                setKey: { provider, id in keyStorage[provider] = id },
                getKey: { _ in nil },
                checkKeys: { true }
            )
        }
        
        let provider = ModelProvider.anthropic
        let key = "testkey"
        
        XCTAssertNil(keyStorage[provider])
        
        await store.send(.updateAPIKey(provider, key))
        
        XCTAssertEqual(keyStorage[provider], key)
        
    }
}
