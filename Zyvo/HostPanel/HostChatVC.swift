//
//  HostChatVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown

class HostChatVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var msgTxtV: UITextView!
    
    var arrImg = ["woman-s-face-38289 7","Michael Kenny","woman-s-face-38289 7","Michael Kenny"]
    var arrName = ["Mia","Katelyn","Mia","Katelyn"]
    var ArrMsg = ["Hi welcome to our house!","Hi thank you","Hi welcome to our house!","Hi thank you"]
    var dropDown = DropDown()
    var Arr = ["Mute","Report","Delete chat","Block"]
    var dropDownFilter = DropDown()
    var ArrFilter = ["All Conversations","Archived","Unread"]
    var backAction: () -> () = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        msgTxtV.delegate = self
        msgTxtV.textColor = .lightGray
        
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
       
        
        img.layer.cornerRadius = img.layer.frame.height / 2
      
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 4
        view_Photo.layer.borderColor = UIColor.init(red: 234/255, green: 239/255, blue: 244/255, alpha: 0.9).cgColor

    }
    
    @IBAction func btnDot_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        dropDown.anchorView = sender // Anchor dropdown to the button
        dropDown.dataSource = Arr
        dropDown.direction = .bottom
       
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.layer.masksToBounds = false // Set this to false to allow shadow

        // Shadow properties
        dropDown.layer.shadowColor = UIColor.gray.cgColor
        dropDown.layer.shadowOpacity = 0.2
        dropDown.layer.shadowRadius = 10
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 2)

        
        if let anchorHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        // Customize cells
        dropDown.customCellConfiguration = { (index, item, cell) in
                   cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
                   cell.optionLabel.textColor = UIColor.black // Optional: Set text color
               }
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            // Perform any further actions as needed
        }
        
        // Show dropdown
        dropDown.show()
    }
    @IBAction func btnStar_Tap(_ sender: UIButton) {
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.backAction()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilter_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        dropDownFilter.anchorView = sender // Anchor dropdown to the button
        dropDownFilter.dataSource = ArrFilter
        dropDownFilter.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDownFilter.cornerRadius = 10
        dropDownFilter.layer.masksToBounds = false // Set this to false to allow shadow

        // Shadow properties
        dropDownFilter.layer.shadowColor = UIColor.gray.cgColor
        dropDownFilter.layer.shadowOpacity = 0.2
        dropDownFilter.layer.shadowRadius = 10
        dropDownFilter.layer.shadowOffset = CGSize(width: 0, height: 2)

        
        if let anchorHeight = dropDownFilter.anchorView?.plainView.bounds.height {
            dropDownFilter.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        // Customize cells
        dropDownFilter.customCellConfiguration = { (index, item, cell) in
                   cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
                   cell.optionLabel.textColor = UIColor.black // Optional: Set text color
               }
        
        // Handle selection
        dropDownFilter.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
            // Perform any further actions as needed
        }
        
        // Show dropdown
        dropDownFilter.show()

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxtV.text == "Type a message..."{
            msgTxtV.text = ""
            msgTxtV.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxtV.text == ""{
            msgTxtV.text = "Type a message..."
            msgTxtV.textColor = .lightGray
        }
    }
    
}

extension HostChatVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.lbl_name.text = arrName[indexPath.row]
        cell.img.image = UIImage(named: arrImg[indexPath.row])
        cell.lbl_msg.text = ArrMsg[indexPath.row]
        return cell
    }
    
    
}
