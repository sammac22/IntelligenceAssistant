//
//  ClaudeAPIClient.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 10/30/24.
//

import Alamofire
import Foundation
import Dependencies

/// API Client to handle requests to Claude
protocol ClaudeAPIClientProtocol {
    /// Send a message to Claude. You must include all message history as the API is stateless. Only the new message is returned.
    var sendMessage: ([Message]) async -> Result<Message, ClaudeAPIError> { get }
}

struct ClaudeAPIClient: ClaudeAPIClientProtocol {
    var sendMessage: ([Message]) async  -> Result<Message, ClaudeAPIError>
    
    static let baseUrl = "https://api.anthropic.com/v1/messages"
    
    init(sendMessage: @escaping ([Message]) async  -> Result<Message, ClaudeAPIError>) {
        self.sendMessage = sendMessage
    }
    
    @Dependency(\.apiKeyManager) static var apiKeyManager
    
    static let live: ClaudeAPIClient = .init(
        sendMessage: { messages in
            guard let apiKey = apiKeyManager.getKey(.anthropic) else { return .failure(ClaudeAPIError.noApiKey) }
            let requestBody = ClaudeRequest(messages)
            let headers: HTTPHeaders = [
                "x-api-key": apiKey,
                "anthropic-version": "2023-06-01",
                "content-type": "application/json"
            ]
            
            return await withCheckedContinuation { continuation in
                AF.request(baseUrl,
                           method: .post,
                           parameters: requestBody,
                           encoder: JSONParameterEncoder.default,
                           headers: headers)
                .validate()
                .responseDecodable(of: ClaudeResponse.self) { response in
                    switch response.result {
                        case .success(let data):
                            continuation.resume(returning: .success(Message(data)))
                        case .failure(let error):
                            var errorMessage: String? = nil
                            if let data = response.data {
                                errorMessage = String(data: data, encoding: .utf8)
                            }
                            continuation.resume(returning: .failure(.httpError(errorMessage)))
                        }
                    }
            }
        }
    )
    
    static let test: ClaudeAPIClient = .init(sendMessage: { _ in
        return .success(Message(.mock()))
    })
}

enum ClaudeAPIError: Error, Equatable {
    case noApiKey
    case httpError(String?)
}

// MARK: - Contracts
struct ClaudeRequest: Codable {
    init(model: String = "claude-3-5-sonnet-20241022",
         max_tokens: Int = 1024,
         messages: [ClaudeRequest.ClaudeMessage]) {
        self.model = model
        self.max_tokens = max_tokens
        self.messages = messages
    }
    
    init(_ messages: [Message]) {
        self.init(messages: messages.map { ClaudeMessage($0) })
    }
    
    let model: String
    let max_tokens: Int
    let messages: [ClaudeRequest.ClaudeMessage]
    
    struct ClaudeMessage: Codable {
        let role: String
        let content: String
        
        init(_ message: Message) {
            self.role = message.claudeRole
            self.content = message.body
        }
    }
}

struct ClaudeResponse: Codable {
    let id: String
    let type: String
    let role: String
    let content: [ClaudeResponse.Content]
    let stop_reason: String
    let stop_sequence: String?
    let usage: UsageMetrics
    
    struct UsageMetrics: Codable {
        let input_tokens: Int
        let output_tokens: Int
    }
    
    struct Content: Codable {
        let type: String
        let text: String
    }
    
    static func mock() -> Self {
        .init(
            id: UUID().uuidString,
              type: "",
              role: "assistant",
            content: [.init(type: "text", text: String.loremIpsum(length: 200))],
              stop_reason: "",
              stop_sequence: nil,
            usage: .init(input_tokens: 0, output_tokens: 0)
        )
    }
}

// MARK: - Helpers

fileprivate extension Message {
    var claudeRole: String {
        switch self.source {
        case .user:
            return "user"
        case .model:
            return "assistant"
        case .unknown:
            return ""
        }
    }
    
    init(_ claudeContent: ClaudeResponse) {
        self.id = claudeContent.id
        self.body = claudeContent.content.reduce(into: "") {
            $0 += " " + $1.text
        }
        self.source = .init(claudeRole: claudeContent.role)
    }
}

fileprivate extension Message.Source {
    init(claudeRole: String) {
        switch claudeRole.lowercased() {
        case "user":
            self = .user
        case "assistant":
            self = .model
        default:
            self = .unknown
        }
    }
}


// MARK: - TCA Conformance
extension ClaudeAPIClient: DependencyKey {
    static let liveValue = ClaudeAPIClient.live
    
    static var testValue: ClaudeAPIClient { .test }
}

extension DependencyValues {
    var claudeAPIClient: ClaudeAPIClient {
        get { self[ClaudeAPIClient.self] }
        set { self[ClaudeAPIClient.self] = newValue }
    }
}
