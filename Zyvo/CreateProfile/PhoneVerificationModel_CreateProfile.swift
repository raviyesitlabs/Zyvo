//
//  PhoneVerificationModel_CreateProfile.swift
//  Zyvo
//
//  Created by ravi on 27/01/25.
//

// MARK: - DataClass
struct PhoneVerificationModel_CreateProfile: Codable {
    let userID: Int?
    let phoneNumber: String?
    let otp: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case phoneNumber = "phone_number"
        case otp
    }
}


// MARK: - DataClass
struct UpdateMobileNumber: Codable {
    let userID: Int?
    let phoneNumber: String?
    let otp: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case phoneNumber = "otp_send_to"
        case otp
    }
}
