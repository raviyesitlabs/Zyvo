//
//  HostBookingsVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import DropDown
import Combine

class HostBookingsVC: UIViewController {

    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var secrchTF: UITextField!
    
    var arrTitle = ["Katelyn Francy","Mike Jm.","Mia Williams","Emily James","Michael Kenny"]
    let filterDropdown = DropDown()
    var filtersArr = ["All Bookings","Finished","Booking Requests","Confirmed","Waiting payment","Cancelled"]
    private var viewModel = BookingListViewModel()
    var bookingsDataArr = [BookingListDataModel]()
    var S_bookingsDataArr = [BookingListDataModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
        
       
        
        viewSearch.applyRoundedStyle()
        tblV.register(UINib(nibName: "HostBookingCell", bundle: nil), forCellReuseIdentifier: "HostBookingCell")
        tblV.delegate = self
        tblV.dataSource = self
        secrchTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
  

    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.apiforGetBookingsList()
        viewModel.apiforReadBookingCount()
       
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.secrchTF.text?.isEmpty ?? true {
            self.bookingsDataArr = self.S_bookingsDataArr
        } else {
            self.bookingsDataArr = self.S_bookingsDataArr.filter {
                $0.guestName?.lowercased().contains(self.secrchTF.text?.lowercased() ?? "") ?? false
            }
        }
        self.tblV.reloadData() // Reload table view to reflect changes
    }
    
    @IBAction func btnfilter_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        filterDropdown.anchorView = sender // Anchor dropdown to the button
        filterDropdown.dataSource = filtersArr
        filterDropdown.direction = .bottom
        
        filterDropdown.backgroundColor = UIColor.white
        filterDropdown.cornerRadius = 10
        filterDropdown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        filterDropdown.layer.shadowColor = UIColor.gray.cgColor
        filterDropdown.layer.shadowOpacity = 0.2
        filterDropdown.layer.shadowRadius = 10
        filterDropdown.layer.shadowOffset = CGSize(width: 0, height: 2)
        if let anchorHeight = filterDropdown.anchorView?.plainView.bounds.height {
            filterDropdown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        filterDropdown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        // Handle selection
        filterDropdown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected month: \(item)")
//            if index == 0{
//                self.bookingsDataArr = self.bookingsDataArr
//            }else if index == 1{
//                self.bookingsDataArr = self.bookingsDataArr.filter { $0.bookingStatus == "finished" }
//            }else if index == 2{
//                self.bookingsDataArr = self.bookingsDataArr.filter { $0.bookingStatus == "pending" }
//            }else if index == 3{
//                self.bookingsDataArr = self.bookingsDataArr.filter { $0.bookingStatus == "confirmed" }
//            }else if index == 3{
//                self.bookingsDataArr = self.bookingsDataArr.filter { $0.bookingStatus == "" }
//            }else if index == 3{
//                self.bookingsDataArr = self.bookingsDataArr.filter { $0.bookingStatus == "cancelled" }
//            }
            
            // Perform any further actions as needed
        }
        // Show dropdown
        filterDropdown.show()
    }
}

extension HostBookingsVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingsDataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "HostBookingCell", for: indexPath) as! HostBookingCell
        let imgURL = AppURL.imageURL + (bookingsDataArr[indexPath.row].guestAvatar ?? "")
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
        
        cell.lbl_name.text = bookingsDataArr[indexPath.row].guestName
        cell.lbl_Date.text = bookingsDataArr[indexPath.row].bookingDate
        cell.btn2.isHidden = true
        cell.lbl_Date.isHidden = false
        
        if bookingsDataArr[indexPath.row].bookingStatus == "pending"{
            cell.btn2.setTitleColor(UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1), for: .normal)
            cell.btn1.setTitle("Approve", for: .normal)
            cell.btn1.backgroundColor = UIColor.clear
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = true
            cell.btn2.isHidden = false
            cell.btn2.setTitle("Decline", for: .normal)
            cell.btn2.backgroundColor = UIColor.clear
            cell.btn2.layer.borderWidth = 1
            cell.btn2.layer.borderColor = UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1).cgColor
            cell.btn2.setTitleColor(UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1), for: .normal)
            cell.lbl_Date.isHidden = true
        }else if bookingsDataArr[indexPath.row].bookingStatus == "cancelled"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Cancelled", for: .normal)
            cell.btn1.backgroundColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10)
            cell.btn1.layer.borderWidth = 1
            cell.btn1Width.constant = 100
           
            cell.btn1.layer.borderColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10).cgColor
            cell.lbl_Date.isHidden = false
        }else if bookingsDataArr[indexPath.row].bookingStatus == "confirmed"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Confirmed", for: .normal)
            cell.btn1.backgroundColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1)
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = false
        }else if bookingsDataArr[indexPath.row].bookingStatus == "awaiting_payment"{
            cell.btn2.isHidden = true
            cell.btn1.setTitle("Awaiting payment", for: .normal)
            cell.btn1.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
            cell.btn1Width.constant = 160
            cell.btn1.layer.borderWidth = 1
            cell.btn1.layer.borderColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1).cgColor
            cell.lbl_Date.isHidden = false
        }else{
            cell.lbl_Date.isHidden = false
        }
//        if indexPath.row == 1 {
//            cell.btn2.setTitleColor(UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1), for: .normal)
//            cell.btn1.setTitle("Approve", for: .normal)
//            cell.btn1.backgroundColor = UIColor.clear
//            cell.btn1.layer.borderWidth = 1
//            cell.btn1.layer.borderColor = UIColor(red: 0/255, green: 191/255, blue: 123/255, alpha: 1).cgColor
//            cell.lbl_Date.isHidden = true
//            cell.btn2.isHidden = false
//            cell.btn2.setTitle("Decline", for: .normal)
//            cell.btn2.backgroundColor = UIColor.clear
//            cell.btn2.layer.borderWidth = 1
//            cell.btn2.layer.borderColor = UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1).cgColor
//            cell.btn2.setTitleColor(UIColor(red: 255/255, green: 26/255, blue: 0/255, alpha: 1), for: .normal)
//            cell.lbl_Date.isHidden = true
//        }
//        
//        if indexPath.row == 2 {
//            cell.btn2.isHidden = true
//            cell.btn1.setTitle("Confirmed", for: .normal)
//            cell.btn1.backgroundColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1)
//            cell.btn1.layer.borderWidth = 1
//            cell.btn1.layer.borderColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1).cgColor
//            cell.lbl_Date.isHidden = false
//            
//        }
//        
//        if indexPath.row == 3 {
//            cell.btn2.isHidden = true
//            cell.btn1.setTitle("Awaiting payment", for: .normal)
//            cell.btn1.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
//            cell.btn1Width.constant = 160
//            cell.btn1.layer.borderWidth = 1
//            cell.btn1.layer.borderColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1).cgColor
//            cell.lbl_Date.isHidden = false
//            
//        }
//        
//        if indexPath.row == 4 {
//            cell.btn2.isHidden = true
//            cell.btn1.setTitle("Cancelled", for: .normal)
//            cell.btn1.backgroundColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10)
//            cell.btn1.layer.borderWidth = 1
//            cell.btn1Width.constant = 100
//           
//            cell.btn1.layer.borderColor = UIColor(red:58/255, green: 75/255, blue: 76/255, alpha: 0.10).cgColor
//            cell.lbl_Date.isHidden = false
//        }
        cell.btn1.tag = indexPath.row
        cell.btn2.tag = indexPath.row
        cell.btn1.addTarget(self, action: #selector(buttonTapped1(_:)), for: .touchUpInside)
        cell.btn2.addTarget(self, action: #selector(buttonTapped2(_:)), for: .touchUpInside)
        //cell.lbl_title.text = arrTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostBookingAVC") as! HostBookingAVC
        vc.bookingId = bookingsDataArr[indexPath.row].bookingID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func buttonTapped1(_ sender: UIButton) {
      
        print(sender.tag)
        
        // Retrieve the button title
            if let buttonTitle = sender.title(for: .normal) {
                if buttonTitle == "Finished" {
                    print("Button title is Finished")
                } else if  buttonTitle == "Approve" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostApproveRequestVC") as! HostApproveRequestVC
                    vc.bookingId = "\(bookingsDataArr[sender.tag].bookingID ?? 0)"
                    self.present(vc, animated: true)
                    print("Button title is Approve")
                } else if  buttonTitle == "Confirmed" {
                    print("Button title is Confirmed")
                }  else if  buttonTitle == "Awaiting payment" {
                    print("Button title is Awaiting payment")
                } else if buttonTitle == "Cancelled" {
                    print("Button title is Cancelled")
                }
            } else {
                print("Button has no title")
            }
      
    }
    
    @objc func buttonTapped2(_ sender: UIButton) {
        print(sender.tag)
        if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Decline" {
                print("Button title is Decline")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostDeclineRequestVC") as! HostDeclineRequestVC
                vc.bookingId = "\(bookingsDataArr[sender.tag].bookingID ?? 0)"
                self.present(vc, animated: true)
            }
        }
    }
}
extension HostBookingsVC {
    func bindVC() {
        viewModel.$getBookingsListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.bookingsDataArr.removeAll()
                    self.bookingsDataArr = response.data ?? []
                    self.S_bookingsDataArr = self.bookingsDataArr
                    print(self.bookingsDataArr,"Booking DATA YAHI HAI")
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        
        viewModel.$readBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    NotificationCenter.default.post(name: NSNotification.Name("UpdateBookingBadge"), object: nil, userInfo: ["unread_booking_count": 0])
                    
                })
            }.store(in: &cancellables)
    }
}
