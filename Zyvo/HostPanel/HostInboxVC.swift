//
//  HostInboxVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import KDCircularProgress
import DropDown

class HostInboxVC: UIViewController {
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    var Arr = ["Mute","Report","Delete chat","Block"]
    
    var dropDown = DropDown()
    var dropDownFilter = DropDown()
    var ArrFilter = ["All Conversations","Archived","Unread"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        tblV.register(UINib(nibName: "msgCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        tblV.delegate = self
        tblV.dataSource = self

    }
    @IBAction func btnFitler_Tap(_ sender: UIButton) {
        
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
}

extension HostInboxVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120// UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! msgCell
        cell.btnMenu.tag = indexPath.row
        cell.btnDetails.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
      //  cell.btnDetails.addTarget(self, action: #selector(buttonDetails(_:)), for: .touchUpInside)
        cell.view_online.isHidden = true
        if indexPath.row == 0 {
            cell.view_online.isHidden = false
        }
             
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostChatVC") as! HostChatVC
        self.tabBarController?.tabBar.isHidden = true
        vc.backAction = {
            self.tabBarController?.tabBar.isHidden = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        print("RAVI")
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
}
