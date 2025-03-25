

//  LoginModel.swift
//  Zyvo
//  Created by ravi on 22/01/25

// MARK: - DataClass
struct LoginModel: Codable {
    let userID, otp: Int
    let otpSendTo: String
    let isprofilecomplete : Bool
   

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case otp
        case otpSendTo = "otp_send_to"
        case isprofilecomplete = "is_profile_complete"
       
    }
}


// MARK: - DataClass
struct SocialLoginModel: Codable {
    let userID: Int?
    let token: String?
    let isProfileComplete,isloginfirst: Bool?
    let fcmToken, deviceType, socialID: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
        case isProfileComplete = "is_profile_complete"
        case isloginfirst = "is_login_first"
        case fcmToken = "fcm_token"
        case deviceType = "device_type"
        case socialID = "social_id"
    }
}
