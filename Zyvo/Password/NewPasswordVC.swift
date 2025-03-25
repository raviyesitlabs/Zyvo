//
//  NewPasswordVC.swift
//  Zyvo
//
//  Created by ravi on 14/10/24.
//

import UIKit
import Combine

class NewPasswordVC: UIViewController {
    
    var comingFrom = ""
    var userID = ""
    
    @IBOutlet weak var imgNewPassword: UIImageView!
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var view_Paasword: UIView!
    @IBOutlet weak var view_newPassword: UIView!
    var backAction : (_ value: String) -> () = {_ in}
    
    private var viewModel = PasswordSetViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.comingFrom,"ComingFrom")
        
        print(self.userID,"userID")
        
        viewModel.userID = self.userID
        
        bindViewModel()
        bindVC()

        view_Paasword.layer.cornerRadius = view_Paasword.layer.frame.height / 2
        view_Paasword.layer.borderWidth = 1
        view_Paasword.layer.borderColor = UIColor.lightGray.cgColor
        
        view_newPassword.layer.cornerRadius = view_newPassword.layer.frame.height / 2
        view_newPassword.layer.borderWidth = 1
        view_newPassword.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    private func bindViewModel() {
        
        passwordTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.newPassword, on: viewModel)
            .store(in: &cancellables)
        
        newPasswordTF.textPublisher
            .compactMap { $0 }
            .assign(to: \.confirmnewPassword, on: viewModel)
            .store(in: &cancellables)
        
    }
    
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        if comingFrom == "EditPass"{
            self.dismiss(animated: true)
            self.backAction("")
        }else{
            
            guard viewModel.isResetPassword else {
                if let error = viewModel.errorMessage {
                    self.showAlert(for: error)
                   // self.showSnackAlert(for: error)
                }
                return
            }
            if passwordTF.text != newPasswordTF.text {
                self.showAlert(for: "New password and confirm password do not match.")
            } else {
                viewModel.apiforCreatePassword()}
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
//            vc.comesFrom = comingFrom
//            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func btnClose_Tap(_ sender: UIButton) {
        if comingFrom == "EditPass"{
            self.dismiss(animated: true)
            self.backAction("Cancel")
        }else{
            self.navigationController?.popToViewController(ofClass: HomeVCWithoutLoginVC.self)
        }
    }

   

}

extension NewPasswordVC {

    func bindVC(){
        viewModel.$ResetPwdResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                  
                    print(response.success ?? false,"Result")
                    if (response.success ?? false) == true {
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as! PasswordChangeVC
                        vc.comesFrom = self.comingFrom
                        self.navigationController?.pushViewController(vc, animated: false)
                       
                    }
                })
            }.store(in: &cancellables)
                               }
}
