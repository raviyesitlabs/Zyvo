//
//  BrowseAllGuidesVC.swift
//  Zyvo
//
//  Created by ravi on 8/11/24.
//

import UIKit
import Combine

class BrowseAllGuidesVC: UIViewController {

    @IBOutlet weak var tblV: UITableView!
    
    @IBOutlet weak var tblV_H: NSLayoutConstraint!
    
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var NeedTxtView: UIView!
    @IBOutlet weak var contactUsBtnO: UIButton!
    
    private var viewModel = AllGuidesViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var allGuidesArr = [AllGuidesModel]()
    
    var comesFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        viewModel.apiForGetAllBrowseGuides()
        
        searchV.layer.cornerRadius = searchV.layer.frame.height / 2
        searchV.layer.borderWidth = 1
        searchV.layer.borderColor = UIColor.lightGray.cgColor
        tblV.register(UINib(nibName: "BrowseAllArticleCell", bundle: nil), forCellReuseIdentifier: "BrowseAllArticleCell")
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tblV.delegate = self
        tblV.dataSource = self
       
        if Panel == "Host"{
            self.NeedTxtView.isHidden = false
            self.contactUsBtnO.setTitleColor(UIColor.darkGray, for: .normal)
        }else{
            self.NeedTxtView.isHidden = true
            self.contactUsBtnO.setTitleColor(UIColor.black, for: .normal)
        }

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblV_H.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactUsBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BrowseAllGuidesVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGuidesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = allGuidesArr[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "BrowseAllArticleCell", for: indexPath) as! BrowseAllArticleCell
                cell.lbl_title.text = data.title ?? ""//arrName[indexPath.item]
                cell.lbl_Desc.isHidden = true
              
                var image = data.coverImage ?? ""
                let imgURL = AppURL.imageURL + image
                cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
                return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let data = allGuidesArr[indexPath.row]
        let vc = sb.instantiateViewController(withIdentifier: "AllGuidesOpenVC") as! AllGuidesOpenVC
        vc.guideid = "\(data.id ?? 0)"
        vc.comesFrom = "Guide"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BrowseAllGuidesVC {
    
    func bindVC(){
        viewModel.$getAllBrowseGuidesResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    self.allGuidesArr = response.data ?? []
                    print( self.allGuidesArr.count," self.allArticleArr")
                    DispatchQueue.main.asyncAfter(deadline: .now()  ) {
                        self.tblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
}
