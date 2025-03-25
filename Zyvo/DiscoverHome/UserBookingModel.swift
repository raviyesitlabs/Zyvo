//
//  UserBookingModel.swift
//  Zyvo
//
//  Created by ravi on 13/03/25.
//




// MARK: - DataClass
struct UserBookingModel: Codable {
    let properties: [UserProperty]?
    let bookings: [UserBooking]?
}

// MARK: - Booking
struct UserBooking: Codable {
    let paymentID, bookingStart: String?
    let guestUserID: Int?
    let selectedAddOns: [String]?
    let tax: String?
    let hostUserID: Int?
    let bookingEnd: String?
    let bookingID: Int?
    let extensionHours: Int?
    let cleaningFee: String?
    let bookingExtensionAmount: String?
    let bookingAmount: String?
    let bookingHours, totalAddonPrice: Int?
    let bookingDate, status, bookingHourlyRate, discountPercent: String?
    let finalBookingEnd, serviceFee, totalAmount: String?
    let propertyID: Int?

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case bookingStart = "booking_start"
        case guestUserID = "guest_user_id"
        case selectedAddOns = "selected_add_ons"
        case tax
        case hostUserID = "host_user_id"
        case bookingEnd = "booking_end"
        case bookingID = "booking_id"
        case extensionHours = "extension_hours"
        case cleaningFee = "cleaning_fee"
        case bookingExtensionAmount = "booking_extension_amount"
        case bookingAmount = "booking_amount"
        case bookingHours = "booking_hours"
        case totalAddonPrice = "total_addon_price"
        case bookingDate = "booking_date"
        case status
        case bookingHourlyRate = "booking_hourly_rate"
        case discountPercent = "discount_percent"
        case finalBookingEnd = "final_booking_end"
        case serviceFee = "service_fee"
        case totalAmount = "total_amount"
        case propertyID = "property_id"
    }
    
  
}

// MARK: - Property
struct UserProperty: Codable {
    let hostProfileImage, hourlyRate: String?
    let activities: [String]?
    let isInWishlist: Int?
    let hostRules, minBookingHours: String?
    let isInstantBook: Int?
    let tax: String?
    let amenities: [String]?
    let reviews: [Review]?
    let bulkDiscountRate, cleaningFee, address: String?
    let propertySize: Int?
    let images: [String]?
    let propertyID: Int?
    let reviewsTotalCount, hostedBy, reviewsTotalRating, propertyDescription: String?
    let propertyTitle, longitude: String?
    let bulkDiscountHour: Int?
    let parkingRules: String?
    let hostID: Int?
    let serviceFee, latitude: String?
    let addOns: [AddOn]?

    enum CodingKeys: String, CodingKey {
        case hostProfileImage = "host_profile_image"
        case hourlyRate = "hourly_rate"
        case activities
        case isInWishlist = "is_in_wishlist"
        case hostRules = "host_rules"
        case minBookingHours = "min_booking_hours"
        case isInstantBook = "is_instant_book"
        case tax, amenities, reviews
        case bulkDiscountRate = "bulk_discount_rate"
        case cleaningFee = "cleaning_fee"
        case address
        case propertySize = "property_size"
        case images
        case propertyID = "property_id"
        case reviewsTotalCount = "reviews_total_count"
        case hostedBy = "hosted_by"
        case reviewsTotalRating = "reviews_total_rating"
        case propertyDescription = "property_description"
        case propertyTitle = "property_title"
        case longitude
        case bulkDiscountHour = "bulk_discount_hour"
        case parkingRules = "parking_rules"
        case hostID = "host_id"
        case serviceFee = "service_fee"
        case latitude
        case addOns = "add_ons"
    }
}

//// MARK: - AddOn
//struct AddOn: Codable {
//    let name, price: String?
//}

// MARK: - Review
//struct Review: Codable {
//    let reviewRating, profileImage, reviewerName, reviewDate: String?
//    let reviewMessage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case reviewRating = "review_rating"
//        case profileImage = "profile_image"
//        case reviewerName = "reviewer_name"
//        case reviewDate = "review_date"
//        case reviewMessage = "review_message"
//    }
//}
