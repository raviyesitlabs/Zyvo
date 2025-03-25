//
//  PrivacyPolicyVC.swift
//  Zyvo
//
//  Created by ravi on 13/11/24.
//

import UIKit
import Combine

class PrivacyPolicyVC: UIViewController {
    
    private var viewModel = PrivacyPolicyViewModel()
    private var viewModel2 = TermCondtionViewModel()
    private var cancellables = Set<AnyCancellable>()
    var PrivacyData : PrivacyPolicyModel?
    var TermConditionData : TermConditionModel?
    var comingFrom = ""
    
    @IBOutlet weak var lbl_PrivacyContent: UILabel!
    @IBOutlet weak var view_Search: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if comingFrom == "Privacy" {
            viewModel.apiforPrivacyPolicy() }
        
        if comingFrom == "TermCondition" {
            viewModel2.apiforTermCondition() }
        
//        view_Search.layer.borderWidth = 1.0
//        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
//        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2

       
    }
    

    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension PrivacyPolicyVC {
 func bindVC() {
        
        viewModel.$getPrivacyPolicyResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.PrivacyData = response.data
                    
                    self.lbl_PrivacyContent.text = self.PrivacyData?.text ?? ""
                    
                })
            }.store(in: &cancellables)
     
     
     viewModel2.$getTermConditionResult
         .receive(on: DispatchQueue.main)
         .sink { [weak self] result in
             guard let self = self else{return}
             result?.handle(success: { response in
                 
                 self.TermConditionData = response.data
                 
                 self.lbl_PrivacyContent.text = self.TermConditionData?.text ?? ""
                 
             })
         }.store(in: &cancellables)
    }
}
