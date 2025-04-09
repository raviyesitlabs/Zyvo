//
//  HostBookingAVC.swift
//  Zyvo
//
//  Created by ravi on 2/01/25.
//

import UIKit
import DropDown
import Combine
import GoogleMaps
import CoreLocation

class HostBookingAVC: UIViewController {
    
    @IBOutlet weak var btnshowMore: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    
    @IBOutlet weak var view_DescParking: UIView!
    @IBOutlet weak var view_DescHostRules: UIView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var btnSortPositiveRating: UIButton!
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    @IBOutlet weak var includeInBookingCollV: UICollectionView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnMessageHost: UIButton!
    @IBOutlet weak var btnReportAnIssue: UIButton!
    @IBOutlet weak var btnReviewBooking: UIButton!
    
    @IBOutlet weak var view_Parking: UIView!
    @IBOutlet weak var view_wifi: UIView!
    @IBOutlet weak var view_rooms: UIView!
    @IBOutlet weak var view_Tables: UIView!
    @IBOutlet weak var view_Chairs: UIView!
    @IBOutlet weak var view_Kitchen: UIView!
    @IBOutlet weak var parkingDropImg: UIImageView!
    @IBOutlet weak var hostRuleDropImg: UIImageView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var guestNameLbl: UILabel!
    @IBOutlet weak var guestRatingLbl: UILabel!
    @IBOutlet weak var guestProfileImg: UIImageView!
    
    @IBOutlet weak var propertyImg: UIImageView!
    @IBOutlet weak var propertyNameLbl: UILabel!
    @IBOutlet weak var propertyRatingLbl: UILabel!
    @IBOutlet weak var propertyRatingCountLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var hoursPriceLbl: UILabel!
    @IBOutlet weak var cleaningFeesLbl: UILabel!
    @IBOutlet weak var zyvoServiceFeeLbl: UILabel!
    @IBOutlet weak var taxesLbl: UILabel!
    @IBOutlet weak var addOnsLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var propertyNameLbl1: UILabel!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var bookingStatusBtn: UIButton!
    @IBOutlet weak var imgbgV1: UIView!
    @IBOutlet weak var propertyImg1: UIImageView!
    @IBOutlet weak var imgbgV2: UIView!
    @IBOutlet weak var propertyImg2: UIImageView!
    @IBOutlet weak var imgbgV3: UIView!
    @IBOutlet weak var propertyImg3: UIImageView!
    
    //    @IBOutlet weak var bookingDateLbl: UILabel!
    //    @IBOutlet weak var bookingHoursLbl: UILabel!
    //    @IBOutlet weak var bookingFrom_ToLbl: UILabel!
    @IBOutlet weak var parkingRuleLbl: UILabel!
    @IBOutlet weak var hostRuleLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    let locationManager = CLLocationManager()
    var bookingId : Int?
    var lat: Double?
    var lot: Double?
    private let spacing:CGFloat = 16.0
    
    
    var hostProfileImgg = ""
    
    var guestProfileImgg = ""
    
    let timeDropdown = DropDown()
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    
    var isOpenDescParking = "false"
    var isOpenDescHostRules = "false"
    var count = 5
    var bookingDetailViewModel = BookingDetailViewModel()
    var bookingDetailArr : BookingDetailDataModel?
    var reviewDataArr = [H_ReviewsDataModel]()
    
    var getJoinChannelDetails : JoinChanelModel?
    private var viewModel = BookingDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var channelName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindVC_GetBookingDetail()
        self.bindVC_GetReviews()
        
        bindVC()
        
        view_DescParking.isHidden = true
        view_DescHostRules.isHidden = true
        
        tblV.register(UINib(nibName: "HostRatingCell", bundle: nil), forCellReuseIdentifier: "HostRatingCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        // self.mapView.delegate = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        btnshowMore.layer.cornerRadius = btnshowMore.layer.frame.height / 2
        btnshowMore.layer.borderWidth = 1.0
        btnshowMore.layer.borderColor = UIColor.lightGray.cgColor
        
        guestProfileImg.layer.cornerRadius = guestProfileImg.frame.height / 2
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_DescParking.layer.cornerRadius = 10
        view_DescParking.layer.borderWidth = 1.0
        view_DescParking.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view_DescHostRules.layer.cornerRadius = 10
        view_DescHostRules.layer.borderWidth = 1.0
        view_DescHostRules.layer.borderColor = UIColor.lightGray.cgColor
        
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Parking.layer.cornerRadius = 15
        view_Parking.layer.borderWidth = 1.0
        view_Parking.layer.borderColor = UIColor.lightGray.cgColor
        
        view_wifi.layer.cornerRadius = 15
        view_wifi.layer.borderWidth = 1
        view_wifi.layer.borderColor = UIColor.lightGray.cgColor
        
        view_rooms.layer.cornerRadius = 15
        view_rooms.layer.borderWidth = 1
        view_rooms.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Tables.layer.cornerRadius = 15
        view_Tables.layer.borderWidth = 1
        view_Tables.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Chairs.layer.cornerRadius = 15
        view_Chairs.layer.borderWidth = 1
        view_Chairs.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Kitchen.layer.cornerRadius = 15
        view_Kitchen.layer.borderWidth = 1
        view_Kitchen.layer.borderColor = UIColor.lightGray.cgColor
        
        collecV_BankingDetails.delegate = self
        collecV_BankingDetails.dataSource = self
        let nib2 = UINib(nibName: "BankingDetailsCell", bundle: nil)
        collecV_BankingDetails?.register(nib2, forCellWithReuseIdentifier: "BankingDetailsCell")
        
        if let layout = collecV_BankingDetails.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }
        
        let nib = UINib(nibName: "CellHost", bundle: nil)
        collecV_Host?.register(nib, forCellWithReuseIdentifier: "CellHost")
        collecV_Host.delegate = self
        collecV_Host.dataSource = self
        
        let nib1 = UINib(nibName: "HostBookingsIncludeCollVCell", bundle: nil)
        includeInBookingCollV?.register(nib1, forCellWithReuseIdentifier: "HostBookingsIncludeCollVCell")
        includeInBookingCollV.delegate = self
        includeInBookingCollV.dataSource = self
        
        view_Details.layer.cornerRadius = 30
        view_Details.layer.borderWidth = 0.5
        view_Details.layer.borderColor = UIColor.lightGray.cgColor
        
        btnMessageHost.layer.cornerRadius = 10
        btnMessageHost.layer.borderWidth = 1
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        
        btnReportAnIssue.layer.cornerRadius = 10
        btnReportAnIssue.layer.borderWidth = 1
        btnReportAnIssue.layer.borderColor = UIColor.black.cgColor
        
        btnReviewBooking.layer.cornerRadius = 10
        btnReviewBooking.layer.borderWidth = 1
        btnReviewBooking.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReportAnIssue_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReportViolationPopUpVc") as! HostReportViolationPopUpVc
        vc.bookingId = self.bookingId
        vc.propertyId = self.bookingDetailArr?.propertyID
    
        vc.backAction = { str in
            print(str,"Data Recieved")
            if str == "Ravik" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as! HostNotificationPopUpVC
                vc.backAction = { str in
                    print(str,"Data Recieved From ")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostSuccessPopUpVC") as! HostSuccessPopUpVC
                    self.present(vc, animated: true)
                }
                self.present(vc, animated:  true)
            }
        }
        self.present(vc, animated:  true)
    }
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isOpenDescParking == "false" {
            isOpenDescParking = "true"
            view_DescParking.isHidden = false
            parkingDropImg.image = UIImage(named: "União 106")
        } else {
            isOpenDescParking = "false"
            view_DescParking.isHidden = true
            parkingDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isOpenDescHostRules == "false" {
            isOpenDescHostRules = "true"
            view_DescHostRules.isHidden = false
            hostRuleDropImg.image = UIImage(named: "União 106")
        } else {
            isOpenDescHostRules = "false"
            view_DescHostRules.isHidden = true
            hostRuleDropImg.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnReviewBooking_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostReviewFeedbackVC") as! HostReviewFeedbackVC
        vc.bookingID = self.bookingId ?? 0
        vc.proprtyID = self.bookingDetailArr?.propertyID ?? 0
        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnPositiveRating_Tap(_ sender: UIButton) {
        // Set up the dropdown
        
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            if index == 0{
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "highest_review")
            }else if index == 1{
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "lowest_review")
            }else{
                self?.bookingDetailViewModel.HostGetBookingReview(propertyId: self?.bookingDetailArr?.propertyID ?? 0, filter: "recent_review")
            }
        }
        timeDropdown.show()
    }
    
    @IBAction func btnMessageHost_Tap(_ sender: UIButton) {
       // self.tabBarController?.selectedIndex = 1
        
        let senderID = UserDetail.shared.getUserId()
        
        viewModel.apiForJoinChannel(senderId: senderID, receiverId: "\(self.bookingDetailArr?.guestID ?? 0)", groupChannel: self.channelName, userType: "host")
        
    }
    
    @IBAction func shareBtn(_ sender: UIButton){
        let textToShare = "Check out this cool app!"
        let urlToShare = URL(string: "https://www.example.com")!
        let itemsToShare: [Any] = [textToShare, urlToShare]
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view  // For iPad support
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func ShowMoreReviewBtn(_ sender: UIButton){
        
        if sender.isSelected == false{
            sender.isSelected = true
            count = count + 5
            //btnshowMore.setTitle("Show Less Review", for: .normal)
        }else{
            sender.isSelected = false
            count = count - 5
            // btnshowMore.setTitle("Show More Review", for: .normal)
        }
        self.tblV.reloadData()
    }
    
}

extension HostBookingAVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Host {
            return 4
        }else if collectionView == includeInBookingCollV {
            return bookingDetailArr?.amenities?.count ?? 0
        } else {
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Host {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellHost", for: indexPath) as! CellHost
            cell.lbl_title.text = arrHost[indexPath.row]
            cell.img.image = UIImage(named: arrHost[indexPath.row])
            
            return cell
        }else if collectionView == includeInBookingCollV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostBookingsIncludeCollVCell", for: indexPath) as! HostBookingsIncludeCollVCell
            cell.titleLbl.text = bookingDetailArr?.amenities?[indexPath.item]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankingDetailsCell", for: indexPath) as! BankingDetailsCell
            if indexPath.row == 0{
                cell.lbl_title.text = bookingDetailArr?.bookingDate
            }else if indexPath.item == 1{
                cell.lbl_title.text = "From \(bookingDetailArr?.bookingStartTime ?? "") to \(bookingDetailArr?.bookingEndTime ?? "")"
            }else if indexPath.item == 2{
                cell.lbl_title.text = "\(bookingDetailArr?.bookingHour ?? "") Hours"
            }
            
            cell.lbl_title.text = items[indexPath.item]
            cell.img.image = UIImage(named: imgArr[indexPath.item])
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collecV_BankingDetails{
            let text = items[indexPath.item]
            let maxWidth = collecV_BankingDetails.frame.width - 16 // Adjust padding
            let size = (text as NSString).boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 16)],context: nil).size
            return CGSize(width: size.width + 16, height: size.height + 16) // Add padding
            //return CGSize(width: collectionView.frame.width / 2 - 10, height: 70)
        }else if collectionView == collecV_BankingDetails{
            
            return CGSize(width: collectionView.frame.width / 3 - 5, height: 40)
        }else{
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 2
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (collecV_Host.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 70 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}


extension HostBookingAVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewDataArr.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 80
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "HostRatingCell", for: indexPath) as! HostRatingCell
        
        cell.nameLbl.text = reviewDataArr[indexPath.row].reviewerName
        cell.ratingV.text = reviewDataArr[indexPath.row].reviewMessage
        cell.dateLbl.text = reviewDataArr[indexPath.row].reviewDate
        cell.ratingV.rating = Double(reviewDataArr[indexPath.row].reviewRating ?? "") ?? 0.0
        
        let profileURL = AppURL.imageURL + (self.reviewDataArr[indexPath.row].profileImage ?? "")
        cell.img.loadImage(from:profileURL,placeholder: UIImage(named: "NoIMg"))
        
        return cell
    }
    
    
}

extension HostBookingAVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
            bookingDetailViewModel.HostGetBookingDetail(bookingId: self.bookingId ?? 0, latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}

extension HostBookingAVC{
    
    func bindVC_GetBookingDetail(){
        bookingDetailViewModel.$getBookingResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.bookingDetailArr = response.data
                    
                    
                    // self.reviewsArr = self.getBookingDetails?.reviews
                    let guestID = self.bookingDetailArr?.guestID ?? 0
                    let hostID = self.bookingDetailArr?.hostID ?? 0
                    
                    let id1 = min(guestID, hostID)
                    let id2 = max(guestID, hostID)
                    
                    self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.bookingDetailArr?.propertyID ?? 0)"
                    
                    self.guestNameLbl.text = self.bookingDetailArr?.guestName
                    self.guestRatingLbl.text = self.bookingDetailArr?.guestRating
                    self.propertyNameLbl.text = self.bookingDetailArr?.propertyTitle
                    self.propertyRatingLbl.text = self.bookingDetailArr?.reviewsTotalCount
                    self.propertyRatingCountLbl.text = "\(self.bookingDetailArr?.reviewsTotalCount ?? "")"
                    self.distanceLbl.text = "\(self.bookingDetailArr?.distanceMiles ?? "") miles away"
                    self.hoursLbl.text = "\(self.bookingDetailArr?.bookingHour ?? "") Hours"
                    self.hoursPriceLbl.text = "$ \(self.bookingDetailArr?.bookingAmount ?? "")"
                    self.cleaningFeesLbl.text = "$ \(self.bookingDetailArr?.cleaningFee ?? "")"
                    self.zyvoServiceFeeLbl.text = "$ \(self.bookingDetailArr?.serviceFee ?? "")"
                    self.taxesLbl.text = "$ \(self.bookingDetailArr?.tax ?? "")"
                    self.addOnsLbl.text = "$ \(self.bookingDetailArr?.addOnTotal ?? "0")"
                    self.totalLbl.text = "$ \(self.bookingDetailArr?.bookingTotalAmount ?? "")"
                    self.propertyNameLbl1.text = self.bookingDetailArr?.propertyTitle
                    self.bookingStatusBtn.setTitle(self.bookingDetailArr?.bookingStatus, for: .normal)
                    self.parkingRuleLbl.text = self.bookingDetailArr?.parkingRules
                    self.hostRuleLbl.text = self.bookingDetailArr?.hostRules
                    self.addressLbl.text = self.bookingDetailArr?.address
                    self.reviewCount.text = "Reviews (\(self.bookingDetailArr?.reviewsTotalCount ?? ""))"
                    self.ratingLbl.text = self.bookingDetailArr?.reviewsTotalRating
                    self.includeInBookingCollV.reloadData()
                    let profileURL = AppURL.imageURL + (self.bookingDetailArr?.guestAvatar ?? "")
                    self.guestProfileImg.loadImage(from:profileURL,placeholder: UIImage(named: "NoIMg"))
                    
                    let imgURL = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                    self.propertyImg.loadImage(from:imgURL,placeholder: UIImage(named: "NoIMg"))
                    self.imgbgV1.isHidden = true
                    self.imgbgV2.isHidden = true
                    self.imgbgV3.isHidden = true
                    if self.bookingDetailArr?.images?.count ?? 0 >= 3{
                        self.imgbgV1.isHidden = false
                        self.imgbgV2.isHidden = false
                        self.imgbgV3.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                        let imgURL2 = AppURL.imageURL + (self.bookingDetailArr?.images?[1] ?? "")
                        self.propertyImg2.loadImage(from:imgURL2,placeholder: UIImage(named: "NoIMg"))
                        let imgURL3 = AppURL.imageURL + (self.bookingDetailArr?.images?[2] ?? "")
                        self.propertyImg3.loadImage(from:imgURL3,placeholder: UIImage(named: "NoIMg"))
                    }else if self.bookingDetailArr?.images?.count ?? 0 == 2{
                        self.imgbgV1.isHidden = false
                        self.imgbgV2.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                        let imgURL2 = AppURL.imageURL + (self.bookingDetailArr?.images?[1] ?? "")
                        self.propertyImg2.loadImage(from:imgURL2,placeholder: UIImage(named: "NoIMg"))
                    }else if self.bookingDetailArr?.images?.count ?? 0 == 1{
                        self.imgbgV1.isHidden = false
                        let imgURL1 = AppURL.imageURL + (self.bookingDetailArr?.images?[0] ?? "")
                        self.propertyImg1.loadImage(from:imgURL1,placeholder: UIImage(named: "NoIMg"))
                    }
                    self.collecV_BankingDetails.reloadData()
                    if self.bookingDetailArr?.latitude != "" && self.bookingDetailArr?.longitude != ""{
                        guard let latString = self.bookingDetailArr?.latitude,
                              let longString = self.bookingDetailArr?.longitude,
                              let latitude = Double(latString),
                              let longitude = Double(longString),
                              latitude != 0.0, longitude != 0.0 else {
                            print("Invalid coordinates")
                            return
                        }
                        // Set up Google Map with valid coordinates
                        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
                        // Initialize GMSMapView and set its frame to match mapView's bounds
                        let googleMapView = GMSMapView(frame: self.mapView.bounds, camera: camera)
                        googleMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.mapView.isUserInteractionEnabled = false
                        self.mapView.addSubview(googleMapView)
                        
                        // Add a marker (pin)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        //                       marker.title = "Booking Location"
                        marker.snippet = "Latitude: \(latitude), Longitude: \(longitude)"
                        marker.map = googleMapView
                        
                        googleMapView.animate(to: camera)
                    }
                    
                    
                    
                    self.bookingDetailViewModel.HostGetBookingReview(propertyId: self.bookingDetailArr?.propertyID ?? 0, filter: "highest_review")
                })
            }.store(in: &cancellables)
    }
    
    func bindVC_GetReviews(){
        bookingDetailViewModel.$getReviewsResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.reviewDataArr = response.data ?? []
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
    }
    
}


extension HostBookingAVC {
    func bindVC(){
        
        viewModel.$getJoinChannelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getJoinChannelDetails = response.data
                    
                    var senderID =  self.getJoinChannelDetails?.senderID ?? ""
                    var receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                    
                    let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                    self.guestProfileImgg = AppURL.imageURL + guestIMG
                    
                    let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                    self.hostProfileImgg = AppURL.imageURL + HostIMG
                    
                    let stryB = UIStoryboard(name: "Host", bundle: nil)
                    if let vc = stryB.instantiateViewController(withIdentifier: "HostChatVC") as? HostChatVC {
                        vc.uniqueConversationName = self.channelName
                        vc.friend_id = "\(receiverID)"
                        vc.hostProfileImg = self.hostProfileImgg
                        vc.guesttProfileImg =  self.guestProfileImgg
                        self.tabBarController?.tabBar.isHidden = true
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
        
        
        
    }
}
   
