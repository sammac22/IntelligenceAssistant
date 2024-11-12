//
//  ModelProvider.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/28/24.
//

import Foundation

/// Represents a third party provider that we use to access a LLM.
enum ModelProvider {
    /// Anthropic - Only supported provider
    case anthropic
    /// Open AI - Future support pending
    case openAi
    
    var storageKey: String {
        switch self {
        case .anthropic:
            "AnthropicAPIKey"
        case .openAi:
            "OpenAIAPIKey"
        }
    }
    
    var displayName: String {
        switch self {
        case .anthropic:
            "Anthropic"
        case .openAi:
            "OpenAI"
        }
    }
    
    // Add new providers here if desired
    static var allProviders: [ModelProvider] {[
        .anthropic
    ]}
}
