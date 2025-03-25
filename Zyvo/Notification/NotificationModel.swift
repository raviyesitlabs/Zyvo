//
//  NotificationModel.swift
//  Zyvo
//
//  Created by ravi on 27/02/25.
//


// MARK: - Datum
struct NotificationModel: Codable {
    let notificationID, userID: Int?
    let type, userType, title, message: String?
    let data: String?
    let isRead: Bool?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case userID = "user_id"
        case type
        case userType = "user_type"
        case title, message, data
        case isRead = "is_read"
        case createdAt = "created_at"
    }
}

