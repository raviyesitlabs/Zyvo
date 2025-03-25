//
//  LogoutPopUpVC.swift
//  Zyvo
//
//  Created by ravi on 10/12/24.
//

import UIKit

class LogoutPopUpVC: UIViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    var backAction: () -> () = {}
    override func viewDidLoad() {
        super.viewDidLoad()

        btnYes.layer.cornerRadius = btnYes.layer.frame.height / 2
        
        
        btnCancel.layer.cornerRadius = btnCancel.layer.frame.height / 2
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.init(red: 74/255, green: 237/255, blue: 177/255, alpha: 1).cgColor
    }
    
    @IBAction func btnYes_Tap(_ sender: UIButton) {
        self.backAction()
        
        UserDetail.shared.removeUserId()
        UserDetail.shared.removeChatToken()
        UserDetail.shared.removeKeepMeLogin()
        UserDetail.shared.removeUserType()
        
        self.dismiss(animated: true)
        
    }
    @IBAction func btnCancel_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
