//
//  EmailRegisterVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine

class EmailRegisterVC:UIViewController {
    
    @IBOutlet weak var view_Password: UIView!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var KeepMeLogin = "No"
    
    private var viewModel = EmailRegisterViewModel()
   
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        bindVC()
        
        view_email.layer.cornerRadius = view_email.layer.frame.height / 2
        view_email.layer.borderWidth = 1
        view_email.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Password.layer.cornerRadius = view_Password.layer.frame.height / 2
        view_Password.layer.borderWidth = 1
        view_Password.layer.borderColor = UIColor.lightGray.cgColor

    }
    
    private func bindViewModel() {
       
        emailTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        passwordTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.Password, on: viewModel)
            .store(in: &cancellables)
        
    }
    
    @IBAction func btnCheck(_ sender: UIButton) {
        if KeepMeLogin == "No"{
            self.KeepMeLogin = "Yes"
            self.btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
        }else{
            self.KeepMeLogin = "No"
            self.btnCheck.setImage(UIImage(named: "uncheckedicon"), for: .normal)
            UserDetail.shared.setKeepMeLogin(self.KeepMeLogin)
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnclose(_ sender: UIButton) {
        self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
    }
    
    @IBAction func btnCreateAccount(_ sender: UIButton) {
        
        guard viewModel.isSignUpValid else {
            if let error = viewModel.errorMessage {
                self.showAlert(for: error)
                // self.showSnackAlert(for: error)
            }
            return
        }
        viewModel.signUpEmailApi()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
//        vc.comingFrom = "RegisterEmail"
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension EmailRegisterVC {
    private func tobeVerify(tempid:Int,OTP:Int){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationVC") as! VerificationVC
        vc.comingFrom = "RegisterEmail"
        vc.tempID = "\(tempid)"
        vc.OTP = "\(OTP)"
        vc.email = self.emailTF.text ?? ""
        vc.password = self.passwordTF.text ?? ""
        self.navigationController?.pushViewController(vc, animated: false)
 
    }
    func bindVC(){
        
        viewModel.$emailSignupResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                   // let to = response.data?.token
                    print(response.data?.tempID ?? 0,"tempID")
                    print(response.data?.otp ?? 0,"otp")
                    self.tobeVerify(tempid: response.data?.tempID ?? 0, OTP: response.data?.otp ?? 0 )

                })
            }.store(in: &cancellables)
        
        
//        
//        viewModel.$socialsignUpResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                   // let to = response.data?.token
//                    print(response.data?.userID ?? 0,"userID")
//                    print(response.data?.token ?? "","Token social Login at Signup")
//                    print(response.data?.isloginfirst ?? "false","isloginfirst")
//                    
//                    var logintime = response.data?.isloginfirst ?? ""
//                    var userid = "\(response.data?.userID ?? 0)"
//                    var tokens = "\(response.data?.token ?? "")"
//                    UserDetail.shared.setTokenWith(tokens)
//                    UserDetail.shared.setUserId(userid)
//                    if logintime == "yes" {
//                        
//                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "TurnOnNotification") as? TurnOnNotification
//                        self.navigationController?.pushViewController(nextVC!, animated: true)
//                    }
//                    
//                    if logintime == "no" {
//                        let nextVC = UIStoryboard(name: "Home", bundle: nil)
//                        let nextVc = nextVC.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
//                        self.navigationController?.pushViewController(nextVc, animated: true)
//                    }
//                    
//                    
//                })
//            }.store(in: &cancellables)
                               }
    
}
//extension SignUpVC: GIDSignInDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
//        // Perform any operations on signed in user here.
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email!
//        print(userId ?? "" ,"useridGmail")
//        print(fullName ?? "" ,"fullName")
//        print(email ,"email")
//        
//        viewModel.apiforSocialLogin(name: fullName ?? "", Email: email, socialID: userId ?? "")
//        let delegate = AppDelegate.shared
//        let token = delegate.deviceToken
//      
//        //  }
//        
//    }
//}




