//
//  BookingListDataModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 17/02/25.
//

import Foundation
struct BookingListDataModel: Codable {
    let bookingID, userID: Int?
    let guestName: String?
    let guestAvatar: String?
    let bookingStatus: String?
    let bookingDate: String?

    enum CodingKeys: String, CodingKey {
        case bookingID = "booking_id"
        case userID = "user_id"
        case guestName = "guest_name"
        case guestAvatar = "guest_avatar"
        case bookingStatus = "booking_status"
        case bookingDate = "booking_date"
    }
}
