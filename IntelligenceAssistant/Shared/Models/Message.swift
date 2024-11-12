//
//  Message.swift
//  IntelligenceAssistant
//
//  Created by Sam MacGinty on 11/2/24.
//

import Foundation


/// Generalized message used to represent information sent by either the user or a model.
struct Message: Equatable, Identifiable {
    let id: String
    /// Contents of the message.
    /// Can be extended to handle different data types.
    let body: String
    /// Sender of the message
    let source: Source
    
    /// Represents the origination of a Message
    enum Source {
        /// App user.
        case user
        /// LLM.
        case model
        /// Fallback case, should only be used in error cases.
        case unknown
    }
}

extension Message {
    static func random(
        id: String = UUID().uuidString,
        body: String = String.loremIpsum(length: Int.random(in: 50..<300)),
        source: Source = [Source.user, Source.model].randomElement() ?? .user
    ) -> Self {
        Message(id: id, body: body, source: source)
    }
}
