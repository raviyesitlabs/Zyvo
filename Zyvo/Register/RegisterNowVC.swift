//
//  RegisterNowVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine
import CountryPickerView
import GoogleSignIn

class RegisterNowVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var view_Login: UIView!
    let appleSignIn = HSAppleSignIn()
    let countryPicker = CountryPickerView()
    var social_ID = ""
    var KeepMeLogin = "No"
    
    private var viewModelSocial = LoginViewModel()
    private var viewModel = PhoneSignupViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindVC()
        googleLogin()
        
        countryPicker.delegate = self
        countryPicker.showCountryCodeInView = true
        countryPicker.showPhoneCodeInView = true
        countryCodeTF.inputView = countryPicker
        
        phoneTF.delegate = self
        phoneTF.keyboardType = .numberPad // Set keyboard to number pad
        countryCodeTF.text = "🇺🇸 +1"
        viewModel.countryCode = "+1"
        view_Login.layer.cornerRadius = view_Login.layer.frame.height / 2
        view_Login.layer.borderWidth = 1
        view_Login.layer.borderColor = UIColor.lightGray.cgColor
    }
    private func bindViewModel() {
        
        phoneTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.phone, on: viewModel)
            .store(in: &cancellables)
        
    }
    func googleLogin(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        print(GIDSignIn.sharedInstance()?.currentUser != nil) // true - signed in
        GIDSignIn.sharedInstance()?.signOut()
        print(GIDSignIn.sharedInstance()?.currentUser != nil) // false - signed out
        
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
            print("Already Login Already Login Already Login Already Login ")
            //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as! ProfileVc
            //            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the current text
        let currentText = phoneTF.text ?? ""
        // Create the updated text after replacement
        guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        // Allow only numbers and a maximum of 10 digits
        let isNumeric = updatedText.allSatisfy { $0.isNumber }
        return isNumeric && updatedText.count <= 10
    }
    
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnSelectCountry_Tap(_ sender: UIButton) {
        countryPicker.showCountriesList(from:self)
    }
    
    @IBAction func btnCheckBox(_ sender: UIButton) {
        if KeepMeLogin == "No"{
            self.KeepMeLogin = "Yes"
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
            self.btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
        }else{
            self.KeepMeLogin = "No"
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
            self.btnCheck.setImage(UIImage(named: "uncheckedicon"), for: .normal)
        }
    }
    
    @IBAction func btnContinue_Tap(_ sender: UIButton) {
        
        guard viewModel.isSignUpValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
                // self.showSnackAlert(for: error)
            }
            return
        }
        
        viewModel.signUpPhoneApi()
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        //        vc.comingFrom = "RegisterPhone"
        //        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func btnLogin_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func btnGoogle_Tap(_ sender: UIButton) {
        
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func btnFacebook_Tap(_ sender: UIButton) {
    }
    @IBAction func btnApple_Tap(_ sender: UIButton) {
        
        appleSignIn.didTapLoginWithApple1 { (userInfo, message) in
            if let userInfo = userInfo{
                print(userInfo.email)
                print(userInfo.userid)
                print(userInfo.firstName)
                print(userInfo.lastName)
                print(userInfo.fullName)
                let name = userInfo.firstName != "" ? userInfo.firstName : "Test"
                let email = userInfo.email != "" ? userInfo.email : "\(name)@gmail.com"
                
                self.social_ID = "\(userInfo.userid)"
                
                let emailAddress = email
                
                self.viewModelSocial.apiforSocialLogin(fName: "\(userInfo.firstName)", lName: "\(userInfo.lastName)", Email: emailAddress, socialID: self.social_ID)
                
            }else if let message = message{
                print("Error Message: \(message)")
                AlertController.alert(title: "Alert", message: "Error Message: \(message)")
            }else{
                print("Unexpected error!")
                AlertController.alert(title: "Alert", message: "Unexpected error!")
            }
        }
    }
    @IBAction func btnEmail_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EmailLoginVC") as! EmailLoginVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension RegisterNowVC {
    private func tobeVerify(Otp:Int,tempID:Int){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.comingFrom = "RegisterPhone"
        vc.tempID = "\(tempID)"
        vc.OTP = "\(Otp)"
        vc.countryCode = self.countryCodeTF.text ?? ""
        vc.phone = self.phoneTF.text ?? ""
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func bindVC(){
        viewModel.$signUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    //print(response.data?.token ?? "","token")
                    //  UserDetail.shared.setTokenWith(response.data?.otp )
                    print(response.data?.otp ?? 0,"OTP")
                    print(response.data?.tempID ?? 0,"TempID")
                    print(response.data?.isprofilecomplete ?? false, "is_profile_complete Status")
                    UserDetail.shared.setisCompleteProfile("\(response.data?.isprofilecomplete ?? false)")
                    
                    self.tobeVerify(Otp: response.data?.otp ?? 0, tempID: response.data?.tempID ?? 0)
                })
            }.store(in: &cancellables)
        
        
        viewModelSocial.$socialsignUpResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.userID ?? 0,"userID")
                    print(response.data?.token ?? "","Token social Login at Signup")
                    // print(response.data?.isloginfirst ?? "false","isloginfirst")
                    var logintime = response.data?.isloginfirst ?? false
                    var userid = "\(response.data?.userID ?? 0)"
                    var tokens = "\(response.data?.token ?? "")"
                    UserDetail.shared.setTokenWith(tokens)
                    UserDetail.shared.setUserId(userid)
                    if logintime == true {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC") as? CreateProfileVC
                        self.navigationController?.pushViewController(nextVC!, animated: true) }
                    else {
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MainTabVC") as? MainTabVC
                        self.navigationController?.pushViewController(nextVC!, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
    }
}
extension RegisterNowVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Use the name and phone code directly
        
        let flag = country.code.flagEmoji // Access the flag emoji as String
        let name = country.name
        let code = country.phoneCode
        countryCodeTF.text = "\(flag) (\(code))"
        viewModel.countryCode = self.countryCodeTF.text ?? ""
    }
}
extension RegisterNowVC: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let full_Name = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email!
        print(givenName ,"givenName")
        print(full_Name ,"fullName")
        print(familyName ,"familyName")
        print(userId ,"userId")
        print(idToken ,"idToken")
        let fullName = full_Name
        let nameComponents = fullName?.components(separatedBy: " ")
        
        let firstName = nameComponents?.first ?? ""
        let lastName = nameComponents?.count ?? 0 > 1 ? nameComponents?.last ?? "" : ""
        
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
        
        self.social_ID = userId ?? ""
        
        let emailAddress = email
        UserDetail.shared.setEmailId(emailAddress)
        UserDefaults.standard.synchronize()
        
        let givenName1 = fullName
        
        viewModelSocial.apiforSocialLogin(fName: "\(firstName)", lName: "\(lastName)", Email: emailAddress, socialID: self.social_ID)
        
        
    }
}
