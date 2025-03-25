//
//  HostProfileVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift
import DropDown
import CountryPickerView
import Combine

class HostProfileVC:UIViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
   
    
    @IBOutlet weak var aboutMeTxtV: UITextView!
    @IBOutlet weak var view_ConfirmNowEmail: UIView!
    @IBOutlet weak var view_VerifiedEmail: UIView!
    @IBOutlet weak var view_VerifiedPhone: UIView!
    @IBOutlet weak var view_ConfirmNowPhone: UIView!
    @IBOutlet weak var view_ProfilePassword: UIView!
    @IBOutlet weak var view_ProfilePhoneNumber: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    //let keyboardSettings = KeyboardSettings(bottomType: .categories)
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_AddNewPaymentMethod: UIView!
    @IBOutlet weak var view_AddNewPayOut: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zip: UIView!
    @IBOutlet weak var view_EmailProfile: UIView!
    @IBOutlet weak var view_timeResend: UIView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var view_OTPtxt: DPOTPView!
    @IBOutlet var view_OTPVerification: UIView!
    @IBOutlet weak var view_Phone: UIView!
    @IBOutlet weak var view_Email: UIView!
    @IBOutlet weak var txt_EmailVerification: UITextField!
    @IBOutlet weak var view_EmailVerificaiton: UIView!
    @IBOutlet weak var txt_PhoneVerification: UITextField!
    @IBOutlet weak var view_phoneVerification: UIView!
    @IBOutlet var view_Verification: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var view_UploadPhoto: UIView!
    @IBOutlet weak var collecV_Place: UICollectionView!
    @IBOutlet weak var collecV_MyWork: UICollectionView!
    @IBOutlet weak var collecV_MyLanguage: UICollectionView!
    @IBOutlet weak var collecV_MyHobbies: UICollectionView!
    @IBOutlet weak var collecV_MyPets: UICollectionView!
    @IBOutlet weak var view_AboutMe: UIView!
    @IBOutlet weak var view_Dark: UIView!
    @IBOutlet weak var view_ProfileDetails: UIView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var verificationDetaiilLbl: UILabel!
    @IBOutlet weak var OTPverificationDetaiilLbl: UILabel!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodV: UIView!
    @IBOutlet weak var paymentDropImg: UIImageView!
    @IBOutlet weak var cardTblV: UITableView!
    @IBOutlet weak var bankTblV: UITableView!
    @IBOutlet weak var resendBtnO: UIButton!
    @IBOutlet weak var txt_streetProfile: UITextField!
    @IBOutlet weak var txt_cityProfile: UITextField!
    @IBOutlet weak var txt_stateProfile: UITextField!
    @IBOutlet weak var txt_zipProfile: UITextField!
    @IBOutlet weak var btnEditAboutMe: UIButton!
    @IBOutlet weak var btnEditStreet: UIButton!
    @IBOutlet weak var btnEditCity: UIButton!
    @IBOutlet weak var btnEditState: UIButton!
    @IBOutlet weak var btnEditZip: UIButton!
    @IBOutlet weak var view_ConfirmNowIndentity: UIView!
    @IBOutlet weak var view_VerifiedIndentity: UIView!
    @IBOutlet weak var lbl_nameUser: UILabel!
    @IBOutlet weak var txt_PhoneProfile: UITextField!
    @IBOutlet weak var txt_EmailProfile: UITextField!
    
    let placeholderText = "Enter your description here..." // Placeholder text
    let dotDropdown = DropDown()
    var dotArr = ["Edit","Delete"]
    var identity_verify : Int? = 0
    var verificationStatus = ""
    var editEmail_Phone = ""
    private var placesClient: GMSPlacesClient!
    let countryPicker = CountryPickerView()
    var types = ""
    var locationArray: [String] = [ ]
    var indexforDeleteLocation : Int? = 0
    var myWorkArr: [String] = []
    var indexforDeleteWork : Int? = 0
    var myLanguageArr: [String] = []
    var indexforDeleteLanguage : Int? = 0
    var myHobbiesArr: [String] = []
    var indexforDeleteHobby : Int? = 0
    var myPetsArr: [String] = []
    var indexforDeletePet : Int? = 0
    
    var activeTextField: UITextField?
    var timer = Timer()
    
    var isAboutMeStatus = false  // Track editing state
    var isStreetUpdateStatus = false
    var isCityUpdateStatus = false
    var isStateUpdateStatus = false
    var isZipcdeUpdateStatus = false
    
    var OTP = ""
    var userID = ""
    var tempID = ""
    var fName = ""
    var lName = ""
    
    var profileData : MyProfileModel?
    var workDataAfterDeletion : DeleteWorkModel?
    private var viewModelPaymentMethod = PaymentHistoryViewModel()
    var addedBankDetailsData = [H_BankAccount]()
    var addedCardDetailsData = [H_Card]()
    
    var viewModel = GetMyProfileViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var viewModelVerifyEmail = EmailVerificationViewModel()
    var viewModelEmailVerifyOTP = OTPEmailVerifyViewModel()
    
    private var viewModelVerifyPhone = PhoneVerificationViewModel_CreateProfile()
    
    private var viewModelUpdatePhone = PhoneVerificationViewModel_CreateProfile()
    
    var viewModelPhoneVerifyOTP = OTPVerifyPhoneViewModel()
    var  phonetobeUpdate = ""
    var profileIMGURL = ""
    
    var firstName = ""
    var lastName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardNotifications()
        IQKeyboardManager.shared.enable = false
        
        self.paymentMethodV.isHidden = true
        countryCodeTF.text = "🇺🇸 +1"
        countryPicker.delegate = self
        
        view_OTPtxt.dpOTPViewDelegate = self
        view_timeResend.isHidden = true
        
        view_Email.layer.cornerRadius = view_Email.layer.frame.height / 2
        view_Email.layer.borderWidth = 1
        view_Email.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Phone.layer.cornerRadius = view_Phone.layer.frame.height / 2
        view_Phone.layer.borderWidth = 1
        view_Phone.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view_EmailProfile.layer.cornerRadius = view_EmailProfile.layer.frame.height / 2
        view_EmailProfile.layer.borderWidth = 1.0
        view_EmailProfile.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
      
        view_ProfilePassword.layer.cornerRadius = view_ProfilePassword.layer.frame.height / 2
        view_ProfilePassword.layer.borderWidth = 1.0
        view_ProfilePassword.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_ProfilePhoneNumber.layer.cornerRadius = view_ProfilePhoneNumber.layer.frame.height / 2
        view_ProfilePhoneNumber.layer.borderWidth = 1.0
        view_ProfilePhoneNumber.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_State.layer.cornerRadius = view_State.layer.frame.height / 2
        view_State.layer.borderWidth = 1.0
        view_State.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        
        view_City.layer.cornerRadius = view_City.layer.frame.height / 2
        view_City.layer.borderWidth = 1.0
        view_City.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_AddNewPayOut.layer.cornerRadius = view_AddNewPayOut.layer.frame.height / 2
        view_AddNewPayOut.layer.borderWidth = 1.0
        view_AddNewPayOut.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        view_AddNewPaymentMethod.layer.cornerRadius = view_AddNewPaymentMethod.layer.frame.height / 2
        view_AddNewPaymentMethod.layer.borderWidth = 1.0
        view_AddNewPaymentMethod.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Zip.layer.cornerRadius = view_Zip.layer.frame.height / 2
        view_Zip.layer.borderWidth = 1.0
        view_Zip.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Street.layer.cornerRadius = view_Street.layer.frame.height / 2
        view_Street.layer.borderWidth = 1.0
        view_Street.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        placesClient = GMSPlacesClient.shared()
        
        view_phoneVerification.isHidden = true
        view_EmailVerificaiton.isHidden = true
        
        view_UploadPhoto.frame = self.view.bounds
        self.view.addSubview(view_UploadPhoto)
        view_UploadPhoto.isHidden = true
        
        view_Verification.frame = self.view.bounds
        self.view.addSubview(view_Verification)
        view_Verification.isHidden = true
        
        view_OTPVerification.frame = self.view.bounds
        self.view.addSubview(view_OTPVerification)
        view_OTPVerification.isHidden = true
        view_Dark.layer.cornerRadius = 20
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 3
        view_Photo.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        view_ProfileDetails.layer.cornerRadius = 15
        view_ProfileDetails.layer.borderWidth = 0.75
        view_ProfileDetails.layer.borderColor = UIColor.lightGray.cgColor
        
//        view_AboutMe.layer.cornerRadius = 15
//        view_AboutMe.layer.borderWidth = 0.75
//        view_AboutMe.layer.borderColor = UIColor.lightGray.cgColor
        
        let nib2 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_Place?.register(nib2, forCellWithReuseIdentifier: "MasterCell")
        collecV_Place.delegate = self
        collecV_Place.dataSource = self
        
        let nib1 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyWork?.register(nib1, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyWork.delegate = self
        collecV_MyWork.dataSource = self
        
        let nib3 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyLanguage?.register(nib3, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyLanguage.delegate = self
        collecV_MyLanguage.dataSource = self
        
        let nib4 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyHobbies?.register(nib4, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyHobbies.delegate = self
        collecV_MyHobbies.dataSource = self
        
        let nib5 = UINib(nibName: "MasterCell", bundle: nil)
        collecV_MyPets?.register(nib5, forCellWithReuseIdentifier: "MasterCell")
        collecV_MyPets.delegate = self
        collecV_MyPets.dataSource = self
        
        bankTblV.register(UINib(nibName: "BankDetailTblVCell", bundle: nil), forCellReuseIdentifier: "BankDetailTblVCell")
        bankTblV.delegate = self
        bankTblV.dataSource = self
        
        cardTblV.register(UINib(nibName: "BankDetailTblVCell", bundle: nil), forCellReuseIdentifier: "BankDetailTblVCell")
        cardTblV.delegate = self
        cardTblV.dataSource = self
        
        bindVC()
        bindViewModel()
        bindVC_GetPayoutMethods()
        setupTextView()
        setupTextFields()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.getProfile()
        //Api For GetPayoutMethods
        viewModelPaymentMethod.apiforGetPayoutMethods()
        
    }
    
    
    @IBAction func editAboutMeTxtBtn(_ sender: UIButton){
//        self.aboutMeTxtV.becomeFirstResponder()
        
        
        if isAboutMeStatus {
            // Stop editing and call API
            aboutMeTxtV.isEditable = false
            btnEditAboutMe.setImage(UIImage(named: "Group 1171275558"), for: .normal)
            aboutMeTxtV.resignFirstResponder()
            if aboutMeTxtV.text != placeholderText {
                print("api call here for edit aboue me")
                viewModel.apiForUpdateAboutMe(AboutMe: self.aboutMeTxtV.text)
                
            }
        } else {
            // Start editing
            aboutMeTxtV.isEditable = true
            aboutMeTxtV.becomeFirstResponder()
            btnEditAboutMe.setImage(UIImage(named: "EditTick"), for: .normal)
            
            // Remove placeholder when editing starts
            if aboutMeTxtV.text == placeholderText {
                aboutMeTxtV.text = ""
                aboutMeTxtV.textColor = UIColor.black
            }
        }
        isAboutMeStatus.toggle()
        
    }
    
    @IBAction func btnLanguage_Tap(_ sender: UIButton) {
        
        let stryB = UIStoryboard(name: "Host", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "HostChooseLanguageVC") as! HostChooseLanguageVC
        vc.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func infoBtn(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Host", bundle: nil)
        let popoverContent = storyboard.instantiateViewController(withIdentifier: "InfoPopVC") as! InfoPopVC
        popoverContent.msg = "Before you can book or host  on the platform the name on Id must match verification documents."
        popoverContent.modalPresentationStyle = .popover
        
        if let popover = popoverContent.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds // Attach to the button bounds
            popover.permittedArrowDirections = .down // Force the popover to show below the button
            popover.delegate = self
            popoverContent.preferredContentSize = CGSize(width: 230, height: 80)
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Ensures the popover does not change to fullscreen on compact devices.
    }
    
    @IBAction func btnCreateNewListing_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewListingVC") as! CreateNewListingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPaymentWithdrawals_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostPaymentVC") as! HostPaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnAddNewPayoutMethod_Tap(_ sender: UIButton) {
        
        let stryB = UIStoryboard(name: "AddCards", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.navigationController?.pushViewController(vc, animated: true)
//        let nav = UINavigationController(rootViewController: vc)
//        nav.setNavigationBarHidden(true, animated: true)
//        UIApplication.shared.windows.first?.rootViewController = nav
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    @IBAction func btnAddNewPayment_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "AddCards", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "AddCardBankContainerVC") as! AddCardBankContainerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func btnEditName_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "ChangeNameVC") as! ChangeNameVC
        
        self.present(vc, animated: true)
    }
    @IBAction func btnConfirmEmail_Tap(_ sender: UIButton) {
        view_Verification.isHidden = false
        verificationStatus = "Email"
        self.verificationDetaiilLbl.text = "Enter your registered email for\nthe verification process,we will send\n4 digits code to your email."
        if verificationStatus == "Email" {
            view_phoneVerification.isHidden = true
            view_EmailVerificaiton.isHidden = false
        }
    }
    @IBAction func btnLogout_Tap(_ sender: UIButton) {
        print("Logout")
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "LogoutPopUpVC") as! LogoutPopUpVC
     
        vc.backAction = {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HomeVCWithoutLoginVC") as! HomeVCWithoutLoginVC
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnSwitchToGuest_Tap(_ sender: UIButton) {
        print("Switch To Guest")
        
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
        Panel = "Guest"
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
 
        
    }
    
    @IBAction func btnBooking_Tap(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2 
    }
    @IBAction func btnNotification_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnHelpCenter_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        vc.comingFrom = "Host"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func btnCrossOTPVerification_Tap(_ sender: UIButton) {
        resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
        timer.invalidate()
        self.lbl_time.text = "00:00sec"
        self.resendBtnO.isUserInteractionEnabled = true
        self.view_timeResend.isHidden = true
        view_OTPVerification.isHidden = true
    }
    
    @IBAction func btnSubmitOTPVerification_Tap(_ sender: UIButton) {
        
        timer.invalidate()
        self.resendBtnO.isUserInteractionEnabled = true
        self.lbl_time.text = "00:00sec"
        resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
        view_OTPVerification.isHidden = true
        view_timeResend.isHidden = true
        
//        if verificationStatus == "Phone" {
//            if self.editEmail_Phone == "EditPhone"{
//                self.editEmail_Phone = ""
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
            vc.comesFrom = verificationStatus
            vc.backCome = {
                if self.verificationStatus == "Phone" {
                    if self.editEmail_Phone == "EditPhone"{
                        self.editEmail_Phone = ""
                    }else{
                        self.view_ConfirmNowPhone.isHidden = true
                        self.view_VerifiedPhone.isHidden = false
                    }
                }else if self.verificationStatus == "Email" {
                    if self.editEmail_Phone == "EditEmail"{
                        self.editEmail_Phone = ""
                    }else{
                        self.view_ConfirmNowEmail.isHidden = true
                        self.view_VerifiedEmail.isHidden = false
                    }
                }
            }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)

    }
    @IBAction func btnShareFeedback_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "ShareFeedbackVC") as! ShareFeedbackVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTermCondition_Tap(_ sender: UIButton) {
        let stryB = UIStoryboard(name: "Main", bundle: nil)
        let vc = stryB.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
     
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnResendOTPVerificaiton_Tap(_ sender: UIButton) {
        view_timeResend.isHidden = false
        sender.isUserInteractionEnabled = false
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        var runCount = Int()
            runCount = 60
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            
            runCount -= 1
            let minutes = runCount / 60
            let seconds = runCount % 60
            self.lbl_time.text = String(format: "%02d:%02dsec", minutes, seconds)
            
            if runCount == 0 {
                self.lbl_time.text = "00:00sec"
                self.view_timeResend.isHidden = true
                sender.isUserInteractionEnabled = true
                sender.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                timer.invalidate()
            }
        }
    }
    
    @IBAction func btnCrossVerificaiton_Tap(_ sender: UIButton) {
        self.editEmail_Phone = ""
        view_Verification.isHidden = true
    }
    @IBAction func btnConfirmPhone_Tap(_ sender: UIButton) {
        
        countryCodeTF.text = "🇺🇸 +1"
        view_Verification.isHidden = false
        verificationStatus = "Phone"
        self.verificationDetaiilLbl.text = "Enter your registered phone for\nthe verification process,we will send\n4 digits code to your phone."
        if verificationStatus == "Phone" {
            view_phoneVerification.isHidden = false
            view_EmailVerificaiton.isHidden = true
        }
//        verificationStatus = "Phone"
//        if verificationStatus == "Phone" {
//            view_phoneVerification.isHidden = false
//            view_EmailVerificaiton.isHidden = true
//        }
  
    }
    @IBAction func btnverifyIdentity_Tap(_ sender: UIButton) {
  
    }
    
    @IBAction func btnsaveProfile_Tap(_ sender: UIButton) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as! MainTabVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func btnSubmit_Verification(_ sender: UIButton) {
        if verificationStatus == "Phone" {
            view_Verification.isHidden = true
            view_OTPVerification.isHidden = false
            self.OTPverificationDetaiilLbl.text = "Please type the verification code send to +1 999 999 9999"
        }
        if verificationStatus == "Email" {
            view_Verification.isHidden = true
            view_OTPVerification.isHidden = false
            self.OTPverificationDetaiilLbl.text = "Please type the verification code send to abc@gmail.com"
        }
    }
    
    @IBAction func btnUploadPropilePhoto_Tao(_ sender: UIButton) {
        view_UploadPhoto.isHidden = false
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnOutsideUploadPropilePhoto_Tao(_ sender: UIButton) {
        view_UploadPhoto.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func paymentMethodDropBtn(_ sender: UIButton){
        if sender.isSelected == false {
            sender.isSelected = true
//            self.addCardBtnV.isHidden = true
            self.paymentMethodV.isHidden = false
            paymentDropImg.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
//            self.addCardBtnV.isHidden = false
            self.paymentMethodV.isHidden = true
            paymentDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func btnCamera_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            // Show an alert if the camera is not available
            let alert = UIAlertController(title: "Camera Unavailable",
                                          message: "Your device doesn't have a camera.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }

    }
   
    @IBAction func btnGallery_Tap(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func editEmailBtn(_ sender: UIButton){
        view_Verification.isHidden = false
        verificationStatus = "Email"
        self.verificationDetaiilLbl.text = "Enter your registered email for\nthe verification process,we will send\n4 digits code to your email."
        if verificationStatus == "Email" {
            self.editEmail_Phone = "EditEmail"
            view_phoneVerification.isHidden = true
            view_EmailVerificaiton.isHidden = false
        }
    }
    
    @IBAction func editPhoneBtn(_ sender: UIButton){
        countryCodeTF.text = "🇺🇸 +1"
        view_Verification.isHidden = false
        verificationStatus = "Phone"
        self.verificationDetaiilLbl.text = "Enter your registered phone for\nthe verification process,we will send\n4 digits code to your phone."
        if verificationStatus == "Phone" {
            self.editEmail_Phone = "EditPhone"
            view_phoneVerification.isHidden = false
            view_EmailVerificaiton.isHidden = true
        }
    }
    
    @IBAction func editPassBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NewPasswordVC") as! NewPasswordVC
        vc.comingFrom = "EditPass"
        vc.backAction = { str in
            if str == "Cancel"{
                
            }else{
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                vc.comesFrom = "PassChange"
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
    @IBAction func btnEditStreet_Tap(_ sender: UIButton) {
        if isStreetUpdateStatus {
            // Stop editing and call API
            txt_streetProfile.isUserInteractionEnabled = false
            btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_streetProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit Street")
            viewModel.apiForUpdateStreet(StreetAddress: self.txt_streetProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_streetProfile.isUserInteractionEnabled = true
            txt_streetProfile.becomeFirstResponder()
            btnEditStreet.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isStreetUpdateStatus.toggle()
    }
    
    @IBAction func btnEditCity_Tap(_ sender: UIButton) {
        
        if isCityUpdateStatus {
            // Stop editing and call API
            txt_cityProfile.isUserInteractionEnabled = false
            btnEditCity.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_cityProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit City")
            viewModel.apiForUpdateCity(City: self.txt_cityProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_cityProfile.isUserInteractionEnabled = true
            txt_cityProfile.becomeFirstResponder()
            btnEditCity.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isCityUpdateStatus.toggle()
        
    }
    @IBAction func btnEditState_Tap(_ sender: UIButton) {
        
        
        if isStateUpdateStatus {
            // Stop editing and call API
            txt_stateProfile.isUserInteractionEnabled = false
            btnEditState.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_stateProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit State")
            viewModel.apiForUpdateState(State: self.txt_stateProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_stateProfile.isUserInteractionEnabled = true
            txt_stateProfile.becomeFirstResponder()
            btnEditState.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isStateUpdateStatus.toggle()
        
    }
    @IBAction func btnEditZip_Tap(_ sender: UIButton) {
        
        
        if isZipcdeUpdateStatus {
            // Stop editing and call API
            txt_zipProfile.isUserInteractionEnabled = false
            btnEditZip.setImage(UIImage(named: "EditPencilicon"), for: .normal)
            txt_zipProfile.resignFirstResponder()
            //  if txt_streetProfile.text != placeholderText {
            print("api call here for edit zipcode")
            viewModel.apiForUpdateZipcode(zip: self.txt_zipProfile.text ?? "")
            // }
        } else {
            // Start editing
            txt_zipProfile.isUserInteractionEnabled = true
            txt_zipProfile.becomeFirstResponder()
            btnEditZip.setImage(UIImage(named: "rightSigntick"), for: .normal)
            
        }
        isZipcdeUpdateStatus.toggle()
        
    }
    
    func setupTextFields() {
        txt_streetProfile.delegate = self
        txt_cityProfile.delegate = self
        txt_stateProfile.delegate = self
        txt_zipProfile.delegate = self
        txt_streetProfile.isUserInteractionEnabled = false
        txt_cityProfile.isUserInteractionEnabled = false
        txt_stateProfile.isUserInteractionEnabled = false
        txt_zipProfile.isUserInteractionEnabled = false
        txt_streetProfile.placeholder = "Street"
        txt_cityProfile.placeholder = "City"
        txt_stateProfile.placeholder = "State"
        txt_zipProfile.placeholder = "Zipcode"
    }
    
    
    private func bindViewModel() {
        viewModelEmailVerifyOTP.userID = self.userID
        viewModelEmailVerifyOTP.otpCode = self.OTP
        
        viewModelPhoneVerifyOTP.userID = self.userID
        viewModelPhoneVerifyOTP.otpCode = self.OTP
        
        txt_EmailVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModelVerifyEmail)
            .store(in: &cancellables)
        
        txt_PhoneVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModelVerifyPhone)
            .store(in: &cancellables)
        
        txt_PhoneVerification.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModelUpdatePhone)
            .store(in: &cancellables)
    }
    
    func setupTextView() {
        aboutMeTxtV.delegate = self
        aboutMeTxtV.isEditable = false // Initially non-editable
//        txtV_AboutMe.text = placeholderText
//        txtV_AboutMe.textColor = UIColor.lightGray // Placeholder color
    }
    
}

extension HostProfileVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImg.image = selectedImage
            view_UploadPhoto.isHidden = true
            viewModel.encodeImageToString(image: selectedImage)
            self.tabBarController?.setTabBarHidden(false, animated: false)
           
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HostProfileVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Place {
            if self.locationArray.count == 0{
                return 1
            }else if self.locationArray.count >= 2{
                return self.locationArray.count
                
            }else{
                return self.locationArray.count + 1
            }
        } else if collectionView == collecV_MyWork {
            if  self.myWorkArr.count == 0 {
                return 1
            } else if self.myWorkArr.count >= 2{
                return self.myWorkArr.count
                
            }else {
                return myWorkArr.count + 1
            }
        }
        else if collectionView == collecV_MyLanguage {
            if  self.myLanguageArr.count == 0 {
                return 1
            } else if self.myLanguageArr.count >= 2{
                return self.myLanguageArr.count
                
            }else {
                return myLanguageArr.count + 1
            }
        }
        else if collectionView == collecV_MyHobbies {
            if  self.myHobbiesArr.count == 0 {
                return 1
            } else if self.myHobbiesArr.count >= 2{
                return self.myHobbiesArr.count
                
            }else {
                return myHobbiesArr.count + 1
            }
        } else {
            if  self.myPetsArr.count == 0 {
                return 1
            } else if self.myPetsArr.count >= 2{
                return self.myPetsArr.count
                
            }else {
                return myPetsArr.count + 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Place {
            let cell = collecV_Place.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.locationArray.count {
                // Display language name for regular cells
                let language = self.locationArray[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "location line")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLocation(sender:)), for: .touchUpInside)
                cell.lbl_title.text = locationArray[indexPath.item]  // Assuming you have a label for displaying the language
                cell.lbl_title.sizeToFit()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLocation(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyWork {
            let cell = collecV_MyWork.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myWorkArr.count {
                // Display language name for regular cells
                let language = self.myWorkArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                
                cell.imgicon.image = UIImage(named: "myworkicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteWork(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myWorkArr[indexPath.row]  // Assuming you have a label for displaying the language
                //  /*cell.lbl_title.sizeToFit*/()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewWork(sender:)), for: .touchUpInside)
            }
            return cell
        }
        else if collectionView == collecV_MyLanguage {
            let cell = collecV_MyLanguage.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myLanguageArr.count {
                // Display language name for regular cells
                let language = self.myLanguageArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                
                cell.imgicon.image = UIImage(named: "languageicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteLanguage(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myLanguageArr[indexPath.row]  // Assuming you have a label for displaying the language
                // /*cell.lbl_title.sizeToFit*/()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "laguange"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewLanguage(sender:)), for: .touchUpInside)
                // cell.btnAddNew.addTarget(self, action: #selector(self.addNewLaguage(sender:)), for: .touchUpInside)
            }
            return cell
        } else if collectionView == collecV_MyHobbies {
            let cell = collecV_MyHobbies.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myHobbiesArr.count {
                // Display language name for regular cells
                let language = self.myHobbiesArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                
                cell.btnCross.tag = indexPath.row
                cell.imgicon.image = UIImage(named: "hobbiesicon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeleteHobbies(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myHobbiesArr[indexPath.row]  // Assuming you have a label for displaying the language
                //cell.lbl_title.sizeToFit()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "Hobbie"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewhobbies(sender:)), for: .touchUpInside)
                // cell.btnAddNew.addTarget(self, action: #selector(self.addMyHobbies(sender:)), for: .touchUpInside)
            }
            return cell
        } else {
            let cell = collecV_MyPets.dequeueReusableCell(withReuseIdentifier: "MasterCell", for: indexPath) as! MasterCell
            cell.view_Type.isHidden = true
            if indexPath.item < self.myPetsArr.count {
                // Display language name for regular cells
                let language = self.myPetsArr[indexPath.item]
                cell.view_main.isHidden = false
                cell.view_AddNew.isHidden = true
                cell.btnCross.tag = indexPath.row
                
                cell.imgicon.image = UIImage(named: "peticon")
                //cell.imgAddicon.image = UIImage(named: "myworkicon")
                
                cell.btnCross.addTarget(self, action: #selector(self.DeletePets(sender:)), for: .touchUpInside)
                cell.lbl_title.text = myPetsArr[indexPath.row]  // Assuming you have a label for displaying the language
                // cell.lbl_title.sizeToFit()
            } else {
                // Last index, show "Add New" button
                cell.view_main.isHidden = true
                cell.view_AddNew.isHidden = false
                cell.btnAddNew.tag = indexPath.row
                types = "PEts"
                cell.txt_Workname.delegate = self
                cell.btnAddNew.addTarget(self, action: #selector(self.addNewPets(sender:)), for: .touchUpInside)
                // cell.btnAddNew.addTarget(self, action: #selector(self.addMyPets(sender:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    // MARK: - Add location or delete location
    @objc func addNewLocation (sender: UIButton) {
        print(sender.tag)
        self.autocompleteClicked()
    }
    
    @objc func DeleteLocation (sender: UIButton) {
        print(sender.tag)
        
        self.indexforDeleteLocation = sender.tag
        viewModel.apiForDeletePlace(index: sender.tag)
        
        //        locationArray.remove(at: sender.tag)
        //        self.collecV_Place.reloadData()
    }
    // MARK: -  Add work or delete work
    @objc func addNewWork (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "myworkicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyWork.performBatchUpdates(nil)
        
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addNewWorkFinal(sender:)), for: .touchUpInside)
        
    }
    @objc func addNewWorkFinal (sender: UIButton) {
        print(sender.tag)
        
        guard let cell = collecV_MyWork.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            self.showAlert(for: "Add work")
        } else {
            
            viewModel.apiForAddWork(workName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            // myWorkArr.append(cell.txt_Workname.text ?? "")
            // self.collecV_MyWork.reloadData()
        }
        
    }
    @objc func DeleteWork (sender: UIButton) {
        print(sender.tag)
        
        self.indexforDeleteWork = sender.tag
        viewModel.apiForDeleteWork(index: sender.tag)
        
        //        myWorkArr.remove(at: sender.tag)
        //        self.collecV_MyWork.reloadData()
        
    }
    
    // MARK: - Add Language or Delete Language
    @objc func addNewLanguage (sender: UIButton) {
        print(sender.tag)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostChooseLanguageVC") as! HostChooseLanguageVC
        
        vc.backAction = { str in
            print(str,"Data Recieved")
            self.viewModel.apiForAddLanguage(languageName: str)
            // self.myLanguageArr.append(str)
            self.collecV_MyLanguage.reloadData()
        }
        self.present(vc, animated: true)
        
    }
    
    @objc func addNewLaguagefinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyLanguage.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //        cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Language")
        } else {
            
            //            viewModel.apiForAddLanguage(languageName: cell.txt_Workname.text ?? "")
            //            cell.txt_Workname.text = ""
            //            myLanguageArr.append(cell.txt_Workname.text ?? "")
            //            self.collecV_MyLanguage.reloadData()
        }
    }
    
    @objc func DeleteLanguage (sender: UIButton) {
        print(sender.tag)
        
        viewModel.apiForDeleteLanguage(index: sender.tag)
        self.indexforDeleteLanguage = sender.tag
        
        //        myLanguageArr.remove(at: sender.tag)
        //        self.collecV_MyLanguage.reloadData()
    }
    
    
    // MARK: - Add or Delete Hobbies
    @objc func addNewhobbies (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        cell.imgAddicon.image = UIImage(named: "hobbiesicon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyHobbies.performBatchUpdates(nil)
        cell.btnAddWork.tag = sender.tag
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyHobbiesfinal(sender:)), for: .touchUpInside)
        
    }
    
    @objc func addMyHobbiesfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyHobbies.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        //  cell.widthH_constant.constant = 150
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Hobby")
        } else {
            
            viewModel.apiForAddHobbies(HobbyName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            // myHobbiesArr.append(cell.txt_Workname.text ?? "")
            // self.collecV_MyHobbies.reloadData()
        }
    }
    
    @objc func DeleteHobbies (sender: UIButton) {
        print(sender.tag)
        viewModel.apiForDeleteHobby(index: sender.tag)
        self.indexforDeleteHobby = sender.tag
        //        myHobbiesArr.remove(at: sender.tag)
        //        self.collecV_MyHobbies.reloadData()
    }
    
    // MARK: - ADD Pets or Delete Pets
    @objc func addNewPets (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        print(types,"category ")
        cell.imgAddicon.image = UIImage(named: "peticon")
        cell.view_main.isHidden = true
        cell.view_AddNew.isHidden = true
        cell.view_Type.isHidden = false
        cell.btnAddWork.tag = sender.tag
        
        cell.widthH_constant.constant = 43
        // Ensure the layout is updated
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        // Optionally update the layout for the collection view
        collecV_MyPets.performBatchUpdates(nil)
        
        cell.btnAddWork.addTarget(self, action: #selector(self.addMyPetsfinal(sender:)), for: .touchUpInside)
        
    }
    
    @objc func addMyPetsfinal (sender: UIButton) {
        print(sender.tag)
        guard let cell = collecV_MyPets.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? MasterCell else {return}
        
        if cell.txt_Workname.text == "" {
            print("enter name")
            showAlert(for: "Enter Pet Name")
        } else {
            
            viewModel.apiForAddPet(PetName: cell.txt_Workname.text ?? "")
            cell.txt_Workname.text = ""
            // myPetsArr.append(cell.txt_Workname.text ?? "")
            //self.collecV_MyPets.reloadData()
        }
    }
    
    @objc func DeletePets (sender: UIButton) {
        print(sender.tag)
        
        self.indexforDeletePet = sender.tag
        viewModel.apiForDeletePet(index: sender.tag)
        //        myPetsArr.remove(at: sender.tag)
        //        self.collecV_MyPets.reloadData()
    }
}

extension HostProfileVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bankTblV{
            return addedBankDetailsData.count
        }else{
            return addedCardDetailsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == bankTblV{
            let cell = bankTblV.dequeueReusableCell(withIdentifier: "BankDetailTblVCell", for: indexPath) as! BankDetailTblVCell
            cell.bankDetailLbl.text = addedBankDetailsData[indexPath.row].bankName
            cell.bankDotBtn.tag = indexPath.row
            cell.bankDotBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            cell.bankDetailView.isHidden = false
            if addedBankDetailsData[indexPath.row].defaultForCurrency == true{
                cell.bankPrefferdV.isHidden = false
                cell.bankDotBtn.isHidden = true
            }else{
                cell.bankPrefferdV.isHidden = true
                cell.bankDotBtn.isHidden = false
            }
           
            cell.cardDetailView.isHidden = true
            return cell
        }else{
            let cell = cardTblV.dequeueReusableCell(withIdentifier: "BankDetailTblVCell", for: indexPath) as! BankDetailTblVCell
            cell.cardDetailLbl.text = "**** **** **** \(addedCardDetailsData[indexPath.row].lastFourDigits ?? "")"
            cell.cardDotBtn.tag = indexPath.row
            cell.cardDotBtn.addTarget(self, action: #selector(CardDotBtnTapped(_:)), for: .touchUpInside)
            cell.bankDetailView.isHidden = true
            cell.cardPrefferdV.isHidden = true
            cell.cardDotBtn.isHidden = false
            cell.cardDetailView.isHidden = false
            if addedCardDetailsData[indexPath.row].defaultForCurrency == true{
                cell.cardPrefferdV.isHidden = false
                cell.cardDotBtn.isHidden = true
            }else{
                cell.cardPrefferdV.isHidden = true
                cell.cardDotBtn.isHidden = false
            }
            return cell
        }
       
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = ["Set as primary","Delete"]
        dotDropdown.direction = .any
        
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
            
        }
        dotDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            if index == 0{
                self.viewModelPaymentMethod.apiforSetPrimaryMethod(id: self.addedBankDetailsData[sender.tag].id)
            }else{
                self.viewModelPaymentMethod.apiforDeletePayoutMethod(id: self.addedBankDetailsData[sender.tag].id)
            }
            //Api For GetPayoutMethods
            viewModelPaymentMethod.apiforGetPayoutMethods()
        }
        dotDropdown.show()
    }
    
    @objc func CardDotBtnTapped(_ sender: UIButton) {
        // Set up the dropdown
        dotDropdown.anchorView = sender // Anchor dropdown to the button
        dotDropdown.dataSource = ["Set as primary","Delete"]
        dotDropdown.direction = .any
        
        dotDropdown.backgroundColor = UIColor.white
        dotDropdown.cornerRadius = 10
        dotDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dotDropdown.layer.shadowColor = UIColor.gray.cgColor
        dotDropdown.layer.shadowOpacity = 0.2
        dotDropdown.layer.shadowRadius = 10
        dotDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = dotDropdown.anchorView?.plainView.bounds.height {
            dotDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dotDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        dotDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            if index == 0{
                self.viewModelPaymentMethod.apiforSetPrimaryMethod(id: self.addedCardDetailsData[sender.tag].id)
            }else{
                self.viewModelPaymentMethod.apiforDeletePayoutMethod(id: self.addedCardDetailsData[sender.tag].id)
            }
            //Api For GetPayoutMethods
            viewModelPaymentMethod.apiforGetPayoutMethods()
        }
        dotDropdown.show()
    }
    
}

extension HostProfileVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = 50
        var cellWidth: CGFloat = 150  // Default width
        
        // Handle different collection views based on which one is being displayed
        switch collectionView {
        case collecV_Place:
            return getSizeForCollectionView(dataArray: locationArray, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
        case collecV_MyWork:
            return getSizeForCollectionView(dataArray: myWorkArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyLanguage:
            return getSizeForCollectionView(dataArray: myLanguageArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyHobbies:
            return getSizeForCollectionView(dataArray: myHobbiesArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        case collecV_MyPets:
            return getSizeForCollectionView(dataArray: myPetsArr, indexPath: indexPath, defaultWidth: cellWidth, cellHeight: cellHeight)
            
        default:
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    
    // Generalized function to calculate cell size based on the array and indexPath
    func getSizeForCollectionView(dataArray: [String], indexPath: IndexPath, defaultWidth: CGFloat, cellHeight: CGFloat) -> CGSize {
        var cellWidth = defaultWidth
        var text = ""
        if dataArray.count == 1 {
            if indexPath.item == 0 {
                text = dataArray[0]
                print(text)
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
            if indexPath.item == 1 {
                return CGSize(width: cellWidth, height: cellHeight)
            }
            
        }else if dataArray.count == 2{
            if indexPath.item == 0 {
                text = dataArray[0]
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
            if indexPath.item == 1 {
                text = dataArray[1]
                if let calculatedWidth = calculateWidth(for: text) {
                    cellWidth = calculatedWidth
                    return CGSize(width: cellWidth, height: cellHeight)
                }
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func calculateWidth(for text: String) -> CGFloat? {
        guard !text.isEmpty else { return nil }
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15) // Set a font if needed
        
        // Calculate the width of the text
        let textAttributes = [NSAttributedString.Key.font: label.font!]
        let textWidth = (text as NSString).size(withAttributes: textAttributes).width
        
        // Add some padding to the calculated text width
        let padding: CGFloat = 70
        let dynamicWidth = textWidth + padding
        
        print(dynamicWidth, "Dynamic Width")
        return dynamicWidth
    }

    // Set minimum line spacing and inter-item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
}


extension HostProfileVC: CLLocationManagerDelegate{
    @objc func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        autocompleteController.autocompleteFilter = filter
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        autocompleteController.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//.white]
    }
}

extension HostProfileVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place ID: \(String(describing: place.placeID))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Place latitude: \(place.coordinate.latitude)")
        print("Place longitude: \(place.coordinate.longitude)")
        
        print("Place formattedAddress: \(String(describing: place.formattedAddress!))")
        if place.name != nil {
            UserDefaults.standard.set("\(place.coordinate.latitude)", forKey: "selectedlat")
            UserDefaults.standard.set("\(place.coordinate.longitude)", forKey: "selectedLong")
            
            self.locationArray.append("\(place.name ?? "")")
            self.collecV_Place.reloadData()
           
            NotificationCenter.default.post(name: NSNotification.Name("currentLocation"), object: ["latitude":"\(place.coordinate.latitude)","longitude":"\(place.coordinate.longitude)"])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        // self.AlertControllerOnr(title: "Error", message: error.localizedDescription, BtnTitle: "OK")
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension HostProfileVC :DPOTPViewDelegate{
    
    func dpOTPViewAddText(_ text: String, at position: Int) {
       // viewModel.updateOTPText(text)
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {}
    func dpOTPViewChangePositionAt(_ position: Int) {}
    func dpOTPViewBecomeFirstResponder() {}
    func dpOTPViewResignFirstResponder() {}
    
}

extension HostProfileVC: UITextFieldDelegate {
    
    @objc func keyboardWillShow(sender: NSNotification) {
        let info = sender.userInfo!
        let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        // Adjust the bottom constraint based on the keyboard's height
        tbl_bottom_h.constant = keyboardHeight

        // Get the visible cells of the collection view and update the label widths dynamically
        for cell in self.collecV_Place.visibleCells {
            if let myCell = cell as? MasterCell {
                let labelText = myCell.lbl_title.text ?? ""
                let font = myCell.lbl_title.font ?? UIFont.systemFont(ofSize: 12)

                // Calculate the dynamic width of the label's text
                let textAttributes = [NSAttributedString.Key.font: font]
                let textWidth = (labelText as NSString).size(withAttributes: textAttributes).width
                let padding: CGFloat = 20 // Add some padding
                
               
                // Update the label's width constraint
                myCell.lbl_title.translatesAutoresizingMaskIntoConstraints = false
                myCell.lbl_title.widthAnchor.constraint(equalToConstant: textWidth + padding).isActive = true
            }
        }

        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
        
        // Scroll the active text field into view (if applicable)
        if let activeField = self.activeTextField {
            scrollViewToVisible(activeField, withKeyboardHeight: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let animationDuration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        // Reset the bottom constraint
        tbl_bottom_h.constant = 24 // original constraint value

        // Update layout with animation
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewToVisible(_ textField: UITextField, withKeyboardHeight keyboardHeight: CGFloat) {
        // Ensure the scrollView exists
        guard let scrollView = self.scrollV else { return }
        
        // Calculate the visible area of the scrollView by subtracting the keyboard height
        var visibleRect = scrollView.frame
        visibleRect.size.height -= keyboardHeight
        
        // Convert the text field's frame to the scroll view's coordinate system
        let textFieldFrame = textField.convert(textField.bounds, to: scrollView)
        
        // Check if the text field is outside the visible area
        if !visibleRect.contains(textFieldFrame.origin) {
            // Scroll the scroll view so the text field is visible
            scrollView.scrollRectToVisible(textFieldFrame, animated: true)
        }
    }

    // Track the active text field when editing begins
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    // Clear the active text field when editing ends
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

extension HostProfileVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
        countryCodeTF.text = "\(flag) (\(code))"
    }
}

extension HostProfileVC {
    
    private func tobeVerifyPhone(OTP:String,Phone:String,userId:String){
        
        viewModelPhoneVerifyOTP.otpCode = OTP
        viewModelPhoneVerifyOTP.userID = userId
        view_Verification.isHidden = true
        view_OTPVerification.isHidden = false
        self.OTPverificationDetaiilLbl.text = "Please type the verification code send to \(Phone)"
        
    }
    
    private func tobeupdatePhone(OTP:String,Phone:String,userId:String){
        
        self.phonetobeUpdate = Phone
        
        viewModelPhoneVerifyOTP.otpCode = OTP
        viewModelPhoneVerifyOTP.userID = userId
        view_Verification.isHidden = true
        view_OTPVerification.isHidden = false
        self.OTPverificationDetaiilLbl.text = "Please type the verification code send to \(Phone)"
        
    }
    
    private func tobeVerifyEmail(OTP:String,Email:String,userId:String){
        
        viewModelEmailVerifyOTP.otpCode = OTP
        viewModelEmailVerifyOTP.userID = userId
        view_Verification.isHidden = true
        view_OTPVerification.isHidden = false
        self.OTPverificationDetaiilLbl.text = "Please type the verification code send to \(Email)"
        
    }
    func bindVC(){
        
        // updateStreetResult
        viewModel.$updateStreetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var txt = response.data?.addedStreetAddress ?? ""
                    self.txt_streetProfile.text = txt
                    self.btnEditStreet.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.txt_streetProfile.isUserInteractionEnabled = false
                    
                })
            }.store(in: &cancellables)
        
        // updateAboutMeResult
        viewModel.$updateAbouMeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var txt = response.data?.addedAboutMe ?? ""
                    self.aboutMeTxtV.text = txt
//                    self.btnEditAboutMe.setImage(UIImage(named: "EditPencilicon"), for: .normal)
                    self.aboutMeTxtV.isEditable = false
                    
                })
            }.store(in: &cancellables)
        
        
        // updateProfileImage
        viewModel.$getUpdateProfileImgResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var image = response.data?.profileImageURL ?? ""
                    let imgURL = AppURL.imageURL + image
                    self.profileIMGURL = imgURL
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    
                })
            }.store(in: &cancellables)
        
        // AddLanguage
        viewModel.$addLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var addedlng = response.data?.addedlanguage ?? ""
                    self.myLanguageArr.append(addedlng)
                    self.collecV_MyLanguage.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        // DeleteLocation
        viewModel.$deleteLanguageResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.myLanguageArr.remove(at: self.indexforDeleteLanguage ?? 0)
                    self.collecV_MyLanguage.reloadData()
                    
                    
                })
            }.store(in: &cancellables)
        
        
        
        // AddPet
        viewModel.$addPetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var addedPet = response.data?.addedPet ?? ""
                    self.myPetsArr.append(addedPet)
                    self.collecV_MyPets.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        // DeleteLocation
        viewModel.$deletePetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.myPetsArr.remove(at: self.indexforDeletePet ?? 0)
                    self.collecV_MyPets.reloadData()
                    
                    
                })
            }.store(in: &cancellables)
        
        
        // AddHobby
        viewModel.$addHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var addedHobby = response.data?.addedHobby ?? ""
                    self.myHobbiesArr.append(addedHobby)
                    self.collecV_MyHobbies.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        // DeleteLocation
        viewModel.$deleteHobbyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    self.myHobbiesArr.remove(at: self.indexforDeleteHobby ?? 0)
                    self.collecV_MyHobbies.reloadData()
                    
                    
                })
            }.store(in: &cancellables)
        
        
        // AddPlace
        viewModel.$addPlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var addedLocation = response.data?.addedLocation ?? ""
                    self.locationArray.append(addedLocation)
                    self.collecV_Place.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        // DeleteLocation
        viewModel.$deletePlaceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.locationArray.remove(at: self.indexforDeleteLocation ?? 0)
                    self.collecV_Place.reloadData()
                    
                    
                })
            }.store(in: &cancellables)
        
        // DeleteWork
        viewModel.$deleteWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.myWorkArr.remove(at: self.indexforDeleteWork ?? 0)
                    self.collecV_MyWork.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        // AddWork
        viewModel.$addWorkResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    var workAdded = response.data?.addedWork ?? ""
                    self.myWorkArr.append(workAdded)
                    self.collecV_MyWork.reloadData()
                    
                })
            }.store(in: &cancellables)
        
        
        
        viewModel.$getMyProfileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    self.profileData = nil
                    self.profileData = response.data
                    var isEmailVerified = self.profileData?.emailVerified ?? 0
                    // print(isEmailVerified,"isEmailVerified")
                    var isPhoneVerified = self.profileData?.phoneVerified ?? 0
                    // print(isPhoneVerified,"isPhoneVerified")
                    if isEmailVerified == 1 {
                        self.view_ConfirmNowEmail.isHidden = true
                        self.view_VerifiedEmail.isHidden = false
                    } else {
                        self.view_ConfirmNowEmail.isHidden = false
                        self.view_VerifiedEmail.isHidden = true
                    }
                    if isPhoneVerified == 1 {
                        self.view_ConfirmNowPhone.isHidden = true
                        self.view_VerifiedPhone.isHidden = false
                    } else {
                        self.view_ConfirmNowPhone.isHidden = false
                        self.view_VerifiedPhone.isHidden = true
                    }
                    
                    self.identity_verify = self.profileData?.identityVerified ?? 0
                    
                    if  self.identity_verify == 1 {
                        self.view_ConfirmNowIndentity.isHidden = true
                        self.view_VerifiedIndentity.isHidden = false
                    } else {
                        self.view_ConfirmNowIndentity.isHidden = false
                        self.view_VerifiedIndentity.isHidden = true
                    }
                    
                    let imgURL = AppURL.imageURL + (self.profileData?.profileImage ?? "")
                    self.profileIMGURL = imgURL
                    self.profileImg.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    
                    // self.profileImg.loadImage(from:self.profileData?.profileImage ?? "",placeholder: UIImage(named: "user"))
                    var nameUser = "\(self.profileData?.firstName  ?? "")" +  " \(self.profileData?.lastName  ?? "")!"
                    // var imgurlss = self.profileData?.profileImage ?? ""
                    print(nameUser,"nameUser")
                    self.lbl_nameUser.text = nameUser
                    
                    
                    self.fName = "\(self.profileData?.firstName  ?? "")"
                    self.lName = "\(self.profileData?.lastName  ?? "")"
                    
                    
                    
                    var street =  self.profileData?.street ?? ""
                    var city =  self.profileData?.city ?? ""
                    var state =  self.profileData?.state ?? ""
                    var zip =  self.profileData?.zipCode ?? ""
                    
                    self.txt_streetProfile.text = street
                    self.txt_cityProfile.text = city
                    self.txt_stateProfile.text = state
                    self.txt_zipProfile.text = zip
                    
                    let email = self.profileData?.email ?? ""
                    var desc = self.profileData?.aboutMe ?? ""
                    
                    var Phone = self.profileData?.phoneNumber ?? ""
                    
                    print(Phone,"Phone Number")
                    
                    print(email,"email USER")
                    
                    print(desc,"Desc About Me")
                    self.aboutMeTxtV.text = desc
                    if self.aboutMeTxtV.text == "Description" {
                        self.aboutMeTxtV.textColor = .gray
                    } else {
                        self.aboutMeTxtV.textColor = .black
                    }
                    self.txt_PhoneProfile.text = Phone
//                    self.aboutMeTxtV.text = desc
                    self.txt_EmailProfile.text = email
                    self.myPetsArr = self.profileData?.pets ?? []
                    self.myHobbiesArr = self.profileData?.hobbies ?? []
                    self.myLanguageArr = self.profileData?.languages ?? []
                    self.locationArray = self.profileData?.whereLive ?? []
                    self.myWorkArr = self.profileData?.myWork ?? []
                    
                    print(self.myPetsArr,"self.myPetsArr")
                    print(self.myHobbiesArr,"self.myHobbiesArr")
                    print(self.myLanguageArr,"self.myLanguageArr")
                    print(self.locationArray,"self.locationArray")
                    print(self.myWorkArr,"self.myWorkArr")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        self.collecV_Place.reloadData()
                        self.collecV_MyLanguage.reloadData()
                        self.collecV_MyPets.reloadData()
                        self.collecV_MyWork.reloadData()
                        self.collecV_MyHobbies.reloadData()
                }
                    
                })
            }.store(in: &cancellables)
        
        // Email verification
        viewModelVerifyEmail.$emailVerificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    print(response.data?.email ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    
                    self.tobeVerifyEmail(OTP: "\(response.data?.otp ?? 0)", Email: (response.data?.email ?? ""),userId:"\(response.data?.userID ?? 0)" )
                    
                })
            }.store(in: &cancellables)
        
        
        viewModelEmailVerifyOTP.$emailVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "0","RESULT AFTER VERIFICATION")
                    
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_OTPVerification.isHidden = true
                    self.view_timeResend.isHidden = true
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                    vc.comesFrom = self.verificationStatus
                    vc.backCome = {
                        if self.verificationStatus == "PhoneVerified" {
                            //  if self.editEmail_Phone == "EditPhone"{
                            self.editEmail_Phone = ""
                            // }else{
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            //}
                        }else if self.verificationStatus == "EmailVerified" {
                            // if self.editEmail_Phone == "EditEmail"{
                            self.editEmail_Phone = ""
                            //}else{
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            // }
                        }
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                })
            }.store(in: &cancellables)
        
        //Result Verify Identity
        
        viewModel.$verifyIdentityResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    
                    self.view_ConfirmNowIndentity.isHidden = true
                    self.view_VerifiedIndentity.isHidden = false
                    
                                      
                })
            }.store(in: &cancellables)
        
        
        //Result UpdatePhoneNumber
        
        viewModelUpdatePhone.$updateMobileResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    
                    print(response.message ?? "0","MESSAGE")
                      
                    print(response.data?.phoneNumber ?? "","Phone")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                   
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP  = "\(response.data?.otp ?? 0)"
                    
                    self.tobeupdatePhone(OTP: "\(response.data?.otp ?? 0)", Phone: "\(response.data?.phoneNumber ?? "0")", userId: "\(response.data?.userID ?? 0)")
                  
                })
            }.store(in: &cancellables)
        
        
        //Result phoneVerification
        
        viewModelVerifyPhone.$phoneverificationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { [self] response in
                    
                    print(response.data?.phoneNumber ?? "","Email")
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.otp ?? 0,"OTP")
                    
                    self.userID = "\(response.data?.userID ?? 0)"
                    self.OTP  = "\(response.data?.otp ?? 0)"
                    
                    
                    self.tobeVerifyPhone(OTP: "\(response.data?.otp ?? 0)", Phone: "\(response.data?.phoneNumber ?? "0")", userId: "\(response.data?.userID ?? 0)")
                    //                    self.viewModelPhoneVerifyOTP.userID = "\(response.data?.userID ?? 0)"
                    //                    self.viewModelPhoneVerifyOTP.otpCode = "\(response.data?.otp ?? 0)"
                    //
                    print(response.message ?? "0","MESSAGE")
                    
                })
            }.store(in: &cancellables)
        
        
        // Email verification
        viewModelPhoneVerifyOTP.$phoneVerifiedResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    self.resendBtnO.isUserInteractionEnabled = true
                    self.lbl_time.text = "00:00sec"
                    self.resendBtnO.setTitleColor(UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1), for: .normal)
                    self.view_OTPVerification.isHidden = true
                    self.view_timeResend.isHidden = true
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                    vc.comesFrom = self.verificationStatus
                    vc.backCome = {
                        if self.verificationStatus == "PhoneVerified" {
                            //  if self.editEmail_Phone == "EditPhone"{
                            self.editEmail_Phone = ""
                            //  }else{
                           
                            self.view_ConfirmNowPhone.isHidden = true
                            self.view_VerifiedPhone.isHidden = false
                            // }
                        }else if self.verificationStatus == "EmailVerified" {
                            //  if self.editEmail_Phone == "EditEmail"{
                            self.editEmail_Phone = ""
                            // }else{
                            self.view_ConfirmNowEmail.isHidden = true
                            self.view_VerifiedEmail.isHidden = false
                            //  }
                        }
                        else if self.verificationStatus == "UpdatePhone" {
                            self.view_OTPtxt.text = ""
                            self.txt_PhoneProfile.text = self.phonetobeUpdate
                        }
                    }
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_GetPayoutMethods() {
        viewModelPaymentMethod.$getPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        self.addedBankDetailsData.removeAll()
                        self.addedCardDetailsData.removeAll()
                        
                        self.addedBankDetailsData = response.data?.bankAccounts ?? []
                        self.addedCardDetailsData = response.data?.cards ?? []
                        
                        self.bankTblV.reloadData()
                        self.cardTblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_SetPrimary() {
        viewModelPaymentMethod.$SetPrimaryPayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModelPaymentMethod.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_DeleteMethode() {
        viewModelPaymentMethod.$DeletePayoutMethodsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    if response.success == true {
                        //Api For GetPayoutMethods
                        self.viewModelPaymentMethod.apiforGetPayoutMethods()
                    }
                })
            }.store(in: &cancellables)
    }
}
