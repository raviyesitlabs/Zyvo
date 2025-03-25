//
//  ChatVC.swift
//  WHH
//
//  Created by Satyam  on 05/03/23.
//  Copyright © 2020 satyam. All rights reserved.
//

import UIKit
import DropDown
import ISEmojiView
import TwilioConversationsClient
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManagerSwift
import SDWebImage
import Photos


class ChatVC: UIViewController, UITextViewDelegate {
   
    @IBOutlet weak var txtChat: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_ProfileImg: UIView!
    @IBOutlet weak var view_message: UIView!
   
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    
    @IBOutlet var borderV: [UIView]!
    let keyboardSettings = KeyboardSettings(bottomType: .categories)
    let user_id = UserDetail.shared.getUserId()
    var friend_id = ""
    var friend_identity = ""
    var friend_name = ""
    var friendImg = ""
    var serviceName = ""
    var user_img = ""
    var user_imgV = UIImage()
    var friend_imgV = UIImage()
    var timerToLast : Timer?
    // MARK:twilio
//    var conversationsManager = QuickstartConversationsManager()
    var conversationsManager = QuickstartConversationsManager.shared.self
    var uniqueConversationName = ""
    var messages:Set<TCHMessage> = Set<TCHMessage>()
    var sortedMessages:[TCHMessage] = []
    var lastCell = 1
    
//    var uploadingArray : [(msg:TCHMessageOptions,name:String,img:Data?)] = []
    var uploadingArray : [uploadStruce] = []
    
    var hostProfileImg = ""
    var guesttProfileImg = ""
    
    var hostName = ""
    var guestName = ""
    
   
    // MARK:tableView
    let MyChatCellIdentifier = "ChatCell"
   
    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    private var token :NSKeyValueObservation?
    
    var backAction:(_ str : String ) -> () = { str in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        
        view_ProfileImg.layer.cornerRadius = view_ProfileImg.layer.frame.height / 2
        view_ProfileImg.layer.borderWidth = 3
        view_ProfileImg.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleToFill
        
        view_message.layer.cornerRadius = view_message.layer.frame.height / 2
        view_message.layer.borderWidth = 1
        view_message.layer.borderColor = UIColor.lightGray.cgColor
       // self.tabBarController?.setTabBarHidden(true, animated: true)
        friend_identity = friend_id
        
        print(friend_identity,"friendidentity")
        self.conversationsManager.delegate = self
        self.setupTableview()
        self.keyboardNotifications()
       
        txtChat.delegate = self
        if let token = UserDefaults.standard.object(forKey: "twilioToken") as? String, self.conversationsManager.client == nil {
            self.conversationsManager.loginWithAccessToken(token) { (res) in
                 self.getChat()
                }
        }else{
          self.getChat()
        }
        self.setUp()
        self.loadUserImage()
    }
    
    
    func getChat() {
        self.conversationsManager.loadChat(uniqueConversationName: uniqueConversationName, friendIdentity: friend_identity)

    }
    

    func setUp()  {
      
        var timesCount = 0
        timerToLast = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (tim) in
            if self.sortedMessages.count > 0 {
                let inde = IndexPath(row: 0, section: 0)
                let s = self.tableView.indexPathsForVisibleRows ?? []
                if s.contains(inde) {
//                    self.tableView.reloadRows(at: s, with: .none)
                }
                timesCount = timesCount + 5
                if timesCount >= 20 {
                    
                    timesCount = 0
                }
            }
        })
    }
    
    func loadUserImage(){

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerToLast?.invalidate()
        timerToLast = nil
       
    }
    func setupTableview() {
        let cellNib = UINib(nibName: MyChatCellIdentifier, bundle: nil)
        
        tableView!.register(cellNib, forCellReuseIdentifier:MyChatCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
        tableView.showsVerticalScrollIndicator = false
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.setNavigationBarHidden(true, animated: false)
     
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        showImagePickerOptions()
    }
    
    
    func showImagePickerOptions() {
           let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
           
           let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
               self.openCamera()
           }
           
           let galleryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
               self.openPhotoLibrary()
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           actionSheet.addAction(cameraAction)
           actionSheet.addAction(galleryAction)
           actionSheet.addAction(cancelAction)
           
           present(actionSheet, animated: true, completion: nil)
       }
       
       func openCamera() {
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let picker = UIImagePickerController()
               picker.delegate = self
               picker.sourceType = .camera
               picker.allowsEditing = true
               present(picker, animated: true, completion: nil)
           } else {
               showAlert(for: "Camera not available")
           }
       }
       
       func openPhotoLibrary() {
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = .photoLibrary
           picker.allowsEditing = true
           present(picker, animated: true, completion: nil)
       }
    
    @IBAction func sendMessage(_ sender:UIButton) {
        
            if self.txtChat.text == "" {
                return
            }
            sendMessage(inputMessage: txtChat.text!)
            self.txtChat.text = ""
        
    }
    // MARK: - Chat Service
    
    func sendMessage(inputMessage: String) {
        self.conversationsManager.sendMessage(inputMessage, completion: { (result, _) in
            if result.isSuccessful {
                self.txtChat.inputView = nil
                self.txtChat.keyboardType = .default
                self.txtChat.reloadInputViews()
            } else {
                self.displayErrorMessage("Unable to send message")
            }
        })
    }
    


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    

    @IBAction func btnBack(_ sender: UIButton) {
        
        print("hello I bak ")
  
            // Switch to tab index 1 after popping
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
                self.navigationController?.popViewController(animated: true)
                self.backAction("Ravi")
            }
      
     }
}


extension ChatVC:UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.conversationsManager.conversation?.typing()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "Type a message" && textField.text == ""{
            
           
        }else{
            
          
        }
        print("textFieldDidEndEditing")
    }
    @objc func keyboardWillShow(sender: NSNotification) {
        let i = sender.userInfo!
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
       tbl_bottom_h.constant = k 
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
        self.conversationsManager.conversation?.typing()
      
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        tbl_bottom_h.constant = 24
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
        
    }

    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

extension ChatVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> Int {
        if section == 0 {
            return uploadingArray.count
        }else{
            return sortedMessages.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell:UITableViewCell
            let message = uploadingArray[indexPath.row]
            cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
            return cell
        }
        var cell:UITableViewCell
        let message = sortedMessages[indexPath.row]

        cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)

        if indexPath.row == 0 {
            if let conversation = conversationsManager.conversation,let itt = message.index {
                conversation.setLastReadMessageIndex(itt) { (result, value) in
                }
            }
        }
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        return cell
    }
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: uploadStruce) -> UITableViewCell {
        let ext = message.name.fileExtension()
        return UITableViewCell()
    }
    
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: TCHMessage) -> UITableViewCell {
        if sortedMessages.count > 90 {
            self.loadNewMessage(indexPath: indexPath)
        }
        var ms = message.author ?? ""
        // let date = NSDate.dateWithISO8601String(dateString: message.dateUpdated ?? "")
        print(ms = message.author ?? "","xyz",ms,"Auther",user_id)
        let cell = tableView.dequeueReusableCell(withIdentifier: MyChatCellIdentifier, for:indexPath as IndexPath) as! ChatCell
        if ms == "\(user_id)" {
            cell.img.loadImage(from:self.guesttProfileImg,placeholder: UIImage(named: "user"))
            cell.lbl_name.text = self.guestName
            cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
            return cell
        } else {
            
            cell.img.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
            cell.lbl_name.text = self.hostName
            cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func loadNewMessage(indexPath: IndexPath) {
        if indexPath.row == (sortedMessages.count - 1) && lastCell == 1 && sortedMessages.count > 90 {
            self.lastCell = 2
            let d = UInt(sortedMessages.count)
            self.conversationsManager.conversation?.getMessagesBefore(d, withCount: d + 100, completion: { (result, messages) in
                if let messages = messages, messages.count > 0 {
                    self.addMessages(newMessages: Set(messages),loadToBottom: false)
                    self.lastCell = 1
                    if d != self.messages.count {
                        DispatchQueue.main.async {
                            self.tableView?.reloadData()
                            //                                self.setViewOnHold(onHold: false)
                        }
                    }
                }else{
                    self.lastCell = 3
                }
            })
        }
    }
    
    func addMessages(newMessages:Set<TCHMessage>,loadToBottom:Bool = true) {
        messages =  messages.union(newMessages)
        sortMessages()
        DispatchQueue.main.async {
            self.tableView!.reloadData()
        }
    }
    func sortMessages() {
        sortedMessages = messages.sorted { (a, b) -> Bool in
            (a.dateUpdated ?? "") > (b.dateUpdated ?? "")
        }
    }
}
// MARK: QuickstartConversationsManagerDelegate

extension ChatVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
           
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.setTabBarHidden(false, animated: false)
        dismiss(animated: true, completion: nil)
    }
}

extension ChatVC: TCHConversationDelegate {
    func conversation(_ conversation: TCHConversation, participantJoined participant: TCHParticipant) {
        print("Participant Joined: \(participant.identity ?? "Unknown")")
    }

    func conversation(_ conversation: TCHConversation, participantLeft participant: TCHParticipant) {
        print("Participant Left: \(participant.identity ?? "Unknown")")
    }
}

extension ChatVC: QuickstartConversationsManagerDelegate {
    
    
    func startTyping(participant: TCHParticipant) {
        print("startTyping",participant.identity as Any)
       
    }
    func endTyping(participant: TCHParticipant) {
        print("endTyping",participant.identity as Any)
        
    }
    func getClient(client: TwilioConversationsClient?) {
    }
    func displayStatusMessage(_ statusMessage: String) {
//        self.navigationItem.prompt = statusMessage
//        print("statusMessage",statusMessage)
    }
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func reloadMessages() {
//        sortedMessages = self.conversationsManager.messages
//        sortedMessages.reverse()
        self.loadMessages()
        print("reloadMessages")
//        self.tableView.reloadData()
    }

    func receivedNewMessage(message:TCHMessage) {
        print("receivedNewMessage")
        if !messages.contains(message) {
            addMessages(newMessages: [message])
        }
    }
    func loadMessages() {
        messages.removeAll()
        let items = self.conversationsManager.messages
        self.addMessages(newMessages: Set(items))
    }
}

extension Date {
    func getToRemanning(da:String) -> String {
        if da == "" {
            return ""
        }
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let dateNeweSE = dateFormatte.date(from: da) {
            dateFormatte.timeZone = TimeZone.current
            let s = dateNeweSE.differenceWith(dateNeweSE, inUnit: .day)
            if s == 0 {
                dateFormatte.dateFormat = "h:mm a"
                let valL = dateFormatte.string(from: dateNeweSE)
                return valL
            }else if s == 1 {
                return "Yesterday"
            }else if s >= 1 && s <= 365 {
                dateFormatte.dateFormat = "MMM, dd"
                let valL = dateFormatte.string(from: dateNeweSE)
                return valL
            }else{
                dateFormatte.dateFormat = "MMM/dd/yyyy"
                let valL = dateFormatte.string(from: dateNeweSE)
                return valL
            }
        }
        return ""
    }
}
extension UIViewController {
    func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int){
            let seconds = totalVideoDuration % 60
            let minutes = (totalVideoDuration / 60) % 60
            let hours   = totalVideoDuration / 3600
            return (hours,minutes,seconds)
        }
}


struct uploadStruce {
    var msg : TCHMessage
    var name: String
    var img : Data?
    
}
struct Media{
    var image : UIImage!
    var data : Data!
    var url : String? = ""
    var type : String? = ""
    var id : String? = ""
    var phAsset : PHAsset?
    var URL : URL?
  
    var fileName:String?
    var ext:String?
}
//var uploadFile:UploadFileParameter?
