//
//  CheckOutConfirmationVC.swift
//  Zyvo
//
//  Created by ravi on 29/11/24.
//

import UIKit
import DropDown

class CheckOutConfirmationVC: UIViewController {
    var isCardOpen = "no"
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_MessageHost: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var imgDownArrowDebitCard: UIImageView!
    @IBOutlet weak var StackAbove: UIStackView!
    @IBOutlet weak var btnMyBookings: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    
    @IBOutlet weak var view_Calendar: UIView!
    @IBOutlet weak var stackV_MessageHost: UIStackView!
    
    @IBOutlet weak var view_MessageHostDesc: UIView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_availableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var btnMsgHost: UIButton!
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    
    @IBOutlet weak var lbl_hostName: UILabel!
    
    @IBOutlet weak var lbl_PropertyTitle: UILabel!
    @IBOutlet weak var imgProfileHost: UIImageView!
    
    @IBOutlet weak var imgProperty: UIImageView!
    
    @IBOutlet weak var lbl_rating: UILabel!
    
    @IBOutlet weak var lbl_DistanceInMiles: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    
    @IBOutlet weak var lbl_Taxes: UILabel!
    @IBOutlet weak var lbl_ZyvoFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var lbl_HoursBasedTotal: UILabel!
    @IBOutlet weak var lbl_AboveHours: UILabel!
    
    @IBOutlet weak var lbl_HostRulesDesc: UILabel!
    @IBOutlet weak var lbl_ParkingRulesDesc: UILabel!
    @IBOutlet weak var lbl_TimeFromTo: UILabel!
    @IBOutlet weak var lbl_BelowBookingHours: UILabel!
    @IBOutlet weak var lbl_BookedDate: UILabel!
    @IBOutlet weak var lbl_FinalPrice: UILabel!
    @IBOutlet weak var lbl_AddonPrice: UILabel!
    
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnShowMessageHost: UIButton!
    @IBOutlet weak var btnAddNewCard: UIButton!
    
    @IBOutlet weak var view_Hours: UIView!
    
    @IBOutlet weak var view_time2: UIView!
    
    @IBOutlet weak var view_AddmoreTime: UIView!
    
    @IBOutlet weak var viewOutSideSelectDate: UIView!
    
    @IBOutlet weak var view_SelectDate: UIView!
    
    @IBOutlet weak var btnSelectYear: UIButton!
    @IBOutlet weak var btnSelectMonth: UIButton!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var view_date: UIView!
    @IBOutlet weak var view_month: UIView!
    @IBOutlet weak var view_year: UIView!
    @IBOutlet weak var btnSaveChangesDates: UIButton!
    
    @IBOutlet weak var viewFrom_hours: UIView!
    
    @IBOutlet weak var viewFrom_mnt: UIView!
    
    @IBOutlet weak var viewFrom_AMPM: UIView!
    
    @IBOutlet weak var viewTo_hours: UIView!
    
    @IBOutlet weak var viewTo_mnt: UIView!
    
    @IBOutlet weak var viewTo_AMPM: UIView!
    
    
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var lbl_discount: UILabel!
    
    
    
    @IBOutlet weak var btnFromHours: UIButton!
    @IBOutlet weak var btnFromMnt: UIButton!
    @IBOutlet weak var btnFromAMPM: UIButton!
    
    @IBOutlet weak var btnToHours: UIButton!
    @IBOutlet weak var btnToMnt: UIButton!
    @IBOutlet weak var btnToAMPM: UIButton!
    
    @IBOutlet weak var viewBelow_SelectTime: UIView!
    
    @IBOutlet weak var btnReportanIssue: UIButton!
    @IBOutlet weak var btnCancelBooking: UIButton!
    @IBOutlet weak var viewMain_SelectTimeFromTo: UIView!
    @IBOutlet weak var refundDesLbl: UILabel!
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    @IBOutlet weak var collVH: NSLayoutConstraint!
    private let spacing:CGFloat = 16.0
    
    let timeDropdown = DropDown()
    
    let hoursDropdown = DropDown()
    
    let dateDropDown = DropDown()
    let monthDropDown = DropDown()
    let yearDropDown = DropDown()
    
    let arrHours = ["30 minutes","1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    
    
    var monthNamesArr = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    
   // let yearStrings = stride(from: 2024, through: 1900, by: -1).map { String($0) }
    
    let yearStrings = stride(from: 2024, through: 2100, by: 1).map { String($0) }
    
    let daysArr = (1...31).map { String($0) }
    var showDes = "no"
    var isReadMore = "yes"
    var Host_count = 4
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (booking_hours ?? 0) > 1 {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hours"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hours"
        } else {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hour"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hour"
        }
        
        let inputDate = "\(booking_date)"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM, d yyyy"
            let outputDate = outputFormatter.string(from: date)
            
            print(outputDate) // Output: March, 4 2025
            self.lbl_BookedDate.text = "\(outputDate)"
        }
        
        self.lbl_TimeFromTo.text = "\(self.startTime)" + " \(self.endTime)"
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0
        
        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
        
        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
        
        self.lbl_FinalPrice.text = "$\(totalAmount)"
        
        self.lbl_hostName.text = self.hostName
        
        self.total_amount = totalAmount
        
        self.imgProfileHost.layer.cornerRadius = self.imgProfileHost.layer.frame.height / 2
        self.imgProfileHost.contentMode = .scaleAspectFill
        self.imgProfileHost.layer.borderWidth = 1
        self.imgProfileHost.layer.borderColor = UIColor.lightGray.cgColor
        
        self.imgProfileHost.loadImage(from:profileIMGURL,placeholder: UIImage(named: "user"))
        
        
        self.imgProperty.loadImage(from:propertyIMGURL,placeholder: UIImage(named: "img1"))
        self.lbl_DistanceInMiles.text = self.propertyDistanceInMiles  + " sqft"
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text  = self.propertyRating
        self.lbl_numberOfReview.text  = "(\(self.propertyNumberofReview))"
        
        self.lbl_ParkingRulesDesc.text = parkDesc
        self.lbl_HostRulesDesc.text = HostingRulesDesc
        
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text = self.propertyRating
        self.lbl_numberOfReview.text = self.propertyNumberofReview
        
        self.lbl_HoursBasedTotal.text = "$\(self.booking_amount ?? 0.0)"
        self.lbl_CleaningFee.text = "$\(self.ClearningFee ?? 0.0)"
        self.lbl_ZyvoFee.text = "$\(self.zyvoServiceFee ?? 0.0)"
        self.lbl_Taxes.text = "$\((self.taxAmount ?? 0.0).rounded(toPlaces: 2))"
        self.lbl_AddonPrice.text = "$\(self.AddonOnsPrice ?? 0.0)"
        
        
        print(DiscountAmount ?? 0.0,"DiscountAmount")
//        
        if DiscountAmount == 0.0 || DiscountAmount == nil {
            view_Discount.isHidden = true
        } else {
            view_Discount.isHidden = false
            self.lbl_discount.text = "-$\(DiscountAmount ?? 0.0) "
        }
//   
        
        btnReportanIssue.layer.cornerRadius = 10
        btnReportanIssue.layer.borderWidth = 1
        btnReportanIssue.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        
        btnCancelBooking.layer.cornerRadius = 10
        btnCancelBooking.layer.borderWidth = 1
        btnCancelBooking.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        
        
        
        viewMain_SelectTimeFromTo.isHidden = true
        
        viewBelow_SelectTime.layer.cornerRadius = 10
        viewBelow_SelectTime.layer.borderWidth = 1.5
        viewBelow_SelectTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewFrom_hours.layer.cornerRadius = 10
        viewFrom_hours.layer.borderWidth = 1.5
        viewFrom_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_mnt.layer.cornerRadius = 10
        viewFrom_mnt.layer.borderWidth = 1.5
        viewFrom_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewFrom_AMPM.layer.cornerRadius = 10
        viewFrom_AMPM.layer.borderWidth = 1.5
        viewFrom_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewTo_hours.layer.cornerRadius = 10
        viewTo_hours.layer.borderWidth = 1.5
        viewTo_hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_mnt.layer.cornerRadius = 10
        viewTo_mnt.layer.borderWidth = 1.5
        viewTo_mnt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        viewTo_AMPM.layer.cornerRadius = 10
        viewTo_AMPM.layer.borderWidth = 1.5
        viewTo_AMPM.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        
        viewOutSideSelectDate.isHidden = true
        btnSaveChangesDates.layer.cornerRadius = 10
        
        view_SelectDate.layer.cornerRadius = 10
        view_SelectDate.layer.borderWidth = 1.5
        view_SelectDate.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_date.layer.cornerRadius = 10
        view_date.layer.borderWidth = 1.5
        view_date.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_month.layer.cornerRadius = 10
        view_month.layer.borderWidth = 1.5
        view_month.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_year.layer.cornerRadius = 10
        view_year.layer.borderWidth = 1.5
        view_year.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Hours.layer.cornerRadius = view_Hours.layer.frame.height / 2
        view_Hours.layer.borderWidth = 1.5
        view_Hours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
      
        view_Calendar.layer.cornerRadius = view_Calendar.layer.frame.height / 2
        view_Calendar.layer.borderWidth = 1.5
        view_Calendar.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_time2.layer.cornerRadius = view_time2.layer.frame.height / 2
        view_time2.layer.borderWidth = 1.5
        view_time2.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_AddmoreTime.layer.cornerRadius = view_AddmoreTime.layer.frame.height / 2
        view_AddmoreTime.layer.borderWidth = 1.5
        view_AddmoreTime.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        viewHold_MessageHost.isHidden = true
        view_MessageHost.layer.cornerRadius = 20
        view_MessageHost.layer.borderWidth = 1.5
        view_MessageHost.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
       
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_availableDays.layer.cornerRadius = 10
        view_availableDays.layer.borderWidth = 1.5
        view_availableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_otherReason.layer.cornerRadius = 10
        view_otherReason.layer.borderWidth = 1.5
        view_otherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_MessageHostDesc.layer.cornerRadius = 10
        view_MessageHostDesc.layer.borderWidth = 1.5
        view_MessageHostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 20
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 20
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
                
        
//        view_Card.isHidden = true
//        view_Card.layer.cornerRadius = 20
//        view_Card.layer.borderWidth = 1.5
//        view_Card.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        StackAbove.layer.cornerRadius = 20
        StackAbove.layer.borderWidth = 1.5
        StackAbove.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        

        
//        btnMsgHost.layer.cornerRadius = 10
//        btnMsgHost.layer.borderWidth = 1
//        btnMsgHost.layer.borderColor = UIColor.black.cgColor
        
        btnMyBookings.layer.cornerRadius = btnMyBookings.layer.frame.height / 2
        
//        btnAddNewCard.layer.cornerRadius = btnAddNewCard.layer.frame.height / 2
       
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.lightGray.cgColor
        

        
//        collecV_BankingDetails.delegate = self
//        collecV_BankingDetails.dataSource = self
//        let nib2 = UINib(nibName: "BankingDetailsCell", bundle: nil)
//        collecV_BankingDetails?.register(nib2, forCellWithReuseIdentifier: "BankingDetailsCell")
//        let nib = UINib(nibName: "CellHost", bundle: nil)
//        collecV_Host?.register(nib, forCellWithReuseIdentifier: "CellHost")
        
//        collecV_Host.delegate = self
//        collecV_Host.dataSource = self
        
        let nib1 = UINib(nibName: "AddMoreTimeCell", bundle: nil)
        collecV_BankingDetails?.register(nib1, forCellWithReuseIdentifier: "AddMoreTimeCell")
        
        view_Details.layer.cornerRadius = 30
        view_Details.layer.borderWidth = 0.5
        view_Details.layer.borderColor = UIColor.lightGray.cgColor
        
        btnShowMessageHost.layer.cornerRadius = 10
        btnShowMessageHost.layer.borderWidth = 1
        btnShowMessageHost.layer.borderColor = UIColor.black.cgColor
    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//          tblV.layer.removeAllAnimations()
//          tblVH_Const.constant = tblV.contentSize.height
//          UIView.animate(withDuration: 0.5) {
//              self.updateViewConstraints()
//          }
//      }
    @IBAction func btnSelectDate_Tap(_ sender: UIButton) {
      //  viewOutSideSelectDate.isHidden = false
        
        
      
        let datePicker = UIDatePicker()
           datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }  // Use wheels style
           datePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 200)

           let alert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .alert)
           alert.view.addSubview(datePicker)
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
               let selectedDate = datePicker.date
               print("Selected Date: \(selectedDate)")
           }))
           
           present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCancelBooking_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelBookingPopUpVC") as! CancelBookingPopUpVC
        self.present(vc, animated: true)
    }
    
    @IBAction func btnReportIsuue(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViolationVC") as! ReportViolationVC
        self.tabBarController?.tabBar.isHidden = true
        vc.bookingID = self.bookingID
        vc.propertyID = self.propertyID
        vc.backAction = { str in
            if str == "Cancel"{
                self.tabBarController?.tabBar.isHidden = false
            }else{
                let sb = UIStoryboard(name: "Host", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as! HostNotificationPopUpVC
                vc.backAction = { str in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                    vc.comesFrom = "Book"
                    vc.backCome = {
                        self.tabBarController?.tabBar.isHidden = false
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func btnHours_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
       
        hoursDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        hoursDropdown.dataSource = arrHours
        hoursDropdown.direction = .bottom
       
        hoursDropdown.bottomOffset = CGPoint(x: 3, y:(hoursDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        hoursDropdown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        hoursDropdown.show()
    }
    
    
    @IBAction func btnbelowSelectDate_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
        dateDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dateDropDown.dataSource = daysArr
        dateDropDown.direction = .bottom
       
        dateDropDown.bottomOffset = CGPoint(x: 3, y:(dateDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dateDropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        dateDropDown.show()
    }
    
    @IBAction func btnbelowMonth_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
        monthDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        monthDropDown.dataSource = monthNamesArr
        monthDropDown.direction = .bottom
       
        monthDropDown.bottomOffset = CGPoint(x: 3, y:(monthDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        monthDropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        monthDropDown.show()
    }
    
    
    @IBAction func btnbelowYear_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
        yearDropDown.anchorView = sender // You can set it to a UIButton or any UIView
        yearDropDown.dataSource = yearStrings
        yearDropDown.direction = .bottom
       
        yearDropDown.bottomOffset = CGPoint(x: 3, y:(yearDropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        yearDropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        yearDropDown.show()
    }
    
    @IBAction func btnSelectTimeFromTo_Tap(_ sender: Any) {
        viewMain_SelectTimeFromTo.isHidden = false
    }
    
    @IBAction func btnMyBooking_Tap(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBAction func btnSaveChangesTimeFromTo_Tap(_ sender: Any) {
        viewMain_SelectTimeFromTo.isHidden = true
    }
    
    @IBAction func btnSaveChangesSelectDate_Tap(_ sender: UIButton) {
        viewOutSideSelectDate.isHidden = true
    }
  
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_availableDays.backgroundColor = UIColor.white
        view_otherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        
    }
    @IBAction func btnAddMoreTime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        vc.perHourRate = self.perHourRate ?? 0
        vc.backAction = {  str, str2 in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TotalAmountPopUpVC") as! TotalAmountPopUpVC
            vc.TotalAmount = str2
            self.booking_hours = str
            vc.modalPresentationStyle = .overCurrentContext
            vc.backAction = { str1, str2 in
                print(str1, str2,"Data Recieved")
                self.booking_amount = Double(str2)
                if str1 == "Yes" {
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
                   // vc.addOnsNeddToSend = self.addOnsNeddToSend
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
                    print(self.zyvoServicePercentage,"zyvoServicePercentage")
                    vc.zyvoServiceFeePercentage = self.zyvoServicePercentage
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            self.present(vc, animated: true)
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = (totalPrice * (discountPercent / 100)).rounded(toPlaces: 2)
        
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = (totalPrice - discountAmount).rounded(toPlaces: 2)
        
        // Step 3: Calculate Tax Amount
        let taxAmount = (discountedPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = (discountedPrice + taxAmount).rounded(toPlaces: 2)
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, taxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = (totalPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 2: Final Price after Tax
        let finalPrice = (totalPrice + taxAmount).rounded(toPlaces: 2)
        
        return (taxAmount, finalPrice)
    }
    
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnSendMessageHost_Tap(_ sender: UIButton) {
        viewHold_MessageHost.isHidden = true
    }
    
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isParkingRulesOpen == "no" {
            view_ParkingDesc.isHidden = false
            isParkingRulesOpen = "Yes"
        } else {
            view_ParkingDesc.isHidden = true
            isParkingRulesOpen = "no"
        }
    }
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isHostTingRulesOpen == "no" {
            view_HostDesc.isHidden = false
            isHostTingRulesOpen = "Yes"
        } else {
            view_HostDesc.isHidden = true
            isHostTingRulesOpen = "no"
        }
    }
    
    @IBAction func btnCreditDebit_Tap(_ sender: UIButton) {
        if isCardOpen == "no" {
            view_Card.isHidden = false
            isCardOpen = "yes"
            imgDownArrowDebitCard.image = UIImage(named: "ReverseDownArrow")
        } else {
            view_Card.isHidden = true
            isCardOpen = "no"
            imgDownArrowDebitCard.image = UIImage(named: "downarrow")
        }
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        print("HELLO")
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.present(vc, animated: true)
    }
    
    @IBAction func btnPositiveRating_Tap(_ sender: UIButton) {
        // Set up the dropdown
       
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
       
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        timeDropdown.show()
    }
    
    @IBAction func btnShowMessageHost_Tap(_ sender: UIButton) {

        viewHold_MessageHost.isHidden = false
        
    }
    
    @IBAction func btnShowMore_Tap(_ sender: UIButton) {
        if isReadMore == "no" {
            isReadMore = "yes"
            Host_count = Host_count - 1
            collVH.constant = 320
            sender.setTitle("See More", for: .normal)
//            btnReadMore.setImage(UIImage(named: "Read Less"), for: .normal)
        } else {
           
//            btnReadMore.setImage(UIImage(named: "Read more"), for: .normal)
            isReadMore = "no"
            Host_count = Host_count + 1
            collVH.constant = 400
            sender.setTitle("See Less", for: .normal)
        }
        self.collecV_Host.reloadData()
    }
    
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        if showDes == "no"{
            self.showDes = "yes"
            sender.setTitle("See Less", for: .normal)
            self.refundDesLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy .Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy .Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }else{
            self.showDes = "no"
            sender.setTitle("See More", for: .normal)
            self.refundDesLbl.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever the industry's standard dummy"
        }
    }
}

extension CheckOutConfirmationVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  if collectionView == collecV_Host {
          //  return Host_count
            return addOnsArr.count
       // }
//        else {
//            return items.count + 1
//        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //  if collectionView == collecV_Host {
            //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
//            cell.lbl_title.text = arrHost[indexPath.row]
//            cell.img.image = UIImage(named: arrHost[indexPath.row])
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
            let data = addOnsArr[indexPath.row]
            cell.lbl_title.text = data.name//arrHost[indexPath.row]
            cell.lbl_price.text = "$\(data.price ?? "0")/Item"
            if arrSelectedArr.contains(indexPath.row){
                cell.mainV.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
            }else{
                cell.mainV.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 1).cgColor
            }
           
            return cell
      //  }
//        else {
//            if indexPath.row < 3 {
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankingDetailsCell", for: indexPath) as! BankingDetailsCell
//                cell.lbl_title.text = items[indexPath.item]
//                cell.img.image = UIImage(named: imgArr[indexPath.item])
//                return cell } else {
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddMoreTimeCell", for: indexPath) as! AddMoreTimeCell
//                   
//                    return cell
//                }
//        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10 // Adjust spacing as needed
        let numberOfColumns: CGFloat = 1
        let totalSpacing = (numberOfColumns - 1) * spacing

        let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
        let itemHeight: CGFloat = 70 // Fixed height as per your code
        print(itemWidth,itemHeight,"itemWidth,itemHeight")
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == collecV_BankingDetails {
//            if indexPath.row == 3 {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
//                self.present(vc, animated: true)
//            }
//        }
//    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}


//extension CheckOutConfirmationVC :UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
//       
//        return cell
//    }
//    
//    
//}
