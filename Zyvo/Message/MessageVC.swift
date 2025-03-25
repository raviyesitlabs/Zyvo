//
//  MessageVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import KDCircularProgress
import DropDown
import Combine
import TwilioConversationsClient
import IQKeyboardManagerSwift

class MessageVC:UIViewController {
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    var Arr = ["Mute","Report","Delete chat","Block"]
    
    private var totalUnreadCount = 0
    
    var dropDown = DropDown()
    var dropDownFilter = DropDown()
    var ArrFilter = ["All Conversations","Archived","Unread"]
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    // var chatDataArr : [ChatDataModel]?
    
    private let debouncer = Debouncer()
    private var chatDataArr: [ChatDataModel] = []
    private var MainchatDataArr: [ChatDataModel] = []
    
    private var conversationsManager = QuickstartConversationsManager.shared.self
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        setupTableView()
        setupUI()
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        conversationsManager.myMsg = { msg in
            print(msg?.body ?? "","twillio msg from closer")
            
        }
        
    }
    
    private func setupTableView() {
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "msgCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        
        
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
            print("Login with Access Token")
            self.viewModel.apiForGetChatData(userType: "guest")
        }
        
        //        else{
                 self.conversationsManager.delegate = self
        //
        //                let token = UserDetail.shared.getChatToken()
        //                QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
        //                    print("Login with Access Token")
        //                    self.viewModel.apiForGetChatData(userType: "guest")
        //                }
        //
        //        }
        
        //refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        //tblV.refreshControl = refreshControl
    }
    
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        conversationsManager.delegate = self
        
    }
    
    @objc private func pullToRefresh() {
        
        APIManager.shared.apiforGetChatToken(role: "guest") { t in
            let token = UserDetail.shared.getChatToken()
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
                print("Login with Access Token")
                self.viewModel.apiForGetChatData(userType: "guest")
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        conversationsManager.delegate = self
        IQKeyboardManager.shared.enable = true
        if let token = UserDefaults.standard.object(forKey: "twilioToken") as? String, self.conversationsManager.client == nil {
            print("I am here")
            self.conversationsManager.loginWithAccessToken(token) { (res) in
                self.reloadAllData()
                }
        }else{
            
            print("I am not here")
       
        }

//        let token = UserDetail.shared.getChatToken()
//        QuickstartConversationsManager.shared.loginWithAccessToken(token) { (res) in
//            print("Login with Access Token")
//            self.viewModel.apiForGetChatData(userType: "guest")
//        }
        
        
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
    
    
    private func fetchUnreadMessageCounts() {
        var totalUnreadCount = 0
        let group = DispatchGroup()
        
        for data in chatDataArr {
            if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
                group.enter()
                conversation.getUnreadMessagesCount { (result, unreadCount) in
                    if let unread = unreadCount as? Int {
                        totalUnreadCount += unread
                        print("Unread count for Main Tab \(uniqueName): \(unread)")
                        
                        group.notify(queue: .main) {
                            self.totalUnreadCount = totalUnreadCount
                            print("Total Unread Messages for message VC : \(self.totalUnreadCount)")
                            if let tabBarVC = self.tabBarController as? MainTabVC {
                                tabBarVC.updateBadgeCount(totalUnreadCount)
                            }
                        }
                        
                    } else {
                        print("Failed to fetch unread count for \(uniqueName)")
                    }
                    group.leave()
                }
            }
        }
        
    }
}

extension MessageVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120// UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDataArr.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as! msgCell
        let data = chatDataArr[indexPath.row]
        
        cell.userName.text = data.receiverName ?? ""
        
        var image = data.receiverImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.userImg.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
        
        cell.btnMenu.tag = indexPath.row
        cell.btnDetails.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btnDetails.addTarget(self, action: #selector(buttonDetails(_:)), for: .touchUpInside)
        cell.view_online.isHidden = true
        if indexPath.row == 0 {
            cell.view_online.isHidden = false
        }
        cell.lbl_time.text = ""
        cell.lbl_message.text = ""
        if let uniqueName = data.groupName, let conversation = data.chatData, uniqueName == conversation.uniqueName {
            if let lastMessageIndex = conversation.lastMessageIndex {
                conversation.message(withIndex: lastMessageIndex) { (result, message) in
                    DispatchQueue.main.async {
                        if let messageBody = message {
                            cell.lbl_message.text = messageBody.body
                            if let dateUpdated = messageBody.dateUpdated {
                                cell.lbl_time.text = self.updateLastMsgTime(dateUpdated)
                            }
                        }
                    }
                }
            }
            
            conversation.getUnreadMessagesCount { (res, unreadCount) in
                DispatchQueue.main.async {
                    if let unread = unreadCount as? Int, unread > 0 {
                        print("\(unread) COUNT USERWISE MESSAGE UNREAD")
                    }
                }
            }
        }
        return cell
 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = chatDataArr[indexPath.row]
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
            vc.uniqueConversationName = data.groupName ?? ""
            vc.friend_id = data.receiverID ?? ""

            let hostImage = data.receiverImage ?? ""
            let guestImage = data.senderProfile ?? ""
            vc.hostProfileImg = AppURL.imageURL + hostImage
            vc.guesttProfileImg = AppURL.imageURL + guestImage
            vc.hostName = data.receiverName ?? ""
            vc.guestName = data.senderName ?? ""

            self.tabBarController?.tabBar.isHidden = true
            vc.hidesBottomBarWhenPushed = true

            if let uniqueName = data.groupName,
               let conversation = data.chatData,
               uniqueName == conversation.uniqueName {

                conversation.getUnreadMessagesCount { (result, unreadCount) in
                    DispatchQueue.main.async {
                        if let unread  = unreadCount {
                            print("Unread count for \(uniqueName): \(unread)")
                            
                            var remainingCount = self.totalUnreadCount  - Int(truncating: unread)
                            
                            self.totalUnreadCount = remainingCount
                                
                                print("Total Unread Messages DidSelect : \(remainingCount)")
                                if let tabBarVC = self.tabBarController as? MainTabVC {
                                    tabBarVC.updateBadgeCount(remainingCount)
                                }
                            
                        } else {
                            print("Unread count is nil for \(uniqueName)")
                        }
                    }
                }
            } else {
                print("Conversation not found for \(data.groupName ?? "Unknown")")
            }

            vc.backAction = { str in
                print("\(str) Data Received")
                self.tabBarController?.tabBar.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


    
    @objc func buttonDetails(_ sender: UIButton) {
        let d = sender.tag
        print(d,"Index")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingDetailsVC") as! ListingDetailsVC
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

extension MessageVC {
    
    func updateLastMsgTime(_ time: String) -> String {
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let theFirstDate = Date()
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: theSecondDate, to: theFirstDate)
            
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            } else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            } else
            
            if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            } else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            } else if let theNumbe = theComponents.minute, theNumbe > 0 {
                return "\(theNumbe)m ago"
            } else if let theNumbe = theComponents.second, theNumbe > 0 {
                return "\(theNumbe)s ago"
            } else {
                return "now"
            }
        }
        return ""
    }
}



extension MessageVC: QuickstartConversationsManagerDelegate {
    
    func reloadAllData() {
        debouncer.debounce(1.0) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                for item in 0..<self.chatDataArr.count {
                    let name = self.chatDataArr[item].groupName
                    if let conversation = self.listOfChannel.first(where: { $0.uniqueName == name }) {
                        self.chatDataArr[item].chatData = conversation
                    }
                }
                
                self.chatDataArr.sort {
                    ($0.chatData?.lastMessageDate ?? Date.distantPast) > ($1.chatData?.lastMessageDate ?? Date.distantPast)
                }
                
                DispatchQueue.main.async {
                    self.fetchUnreadMessageCounts()
                    self.tblV.reloadData()
                }
            }
        }
    }
    
    func displayStatusMessage(_ statusMessage: String) {
        print(statusMessage)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("Start Typing")
    }
    
    func endTyping(participant: TCHParticipant) {
        print("End Typing")
    }
    
    func getClient(client: TwilioConversationsClient?) {
        if let client = client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData(userType: "guest")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        
        
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.fetchUnreadMessageCounts()
                self.reloadAllData()
            }
        }
    }
}

extension MessageVC {
    func bindVC() {
        
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.chatDataArr = response.data ?? []
                    self.MainchatDataArr = response.data ?? []
                    DispatchQueue.main.asyncAfter(deadline: .now() ){
                        
                        self.reloadAllData()
                        // self.tblV.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                })
            }.store(in: &cancellables)
        
    }
}

class Debouncer {
    private var timer: Timer?
    
    func debounce(_ delay: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
