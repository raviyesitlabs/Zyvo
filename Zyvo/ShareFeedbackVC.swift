//
//  ShareFeedbackVC.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit
import DropDown

class ShareFeedbackVC: UIViewController {
    
    @IBOutlet weak var view_AddDetails1: UIView!
    @IBOutlet weak var view_AddDetails: UIView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var contactUsBtnO: UIButton!
    @IBOutlet weak var view_Select: UIView!
    
    @IBOutlet weak var txt_Type: UITextField!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var btnVGuest: UIView!
    @IBOutlet weak var btnVHost: UIView!
    
    let dropDown = DropDown()
    var Times = ["Guest","Host"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view_AddDetails1.isHidden = true
        view_AddDetails.isHidden = true
        
        view_Details.layer.cornerRadius = 10
        view_Details.layer.borderWidth = 1
        view_Details.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Select.layer.cornerRadius = 10
        view_Select.layer.borderWidth = 1
        view_Select.layer.borderColor = UIColor.lightGray.cgColor
        
        btnContactUs.layer.borderWidth = 1
        btnContactUs.layer.cornerRadius = 22.50
        btnContactUs.layer.borderColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
        
        contactUsBtnO.layer.borderWidth = 1
        contactUsBtnO.layer.cornerRadius = 6
        contactUsBtnO.layer.borderColor = UIColor.darkGray.cgColor
        
        if Panel == "Host"{
            self.btnVGuest.isHidden = true
            self.btnVHost.isHidden = false
            
        }else{
            self.btnVGuest.isHidden = false
            self.btnVHost.isHidden = true
            
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelect_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        dropDown.anchorView = sender //You can set it to a UIButton or any UIView
        dropDown.dataSource = Times
        dropDown.direction = .bottom
        
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_Type.text = "\(item)"
            
            if  self?.txt_Type.text == "Host" || self?.txt_Type.text == "Guest" {
                self?.view_AddDetails1.isHidden = false
                self?.view_AddDetails.isHidden = false
            }
            
        }
        dropDown.show()
        
    }
    
    @IBAction func btnContactUs_Tap(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
//        if Panel == "Host"{
            self.navigationController?.popViewController(animated: true)
//        }
        
    }
    
}
