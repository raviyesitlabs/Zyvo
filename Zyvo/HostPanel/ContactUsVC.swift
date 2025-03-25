//
//  ContactUsVC.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 16/01/25.
//

import UIKit

class ContactUsVC: UIViewController {

    @IBOutlet weak var detailBgView: UIView!
    @IBOutlet weak var msgTxtVBgV: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailBgView.layer.cornerRadius = 8
        detailBgView.layer.borderWidth = 1
        detailBgView.layer.borderColor = UIColor.lightGray.cgColor
        
        msgTxtVBgV.layer.cornerRadius = 8
        msgTxtVBgV.layer.borderWidth = 1
        msgTxtVBgV.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    

    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}
