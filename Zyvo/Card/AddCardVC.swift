//
//  AddCardVC.swift
//  Zyvo
//
//  Created by ravi on 28/11/24.
//

import UIKit
import Stripe
import DropDown
import Combine

class AddCardVC: UIViewController {
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var view_Street: UIView!
    @IBOutlet weak var view_City: UIView!
    @IBOutlet weak var view_State: UIView!
    @IBOutlet weak var view_Zipcode: UIView!
    @IBOutlet weak var view_year: UIView!
    @IBOutlet weak var view_month: UIView!
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_card: UIView!
    
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var expDateTF: UITextField!
    @IBOutlet weak var lbl_year: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
    @IBOutlet weak var txt_street: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_zipcode: UITextField!
    @IBOutlet weak var txt_card: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    var iconChecked = false
    
    let arrMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    
    let currentYear = Calendar.current.component(.year, from: Date())
   
    let monthDropdown = DropDown()
    
    let yearDropdown = DropDown()
    
    private var viewModel = MailingAddressViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getSavedAddress : MailingAddressModel?
    
    var backAction: () -> () = {}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        self.txt_name.delegate = self
        self.txt_card.delegate = self
        self.expDateTF.delegate = self
        self.cvvTF.delegate = self
        
//        if let poppinsFontlbl = UIFont(name: "Poppins-Regular", size: 14) {
//            lbl_month.setCustomFontAndText(
//                text: "Month",
//                font: poppinsFontlbl,
//                textColor: .black)
//            lbl_year.setCustomFontAndText(
//                text: "Year",
//                font: poppinsFontlbl,
//                textColor: .black)
//        }
        
    if let poppinsFont = UIFont(name: "Poppins-Regular", size: 14) {
        txt_name.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Name",placeholderColor: .black)
        txt_card.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Card Number",placeholderColor: .black)
        txt_street.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Street",placeholderColor: .black)
        expDateTF.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Month/Year",placeholderColor: .black)
        cvvTF.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "CVV",placeholderColor: .black)
        
        txt_city.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "City",placeholderColor: .black)
        txt_state.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "State",placeholderColor: .black)
        txt_zipcode.setCustomFontAndPlaceholder(textFont: poppinsFont, placeholderText: "Zipcode",placeholderColor: .black)
        
        }

        
        btnSubmit.layer.cornerRadius = btnSubmit.layer.frame.height / 2
        
        view_Zipcode.layer.cornerRadius = view_Zipcode.layer.frame.height / 2
        view_Zipcode.layer.borderWidth = 1.5
        view_Zipcode.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_State.layer.cornerRadius = view_State.layer.frame.height / 2
        view_State.layer.borderWidth = 1.5
        view_State.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_City.layer.cornerRadius = view_City.layer.frame.height / 2
        view_City.layer.borderWidth = 1.5
        view_City.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_Street.layer.cornerRadius = view_Street.layer.frame.height / 2
        view_Street.layer.borderWidth = 1.5
        view_Street.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_year.layer.cornerRadius = view_year.layer.frame.height / 2
        view_year.layer.borderWidth = 1.5
        view_year.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_month.layer.cornerRadius = view_month.layer.frame.height / 2
        view_month.layer.borderWidth = 1.5
        view_month.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_name.layer.cornerRadius = view_name.layer.frame.height / 2
        view_name.layer.borderWidth = 1.5
        view_name.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        
        view_card.layer.cornerRadius = view_card.layer.frame.height / 2
        view_card.layer.borderWidth = 1.5
        view_card.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_name {
            textField.resignFirstResponder()
            txt_card.becomeFirstResponder()
        } else if textField == txt_card {
            textField.resignFirstResponder()
            expDateTF.becomeFirstResponder()
        }else if textField == expDateTF {
            textField.resignFirstResponder()
            cvvTF.becomeFirstResponder()
        }else if textField == cvvTF {
            textField.resignFirstResponder()
        }
       // callFunc()
        return true
    }
    
   
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func btnSubmit_Tap(_ sender: UIButton) {
        
        if txt_name.text == "" {
            self.popupAlert(title: "", message: "Please enter Card Holder Name!", actionTitles: ["Okay!"], actions:[{action1 in}])
           /// return false
        }
        else if txt_card.text?.count == 0 || txt_card.text?.count == 16 {
       
            self.popupAlert(title: "", message: "Please enter currect Card Number!", actionTitles: ["Okay!"], actions:[{action1 in}])
            //return false
        } else if expDateTF.text?.count == 0 || expDateTF.text?.count != 5{
            self.popupAlert(title: "", message: "Please enter Currect expiry number!", actionTitles: ["Okay!"], actions:[{action1 in}])
            //return false
        } else if cvvTF.text?.count != 3 {
            self.popupAlert(title: "", message: "Please enter CVV Code", actionTitles: ["Okay!"], actions:[{action1 in}])
           // return false
        } else if txt_street.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter street", actionTitles: ["Okay!"], actions:[{action1 in}])
           // return false
        } else if txt_city.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter city", actionTitles: ["Okay!"], actions:[{action1 in}])
           // return false
        } else if txt_state.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter state", actionTitles: ["Okay!"], actions:[{action1 in}])
           // return false
        }else if txt_zipcode.text?.count == 0 {
            self.popupAlert(title: "", message: "Please enter zip", actionTitles: ["Okay!"], actions:[{action1 in}])
           // return false
        } else {
            callFunc()
        }
//        self.dismiss(animated: true)
//        self.backAction()
    }
    
    @IBAction func btnCheck_Tap(_ sender: UIButton) {
        if iconChecked == false {
            iconChecked = true
            viewModel.apiForGetSavedAddress()
            btnCheck.setImage(UIImage(named: "btnchecked"), for: .normal)
        } else {
            iconChecked = false
            btnCheck.setImage(UIImage(named: "uncheckedicon"), for: .normal)
        }
    }
    
    
    func callFunc() {
       // self.addCardBtn.isUserInteractionEnabled = false
        let cardParams = STPCardParams()
//         cardParams.number = "4242424242424242"
//         cardParams.expMonth = 10
//         cardParams.expYear = 2026
//         cardParams.cvc = "123"
       
        let fullName = expDateTF.text!
        let fullNameArr = fullName.components(separatedBy: "/")
        cardParams.name = txt_name.text
        cardParams.number = txt_card.text
        cardParams.expMonth = UInt(fullNameArr[0])!
        cardParams.expYear = UInt(fullNameArr[1])!
        cardParams.cvc = cvvTF.text
        cardParams.addressZip = self.txt_zipcode.text
        cardParams.addressCity = self.txt_state.text
        cardParams.addressState = self.txt_state.text
        cardParams.addressLine1 = self.txt_street.text
        

        print(cardParams,"cardParams")
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token111 = token, error == nil else {
                // Present error to user...
                let UserInfo = error.unsafelyUnwrapped.localizedDescription
                self.showAlert(for: UserInfo)
               // self.addCardBtn.isUserInteractionEnabled = true
                
                return
            }
          //  self.TokenId = token111.tokenId as Any as? String
            print(token111.tokenId as Any,"token id")
            //self.callAddCardApi()
            
            self.viewModel.apiForAddCard(tokenStripe: "\(token111.tokenId as Any)")
            
//            self.PaymentApi(cardExpMonth: fullNameArr[0], cardExpYear: fullNameArr[1], stripeToken: token111.tokenId)
            
        }
    }
}

extension UITextField {
    func setCustomFontAndPlaceholder(
        textFont: UIFont,
        placeholderText: String,
        placeholderColor: UIColor
    ) {
        self.font = textFont
        self.textColor = .black // Optional
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: textFont
            ]
        )
    }
}

extension UILabel {
    func setCustomFontAndText(text: String, font: UIFont, textColor: UIColor) {
        self.font = font
        self.text = text
        self.textColor = textColor
    }
}

extension AddCardVC {
 func bindVC() {
        viewModel.$getSavedAddress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getSavedAddress = response.data
                    
                    print(self.getSavedAddress ?? "","Saved Address")
                    
                    print(self.getSavedAddress?.streetAddress ?? "")
                    print(self.getSavedAddress?.city ?? "")
                    print(self.getSavedAddress?.state ?? "")
                    print(self.getSavedAddress?.zipCode ?? "")
                    
                    self.txt_street.text = self.getSavedAddress?.streetAddress ?? ""
                    self.txt_city.text = self.getSavedAddress?.city ?? ""
                    self.txt_state.text = self.getSavedAddress?.state ?? ""
                    self.txt_zipcode.text = self.getSavedAddress?.zipCode ?? ""
                    
                })
            }.store(in: &cancellables)
  
     
     //Add CARD
     viewModel.$addCardResult
         .receive(on: DispatchQueue.main)
         .sink { [weak self] result in
             guard let self = self else{return}
             result?.handle(success: { response in
                 print(response.message ?? "")
                 self.dismiss(animated: true)
             })
         }.store(in: &cancellables)
     
   

    }
}




extension AddCardVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txt_card {
            if range.location == 19 {
                return false
            }
            
            if string.count == 0 {
                return true
            }
            if !self.pavan_checkNumberOrAlphabet(Str: string) || string == " " {
                return false
            }
            if (range.location == 4) || (range.location == 9) || (range.location == 14) {
                                let str = "\(textField.text!) "
                                textField.text = str
            }
            return true
        }
        if textField == cvvTF {
            if range.location == 3 {
                return false
            }
            
            if string.count == 0 {
                return true
            }
            
            
            if !self.pavan_checkNumberOrAlphabet(Str: string) || string == " " {
                return false
            }
            
            
            return true
        }
        if textField == expDateTF {
            if range.location == 5 {
                return false
            }
            
            if string.count == 0 {
                
                return true
            }
            if string == " " {
                return false
            }
            
            if !self.pavan_checkNumberOrAlphabet(Str: string) {
                return false
            }
            if (range.location == 2) {
                let str = "\(textField.text!)/"
                textField.text = str
            }
            return true
        }
        if textField == txt_name {
            
            if string.count == 0 {
                return true
            }
            if string == " " {
                return true
            }
            if !self.pavan_checkAlphabet(Str: string) {
                return false
            }
            return true
        }
       // callFunc()
        return true
      }
     }
