//
//  APIKeyManager.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation
import Dependencies


/// Handles the management of a users API keys.
protocol APIKeyManagerProtocol {
    /// Set this string as the key for the specified provider.
    var setKey: (ModelProvider, String) -> Void { get }
    /// Get the key for the specified provider. Returns nil if it does not exist.
    var getKey: (ModelProvider) -> String? { get }
    /// Check if we have any API keys stored.
    var checkKeys: () -> Bool { get }
}

struct APIKeyManager: APIKeyManagerProtocol {
    var setKey: (ModelProvider, String) -> Void
    var getKey: (ModelProvider) -> String?
    var checkKeys: () -> Bool
    
    init(setKey: @escaping (ModelProvider, String) -> Void,
         getKey: @escaping (ModelProvider) -> String?,
         checkKeys: @escaping () -> Bool) {
        self.setKey = setKey
        self.getKey = getKey
        self.checkKeys = checkKeys
    }
    
    static let live: APIKeyManager = .init(
        setKey: { provider, apiKey in
            UserDefaults.standard.set(apiKey, forKey: provider.storageKey)
        },
        getKey: { provider in
            UserDefaults.standard.string(forKey: provider.storageKey)
        },
        checkKeys: {
            for provider in ModelProvider.allProviders {
                if let _ = UserDefaults.standard.string(forKey: provider.storageKey) {
                    return true
                }
            }
            return false
        }
    )
}

// MARK: - TCA Conformance
extension APIKeyManager: DependencyKey {
    static let liveValue = APIKeyManager.live
    
    static let testValue: APIKeyManager = .init(setKey: { _, _ in }, getKey: { _ in nil }, checkKeys: { true })
}

extension DependencyValues {
    var apiKeyManager: APIKeyManager {
        get { self[APIKeyManager.self] }
        set { self[APIKeyManager.self] = newValue }
    }
}
