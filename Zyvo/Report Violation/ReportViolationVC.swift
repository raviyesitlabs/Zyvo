//
//  ReportViolationVC.swift
//  Zyvo
//
//  Created by ravi on 2/12/24.
//

import UIKit
import DropDown
import Combine

class ReportViolationVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var txt_Reason: UITextField!
    @IBOutlet weak var btnsubmit: UIButton!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var detailTxtV: UITextView!
    @IBOutlet weak var stackV_Below: UIStackView!
    @IBOutlet weak var view_additionalNotes: UIView!
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var imgDrop: UIImageView!
    private var viewModel = VilolationReasonViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getViolationReason = [VilolationReasonModel]()
    
    var bookingID =  ""
    var propertyID = ""
    
    var ReasonID = ""
    
    var ComingFrom = ""
    var reporter_id = ""
    var reported_user_id = ""
   
    let dropDown = DropDown()
    var backAction : (_ str: String) -> () = {_ in}
    let items = ["Inappropriate Content","Appropriate Content"]
    let placeholderText = "You can also add additional details to help us investigate further."
    
//    let textView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        viewModel.apiforGetVioloationReason()
        detailTxtV.delegate = self
        detailTxtV.text = "You can also add additional details to help us investigate further."
        detailTxtV.textColor = .lightGray
        view_main.layer.cornerRadius = 10
        
        btnsubmit.layer.cornerRadius = btnsubmit.layer.frame.height / 2
       
        view_name.layer.cornerRadius = view_name.layer.frame.height / 2
        view_name.layer.borderWidth = 1
        view_name.layer.borderColor = UIColor.lightGray.cgColor
        
        stackV_Below.layer.cornerRadius = 10
        stackV_Below.layer.borderWidth = 1
        stackV_Below.layer.borderColor = UIColor.lightGray.cgColor
        
        view_additionalNotes.layer.cornerRadius = 10
        view_additionalNotes.layer.borderWidth = 1
        view_additionalNotes.layer.borderColor = UIColor.lightGray.cgColor
        
       
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
        backAction("Cancel")
    }
    
    @IBAction func btnSubmitReport_Tap(_ sender: UIButton) {
        
        if txt_Reason.text == "" {
            self.showToast("Please select reason")
        } else if detailTxtV.text == "You can also add additional details to help us investigate further." || self.detailTxtV.text == "" {
            self.showToast("Please enter additional detail")
        } else if ComingFrom == "checkout" {
            viewModel.apiForSubmitViolationReason(propertyID: self.propertyID, BookingID: self.bookingID, reportReasonsID: self.ReasonID, additionaldetails: self.detailTxtV.text ?? "")
            
        } else if ComingFrom == "MessageChat" {
            viewModel.apiForSubmitChatReport(reporter_id: self.reporter_id, reported_user_id: self.reported_user_id, reason: self.txt_Reason.text ?? "", message: self.detailTxtV.text ?? "")
       
        }
    }
    
    @IBAction func btnSelectReason_Tap(_ sender: UIButton) {
        // Set up the dropdown
        self.imgDrop.image = UIImage(named: "União 106")
        dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dropDown.dataSource = getViolationReason.map { $0.reason ?? "" }//items
        dropDown.direction = .bottom
       
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
            self?.txt_Reason.text =  "\(item)"
            self?.ReasonID = "\(self?.getViolationReason[index].id ?? 0)"
            self?.imgDrop.image = UIImage(named: "dropdownicon")
        }
        dropDown.cancelAction = {
            self.imgDrop.image = UIImage(named: "dropdownicon")
        }
        dropDown.show()
    }

   
    // UITextViewDelegate method - text begins editing
        func textViewDidBeginEditing(_ textView: UITextView) {
            if detailTxtV.text == placeholderText {
                detailTxtV.text = ""
                detailTxtV.textColor = .black
            }
        }
        
        // UITextViewDelegate method - text ends editing
        func textViewDidEndEditing(_ textView: UITextView) {
            if ((detailTxtV.text?.isEmpty) != nil) {
                detailTxtV.text = placeholderText
                detailTxtV.textColor = .lightGray
            }
        }
}
extension ReportViolationVC {
 func bindVC() {
        
        viewModel.$getVilolationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getViolationReason = response.data ?? []
                    
                    print(self.getViolationReason,"getViolationReason ARRAY")
                    
                })
            }.store(in: &cancellables)
     
     
     // Submit Chat Report Result
     viewModel.$getSubmitReportResult
         .receive(on: DispatchQueue.main)
         .sink { [weak self] result in
             guard let self = self else { return }
             result?.handle(success: { response in
                 self.btnsubmit.setTitle("Submitted", for: .normal)
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                     self.dismiss(animated: true) {
                         self.backAction("")
                     }
                 }
             })
         }
         .store(in: &cancellables)
     
     // Submit Chat Report Result
     viewModel.$getSubmitChatReportResult
         .receive(on: DispatchQueue.main)
         .sink { [weak self] result in
             guard let self = self else { return }
             result?.handle(success: { response in
                 self.btnsubmit.setTitle("Submitted", for: .normal)
                 DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                     self.dismiss(animated: true) {
                         self.backAction("ReportSubmitted")
                     }
                 }
             })
         }
         .store(in: &cancellables)

    }
}
