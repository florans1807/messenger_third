//
//  ConversationModels.swift
//  Messenger
//
//  Created by Флоранс on 12.12.2023.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
