//
//  DiscoverVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import Combine
import CoreLocation

@available(iOS 14.0, *)
class DiscoverVC: UIViewController,LocationPickerDelegate {
    
    @IBOutlet weak var lbl_seconds: UILabel!
    @IBOutlet weak var lbl_minutes: UILabel!
    @IBOutlet weak var lbl_hours: UILabel!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Search: UIView!
    
    @IBOutlet weak var view_RemainingTime: UIView!
    // Timer properties
    var timer: Timer?
    var totalSeconds = 0 // Initial time in seconds
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = HomeDataViewModel()
    
    var comingFrom = ""
    //FilterData
    var timess: Int = 0
    
    
    var startTime = ""
    var endTime = ""
    var propertyID = ""
    var profileIMGURL = ""
    var propertyIMGURL = ""
    var propertyName = ""
    var propertyRating = ""
    var propertyNumberofReview = ""
    var propertyDistanceInMiles = ""
    var hostName = ""
    var bookingID = ""
    var cardID = ""
    var property_id = ""
    var booking_start = ""
    var booking_end = ""
    var booking_date = ""
    var booking_hours : Int? = 0
    var perHourRate : Int? = 0
    var minBookhours : Int? = 0
    var total_amount : Double? = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var tax : Double? = 0
    var StartDatetime = ""
    var EndDatetime = ""
    var addOnsArr: [AddOn] = []
    var arrSelectedArr :[Int] = []
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    var zyvoServicePercentage : Double? = 0
    
    var parkDesc = ""
    var HostingRulesDesc = ""
    
    var getHomeDataArr : [HomeDataModel]?
    
    var getUserBooking : UserBookingModel?
    
    var getBookingArr : [UserBooking]?
    
    var getUserBookingPropertyArr : [UserProperty]?
   
    let dateTimer = CurrentDateTimer()
    
    let calculator = TimeDifferenceCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  APIManager.shared.apiforGetChatToken(role: "guest") { t in }
        
        view_RemainingTime.isHidden = true
        
        LocationPicker.shared.delegate = self
        LocationPicker.shared.checkLocationPermission()

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        bindVC()
        
//        dateTimer.startTimer { currentDate, currentDateTime in
//            print("Current Date: \(currentDate) | Current Date and Time: \(currentDateTime)")
            
            self.viewModel.bookingStart =  "2025-03-19 15:12:59"//"\(currentDateTime)"
            self.viewModel.bookingDate = "2025-03-19"//"\(currentDate)"
            self.viewModel.apiforGetBookedPropertyTimer()
        //}
      
       
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        let nib2 = UINib(nibName: "HomeCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "HomeCell")
        collecV.delegate = self
        collecV.dataSource = self
        collecV.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if comingFrom == "" {
            self.viewModel.apiforGetHomeData()
        }
       
        self.tabBarController?.tabBar.isHidden = false
        
    }
    @objc func appDidBecomeActive() {
        // When the app returns from settings, check location again
        LocationPicker.shared.checkLocationPermission()
    }
    
    // MARK: - LocationManagerHelperDelegate Methods
    func didUpdateLocation(latitude: Double, longitude: Double) {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        self.viewModel.latitude = "\(latitude)"
        self.viewModel.longitude = "\(longitude)"
        self.viewModel.apiforGetHomeData()
    }
    
    func didFailWithError(error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    func startTimer(hours: Int, minutes: Int, seconds: Int) {
        // Convert hours, minutes, and seconds to total seconds
        totalSeconds = hours * 3600 + minutes * 60 + seconds
        
        // Invalidate any existing timer
        timer?.invalidate()
        
        // Start a new timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if totalSeconds > 0 {
            totalSeconds -= 1 // Decrease the total seconds
            printTimeComponents(from: totalSeconds)
            
            //  Convert totalSeconds back to hours, minutes, and seconds
                  let hours = totalSeconds / 3600
                  let minutes = (totalSeconds % 3600) / 60
                  let seconds = totalSeconds % 60
                  
                  //  Print remaining time continuously
                //  print("Remaining Time: \(hours) hours, \(minutes) minutes, \(seconds) seconds")
                  
                  // Show popup when exactly 30 minutes remaining
            
            if hours == 0, minutes == 30, seconds == 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeedMoreTimePopUpVC") as! NeedMoreTimePopUpVC
                vc.backAction = { str in
                    print(str,"Data Recieved")
                    if str == "Yes" {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
                        vc.perHourRate = self.perHourRate ?? 0
                        vc.backAction = {  str, str2 in
                            
                            print(str,str2,"dataReceived")
                            self.booking_hours = str
                            self.booking_amount =  Double(str2) ?? 0.0
                            self.DiscountPercentage = Double(self.getUserBookingPropertyArr?[0].bulkDiscountRate ?? "")
                            self.taxPercentage = Double(self.getUserBookingPropertyArr?[0].tax ?? "")
                            self.bookingID = ("\(self.getBookingArr?[0].bookingID ?? 0)")
                            self.hostName = self.getUserBookingPropertyArr?[0].hostedBy ?? ""
                            self.propertyName = self.getUserBookingPropertyArr?[0].propertyTitle ?? ""
                            
                           
                            self.propertyRating = self.getUserBookingPropertyArr?[0].reviewsTotalRating ?? ""
                            self.propertyNumberofReview = "(\(self.getUserBookingPropertyArr?[0].reviewsTotalCount ?? "") reviews)"
                            
                            var image = self.getUserBookingPropertyArr?[0].hostProfileImage ?? ""
                            let imgURL = AppURL.imageURL + image
                            self.profileIMGURL = imgURL
                            
                            self.StartDatetime = self.getBookingArr?[0].bookingStart ?? ""
                            self.EndDatetime = self.getBookingArr?[0].bookingEnd ?? ""
                            self.booking_date = self.getBookingArr?[0].bookingDate ?? ""
                            self.property_id = "\(self.getUserBookingPropertyArr?[0].propertyID ?? 0)"
                            self.parkDesc = "\(self.getUserBookingPropertyArr?[0].parkingRules ?? "")"
                            self.HostingRulesDesc = "\(self.getUserBookingPropertyArr?[0].hostRules ?? "")"
                           
                            let cleaningFees = self.getUserBookingPropertyArr?[0].cleaningFee ?? ""
                            if let doubleValue = Double(cleaningFees) {
                                self.ClearningFee = doubleValue
                                print(self.ClearningFee ?? 0.0,"ClearningFee") // Output: 10
                            }
                            
                           // let zyvoFeePercentage = Double(self.getUserBookingPropertyArr?[0].serviceFee ?? "0.0") ?? 0.0
                           // self.zyvoServicePercentage = zyvoFeePercentage
                           
                            
                            
                            let zyvoServiceFees = self.getUserBookingPropertyArr?[0].serviceFee ?? ""
                            if let doubleValue = Double(zyvoServiceFees) {
                                
                                self.zyvoServiceFee = ((self.booking_amount ?? 0.0) * doubleValue) / 100.0
                               // self.zyvoServiceFee = doubleValue
                                print(self.zyvoServiceFee ?? 0.0,"zyvoServiceFee") // Output: 10
                            }
                            if let addonPrices = self.getBookingArr?.first?.totalAddonPrice {
                                if let doubleValue = Double("\(addonPrices)") {
                                    self.AddonOnsPrice = doubleValue
                                    print(self.AddonOnsPrice ?? 0, "AddonOnsPrice") // Output: 10.0
                                }
                            }
                            
                            if let propertySize = self.getUserBookingPropertyArr?.first?.propertySize {
                                self.propertyDistanceInMiles = "\(propertySize)"
                                print(self.propertyDistanceInMiles , "propertyDistanceInMiles") // Output: 10.0
                            }
                            
                            
                            let bookingStart = self.getBookingArr?.first?.bookingStart ?? ""
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                            if let date = dateFormatter.date(from: bookingStart) {
                                dateFormatter.dateFormat = "hh:mm a"
                                let formattedTime = dateFormatter.string(from: date)
                                self.startTime = formattedTime
                                print(formattedTime) // Output: 03:12 PM
                            }
                            
                            let bookingEnd = self.getBookingArr?.first?.bookingEnd ?? ""
                           
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                            if let date = dateFormatter.date(from: bookingEnd) {
                                dateFormatter.dateFormat = "hh:mm a"
                                let formattedTime = dateFormatter.string(from: date)
                                self.endTime = formattedTime
                                print(formattedTime) // Output: 03:12 PM
                            }
                            
                            self.addOnsArr = self.getUserBookingPropertyArr?[0].addOns ?? []
                            
                            print(self.booking_hours ?? 0,self.booking_amount ?? 0.0,"self.booking_hours,self.booking_amount")
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExtraTimeExtentionVC") as! ExtraTimeExtentionVC
                            
                            if (self.booking_hours ?? 0) > (self.minBookhours ?? 0) {
                                let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                                print("================================WithDiscount====================================")
                                // Printing the Result
                                print("Total Price: \(result.totalPrice)")
                                print("Discount Amount (\(String(describing: self.DiscountPercentage))%) : \(result.discountAmount)")
                                print("Discounted Price: \(result.discountedPrice)")
                                print("Tax Amount (\(String(describing: self.taxPercentage ?? 0.0))%): \(result.taxAmount )")
                                self.taxAmount = result.taxAmount
                                self.DiscountAmount = result.discountAmount
                                print("Final Price: \(result.finalPrice)")
                                
                            } else {
                                let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                                
                                print("================================WithoutDiscount====================================")
                                print("Tax Amount: \(result.taxAmount)")
                                self.taxAmount = result.taxAmount// 45.0
                                self.DiscountAmount = 0.0
                                 print("Final Price After Tax: \(result.finalPrice)") // 945.0
                            }
                            vc.bookingID = self.bookingID
                          vc.startTime = self.startTime
                          vc.endTime = self.endTime
                            vc.hostName = self.hostName
                           vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                            vc.propertyName = self.propertyName
                            vc.propertyRating = self.propertyRating
                            vc.propertyNumberofReview =  self.propertyNumberofReview
                            vc.propertyIMGURL =  self.propertyIMGURL
                            vc.perHourRate = self.perHourRate
                            vc.booking_start = self.StartDatetime
                            vc.booking_end = self.EndDatetime
                            vc.booking_hours = self.booking_hours ?? 0
                            vc.booking_amount = self.booking_amount
                            vc.property_id = self.property_id
                            vc.booking_date = self.booking_date
                           //vc.addOnsNeddToSend = self.addOnsNeddToSend
                            vc.taxAmount =  self.taxAmount
                            vc.minBookhours = self.minBookhours
                            vc.DiscountAmount = self.DiscountAmount
                            vc.ClearningFee = (self.ClearningFee ?? 0.0)
                            vc.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
                            vc.AddonOnsPrice = self.AddonOnsPrice ?? 0.0
                            vc.addOnsArr = self.addOnsArr
                            vc.arrSelectedArr = self.arrSelectedArr
                            vc.profileIMGURL = self.profileIMGURL
                            vc.parkDesc = self.parkDesc
                            vc.HostingRulesDesc = self.HostingRulesDesc
                            vc.DiscountPercentage = self.DiscountPercentage
                            vc.taxPercentage = self.taxPercentage
                            
                            print(self.zyvoServicePercentage ?? 0.0,"zyvoServicePercentage")
                            
                            vc.zyvoServiceFeePercentage = self.zyvoServicePercentage
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            }
                        
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                        }
                    }
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
           
                
            }
            
        } else {
            timer?.invalidate() // Stop the timer when it reaches zero
            print("Timer finished!")
        }
    }
    
    func printTimeComponents(from seconds: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        // Format the values with leading zeros
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        let formattedSeconds = String(format: "%02d", seconds)
        
        self.lbl_hours.text = "\(formattedHours)"
        self.lbl_minutes.text = "\(formattedMinutes)"
        self.lbl_seconds.text = "\(formattedSeconds)"
        
    }
    
    deinit {
        timer?.invalidate() // Ensure the timer is invalidated when the view controller is deallocated
    }
    
    @IBAction func btnWhereTap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.timess = self.timess
        vc.comeFrom = "Where"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.comeFrom = "Where"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = totalPrice * (discountPercent / 100)
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = totalPrice - discountAmount
        
        // Step 3: Calculate Tax Amount
        let taxAmount = discountedPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = discountedPrice + taxAmount
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, roundedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = totalPrice * (taxPercent / 100)
        
        let roundedTaxAmount = taxAmount.rounded(toPlaces: 2)
        print(roundedTaxAmount) // Output: 1.28
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (roundedTaxAmount, finalPrice)
    }
    @IBAction func btnExtratime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NeedMoreTimePopUpVC") as! NeedMoreTimePopUpVC
        vc.backAction = { str in
            print(str,"Data Recieved")
            if str == "Yes" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
                vc.perHourRate = self.perHourRate ?? 0
                vc.backAction = {  str, str2 in
                    
                    print(str,str2,"dataReceived")
                    self.booking_hours = str
                    self.booking_amount =  Double(str2) ?? 0.0
                    self.DiscountPercentage = Double(self.getUserBookingPropertyArr?[0].bulkDiscountRate ?? "")
                    self.taxPercentage = Double(self.getUserBookingPropertyArr?[0].tax ?? "")
                    self.bookingID = ("\(self.getBookingArr?[0].bookingID ?? 0)")
                    self.hostName = self.getUserBookingPropertyArr?[0].hostedBy ?? ""
                    self.propertyName = self.getUserBookingPropertyArr?[0].propertyTitle ?? ""
                    
                   
                    self.propertyRating = self.getUserBookingPropertyArr?[0].reviewsTotalRating ?? ""
                    self.propertyNumberofReview = "(\(self.getUserBookingPropertyArr?[0].reviewsTotalCount ?? "") reviews)"
                    
                    var image = self.getUserBookingPropertyArr?[0].hostProfileImage ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    
                    self.StartDatetime = self.getBookingArr?[0].bookingStart ?? ""
                    self.EndDatetime = self.getBookingArr?[0].bookingEnd ?? ""
                    self.booking_date = self.getBookingArr?[0].bookingDate ?? ""
                    self.property_id = "\(self.getUserBookingPropertyArr?[0].propertyID ?? 0)"
                    self.parkDesc = "\(self.getUserBookingPropertyArr?[0].parkingRules ?? "")"
                    self.HostingRulesDesc = "\(self.getUserBookingPropertyArr?[0].hostRules ?? "")"
                   
                    let cleaningFees = self.getUserBookingPropertyArr?[0].cleaningFee ?? ""
                    if let doubleValue = Double(cleaningFees) {
                        self.ClearningFee = doubleValue
                        print(self.ClearningFee ?? 0.0,"ClearningFee") // Output: 10
                    }
                    
                   // let zyvoFeePercentage = Double(self.getUserBookingPropertyArr?[0].serviceFee ?? "0.0") ?? 0.0
                   // self.zyvoServicePercentage = zyvoFeePercentage
                   
                    
                    
                    let zyvoServiceFees = self.getUserBookingPropertyArr?[0].serviceFee ?? ""
                    if let doubleValue = Double(zyvoServiceFees) {
                        
                        self.zyvoServiceFee = ((self.booking_amount ?? 0.0) * doubleValue) / 100.0
                       // self.zyvoServiceFee = doubleValue
                        print(self.zyvoServiceFee ?? 0.0,"zyvoServiceFee") // Output: 10
                    }
                    if let addonPrices = self.getBookingArr?.first?.totalAddonPrice {
                        if let doubleValue = Double("\(addonPrices)") {
                            self.AddonOnsPrice = doubleValue
                            print(self.AddonOnsPrice ?? 0, "AddonOnsPrice") // Output: 10.0
                        }
                    }
                    
                    if let propertySize = self.getUserBookingPropertyArr?.first?.propertySize {
                        self.propertyDistanceInMiles = "\(propertySize)"
                        print(self.propertyDistanceInMiles , "propertyDistanceInMiles") // Output: 10.0
                    }
                    
                    
                    let bookingStart = self.getBookingArr?.first?.bookingStart ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                    if let date = dateFormatter.date(from: bookingStart) {
                        dateFormatter.dateFormat = "hh:mm a"
                        let formattedTime = dateFormatter.string(from: date)
                        self.startTime = formattedTime
                        print(formattedTime) // Output: 03:12 PM
                    }
                    
                    let bookingEnd = self.getBookingArr?.first?.bookingEnd ?? ""
                   
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                    if let date = dateFormatter.date(from: bookingEnd) {
                        dateFormatter.dateFormat = "hh:mm a"
                        let formattedTime = dateFormatter.string(from: date)
                        self.endTime = formattedTime
                        print(formattedTime) // Output: 03:12 PM
                    }
                    
                    self.addOnsArr = self.getUserBookingPropertyArr?[0].addOns ?? []
                    
                    print(self.booking_hours ?? 0,self.booking_amount ?? 0.0,"self.booking_hours,self.booking_amount")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExtraTimeExtentionVC") as! ExtraTimeExtentionVC
                    
                    if (self.booking_hours ?? 0) > (self.minBookhours ?? 0) {
                        let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                        print("================================WithDiscount====================================")
                        // Printing the Result
                        print("Total Price: \(result.totalPrice)")
                        print("Discount Amount (\(String(describing: self.DiscountPercentage))%) : \(result.discountAmount)")
                        print("Discounted Price: \(result.discountedPrice)")
                        print("Tax Amount (\(String(describing: self.taxPercentage ?? 0.0))%): \(result.taxAmount )")
                        self.taxAmount = result.taxAmount
                        self.DiscountAmount = result.discountAmount
                        print("Final Price: \(result.finalPrice)")
                        
                    } else {
                        let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                        
                        print("================================WithoutDiscount====================================")
                        print("Tax Amount: \(result.taxAmount)")
                        self.taxAmount = result.taxAmount// 45.0
                        self.DiscountAmount = 0.0
                         print("Final Price After Tax: \(result.finalPrice)") // 945.0
                    }
                    vc.bookingID = self.bookingID
                  vc.startTime = self.startTime
                  vc.endTime = self.endTime
                    vc.hostName = self.hostName
                   vc.propertyDistanceInMiles = self.propertyDistanceInMiles
                    vc.propertyName = self.propertyName
                    vc.propertyRating = self.propertyRating
                    vc.propertyNumberofReview =  self.propertyNumberofReview
                    vc.propertyIMGURL =  self.propertyIMGURL
                    vc.perHourRate = self.perHourRate
                    vc.booking_start = self.StartDatetime
                    vc.booking_end = self.EndDatetime
                    vc.booking_hours = self.booking_hours ?? 0
                    vc.booking_amount = self.booking_amount
                    vc.property_id = self.property_id
                    vc.booking_date = self.booking_date
                   //vc.addOnsNeddToSend = self.addOnsNeddToSend
                    vc.taxAmount =  self.taxAmount
                    vc.minBookhours = self.minBookhours
                    vc.DiscountAmount = self.DiscountAmount
                    vc.ClearningFee = (self.ClearningFee ?? 0.0)
                    vc.zyvoServiceFee = self.zyvoServiceFee ?? 0.0
                    vc.AddonOnsPrice = self.AddonOnsPrice ?? 0.0
                    vc.addOnsArr = self.addOnsArr
                    vc.arrSelectedArr = self.arrSelectedArr
                    vc.profileIMGURL = self.profileIMGURL
                    vc.parkDesc = self.parkDesc
                    vc.HostingRulesDesc = self.HostingRulesDesc
                    vc.DiscountPercentage = self.DiscountPercentage
                    vc.taxPercentage = self.taxPercentage
                    
                    print(self.zyvoServicePercentage ?? 0.0,"zyvoServicePercentage")
                    
                    vc.zyvoServiceFeePercentage = self.zyvoServicePercentage
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    }
                
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                }
            }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
   
    }
    
    @IBAction func btnTime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.timess = self.timess
        vc.comeFrom = "Time"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
        
       // let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.comeFrom = "Time"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnActivity_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.timess = self.timess
        vc.comeFrom = "Activity"
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WhereVC") as! WhereVC
//        vc.comeFrom = "Activity"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
    }
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        
        vc.timess = self.timess
        
        vc.backAction = { str, str1 in
            print( str, str1,"data Recieved")
            if str1 == "Clear" {
                self.viewModel.apiforGetHomeData()
            } else if str1 == "" {
                self.viewModel.apiforGetHomeData()
            } else {
                self.comingFrom = "Filter"
                if str?.count == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.getHomeDataArr?.removeAll()
                    self.getHomeDataArr = str
                    self.collecV.reloadData()
                }
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.comingFrom = ""
    }
    
    @IBAction func btnshowMap_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 14.0, *)
extension DiscoverVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getHomeDataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let data = getHomeDataArr?[indexPath.item]
        cell.view_Instant.isHidden = true
        cell.btnCross.isHidden = true
        if indexPath.row == 0 {
            cell.view_Instant.isHidden = false
        }
        if indexPath.row == 3 {
            cell.view_Instant.isHidden = false
        }
        
        cell.lbl_name.text = data?.title ?? ""
        
        var rating = data?.rating ?? ""
        if rating != "" {
            cell.lbl_Rating.text = rating
        } else {
            cell.lbl_Rating.text = ""
        }
        var hour = data?.hourlyRate ?? ""
        
        if hour != "" {
            cell.lbl_Time.text = "$ \(hour) / h"
        } else {
            cell.lbl_Time.text = ""
        }
        
        cell.imgArr = data?.images ?? []
        cell.pageV.currentPage = 0
        cell.pageV.numberOfPages = data?.images?.count ?? 0
        cell.CollecV.reloadData()
        
        let reviewCount = data?.reviewCount ?? "0"
        cell.lbl_NumberOfUser.text = reviewCount > "0" ? "(\(reviewCount))" : ""
        var heartStatus = data?.isInWishlist ?? 0
        
        if heartStatus == 0 {
            cell.btnHeart.setImage(UIImage(named: "hearticons"), for: .normal)
        } else {
            cell.btnHeart.setImage(UIImage(named: "day"), for: .normal)
        }
        
        
        cell.btnHeart.tag = indexPath.row
        cell.btnHeart.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Handle selection from inner collection view
        cell.didSelectItem = { [weak self] innerIndexPath in
            guard let self = self else { return }
            print("Selected item at outer index: \(indexPath.item), inner index: \(innerIndexPath.item)")
            
            // Example: Navigate to a new view controller
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
            vc.propertyID = "\(data?.propertyID ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Heloo")
        let data = getHomeDataArr?[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.propertyID = "\(data?.propertyID ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let data = getHomeDataArr?[sender.tag]
        
        var heartStatus = data?.isInWishlist ?? 0
        
        if heartStatus == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToWishListPopUpVC") as! AddToWishListPopUpVC
            vc.propertyID = "\(data?.propertyID ?? 0)"
            vc.backAction = { str in
                print(str,"Data Recieved")
                if str == "SaveItemInWishlist" {
                    self.viewModel.apiforGetHomeData() }
                if str == "Ravi" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateWishListVC") as! CreateWishListVC
                    vc.propertyID = "\(data?.propertyID ?? 0)"
                    vc.backAction = { str in
                        print(str,"Created")
                        self.viewModel.apiforGetHomeData()
                    }
                    self.present(vc, animated:  false)
                }
            }
            self.present(vc, animated:  false)
        } else {
            print("Remove From wishlist")
            
            self.viewModel.apiforRemoveFromWishlist(propertyID: "\(data?.propertyID ?? 0)")
        }
        
    }
}
@available(iOS 14.0, *)
extension DiscoverVC:UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width based on screen size, subtracting padding or spacing as needed
        let padding: CGFloat = 5  // Example padding (adjust as needed)
        let collectionViewWidth = collectionView.frame.width - padding
        let cellWidth = collectionViewWidth / 1  // Display 2 cells per row
        
        // Return the size with fixed height of 120
        return CGSize(width: cellWidth, height: 370)
    }
}

@available(iOS 14.0, *)
extension DiscoverVC {
    func bindVC() {
        
        viewModel.$chatTokenModelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    let chatToken = response.data?.token ?? ""
                    
                    UserDefaults.standard.set(chatToken, forKey:"twilioToken")
                    
                    print(chatToken,"chatToken")
                    
                    UserDetail.shared.setChatToken(chatToken)
                    
                })
            }.store(in: &cancellables)
        
        viewModel.$getHomeDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.getHomeDataArr?.removeAll()
                    
                    self.getHomeDataArr = response.data
                    //print(self.getHomeDataArr ?? [],"HOME DATA YAHI HAI")
                    self.collecV.reloadData()
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getWishlistRemoveResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.viewModel.apiforGetHomeData()
                    }
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getUserBookingResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                   // self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        self.getUserBooking = response.data
                        
                        if self.getUserBooking != nil {
                            
                            
                            self.getBookingArr = self.getUserBooking?.bookings ?? []
                            self.getUserBookingPropertyArr = self.getUserBooking?.properties ?? []
                            
                            
                            let stringValue = self.getUserBookingPropertyArr?[0].hourlyRate ?? ""
                            if let doubleValue = Double(stringValue) {
                                let intValue = Int(doubleValue)
                                self.perHourRate = intValue
                                print(intValue) // Output: 10
                            }
                            
                            let minbookhours = self.getUserBookingPropertyArr?[0].minBookingHours ?? ""
                            if let doubleValue = Double(minbookhours) {
                                let intValue = Int(doubleValue)
                                self.minBookhours = intValue
                                print(intValue) // Output: 10
                            }
                            
                            print(self.perHourRate ?? 0,"self.perHourRate")
                            
                            print(self.getBookingArr ?? [],"getBookingArr")
                            print(self.getUserBookingPropertyArr ?? [],"getUserBookingPropertyArr")
                            
                            self.dateTimer.stopTimer()
                          
                            var bookingStartTime = self.getUserBooking?.bookings?[0].bookingStart
                            var bookingEndtime = self.getUserBooking?.bookings?[0].bookingEnd
                            print(bookingStartTime ?? "")
                            print(bookingEndtime ?? "")
                            
                            if let difference = self.calculator.calculateTimeDifference(
                                startTimeString: bookingStartTime ?? "",
                                endTimeString: bookingEndtime ?? ""
                            ) {
                                print("Difference: \(difference.hours) hours, \(difference.minutes) minutes, \(difference.seconds) seconds")
                                
                                let hours = difference.hours
                                let minutes = difference.minutes
                                let seconds = difference.seconds
                                
                                self.startTimer(hours: difference.hours, minutes: difference.minutes, seconds: difference.seconds) // Example: Start a timer for 1:30:45
                                
                                self.view_RemainingTime.isHidden = false
                                
                                
                            } else {
                                print("Invalid date format")
                            }
                        } else {
                            
                        }
                      
                    }
                })
            }.store(in: &cancellables)
    }
}

