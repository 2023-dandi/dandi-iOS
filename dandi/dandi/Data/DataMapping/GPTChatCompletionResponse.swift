//
//  GPTChatCompletionResponse.swift
//  dandi
//
//  Created by 김윤서 on 2023/05/14.
//

import Foundation

struct GPTChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [GPTChatChoice]
    let usage: GPTUsage
}

extension GPTChatCompletionResponse {
    func toDomain() -> ChatMessage {
        return ChatMessage(message: choices.first?.message.content ?? "")
    }
}

struct GPTChatChoice: Codable {
    let index: Int
    let message: GPTChatMessage
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct GPTChatMessage: Codable {
    let role: String
    let content: String
}

struct GPTUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct GPTChatRequest: Codable {
    let messages: [GPTChatMessage]
    let model: String
}
