//
//  ChatDataModel.swift
//  Zyvo
//
//  Created by ravi on 21/03/25.
//

import TwilioConversationsClient

// MARK: - Datum
struct ChatDataModel: Codable {
    let groupName, receiverID, receiverName: String?
    let receiverImage: String?
    let senderID, senderName, senderProfile, propertyTitle: String?
    var chatData : TCHConversation?

    enum CodingKeys: String, CodingKey {
        case groupName = "group_name"
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case receiverImage = "receiver_image"
        case senderID = "sender_id"
        case senderName = "sender_name"
        case senderProfile = "sender_profile"
        case propertyTitle = "property_title"
    }
}
