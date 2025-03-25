//
//  EditWishListVC.swift
//  Zyvo
//
//  Created by ravi on 21/11/24.
//

import UIKit
import Combine

class EditWishListVC: UIViewController {
    @IBOutlet weak var collecV: UICollectionView!
    
    var data = ["","","","","","","","","","","",""]
    var crossStatus = "false"
    var indexNeedtoBeDeleted = 0
    
    private var viewModel = ItemsInWishlistViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getItemsArr : [ItemsInWishlistModel]?
    
    var  WishlistID = ""

    @IBOutlet weak var lbl_name: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        
        viewModel.wishlistID = self.WishlistID
        viewModel.apiForGetItemsInWishList()

        // Register the WishlistCell nib file
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        collecV.register(nib, forCellWithReuseIdentifier: "WishlistCell")
        collecV.delegate = self
        collecV.dataSource = self
       
    }
    
    @IBAction func btnEdit_Tap(_ sender: UIButton) {
        crossStatus = "true"
        self.collecV.reloadData()
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditWishListVC :UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItemsArr?.count ?? 0  // data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = getItemsArr?[indexPath.item]
        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
       
        // Configure the cell here if needed
        cell.lbl_name.text =  data?.title ?? "" //arr[indexPath.item]
        // cell.img.image = UIImage(named: imgArr[indexPath.row])
        var image = data?.images?[0] ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
        cell.lbl_SavedCount.isHidden = true
        cell.btnCross.tag = indexPath.row
        cell.btnCross.addTarget(self, action: #selector(deleteBtn(_:)), for: .touchUpInside)
        
                if crossStatus == "true" {
                    cell.btnCross.isHidden = false
                }
                if crossStatus == "false" {
                    cell.btnCross.isHidden = true
                }
        
        return cell
//        let cell = collecV.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
//        cell.view_Instant.isHidden = true
//        
//        if crossStatus == "true" {
//            cell.btnCross.isHidden = false
//        }
//        if crossStatus == "false" {
//            cell.btnCross.isHidden = true
//        }
//       
//        cell.btnHeart.isHidden = true
//        if indexPath.row == 0 {
//            cell.view_Instant.isHidden = false
//        }
//        
//        if indexPath.row == 3 {
//            cell.view_Instant.isHidden = false
//        }
//        cell.btnCross.tag = indexPath.row
//        cell.btnCross.addTarget(self, action: #selector(deleteBtn(_:)), for: .touchUpInside)
        
       // return cell
    }
    
    @objc func deleteBtn(_ sender: UIButton){
        
        // data.remove(at: sender.tag)
        
        indexNeedtoBeDeleted = sender.tag
        
        viewModel.propertyID = "\(getItemsArr?[sender.tag].propertyID ?? 0)"
        
        viewModel.apiForRemoveItemFromWishlist()

    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension EditWishListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20 // Spacing between cells
        let itemsPerRow: CGFloat = 2 // 1
        let totalPadding = (itemsPerRow - 1) * padding
        let availableWidth = collectionView.frame.width - totalPadding
        let cellWidth = availableWidth / itemsPerRow
        
        return CGSize(width: cellWidth, height: 225) // 400
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // Vertical spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Horizontal spacing between cells
    }
}

//extension EditWishListVC:UICollectionViewDelegateFlowLayout {
//    // UICollectionViewDelegateFlowLayout method to set cell size
//        func collectionView(_ collectionView: UICollectionView,
//                            layout collectionViewLayout: UICollectionViewLayout,
//                            sizeForItemAt indexPath: IndexPath) -> CGSize {
//            // Calculate the width based on screen size, subtracting padding or spacing as needed
//            let padding: CGFloat = 5  // Example padding (adjust as needed)
//            let collectionViewWidth = collectionView.frame.width - padding
//            let cellWidth = collectionViewWidth / 1  // Display 2 cells per row
//
//            // Return the size with fixed height of 120
//            return CGSize(width: cellWidth, height: 370)
//        }
//}

extension EditWishListVC {
    
    func bindVC(){
        viewModel.$ItemsInWishlistResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                   // self.showToast(response.message ?? "")
                    
                    self.getItemsArr = response.data ?? []
                    
                    print(self.getItemsArr ?? [],"getItemsArr")
                    //self.getItemsArr?.removeAll()
                    if self.getItemsArr?.count == 0 {
                        self.collecV.setEmptyView(message: response.message ?? "")
                    } else {
                        self.collecV.setEmptyView(message: "")
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        //  self.updateCollectionViewHeight()
                        self.collecV.reloadData()
                    }
                    
                })
            }.store(in: &cancellables)
        
        //DeleteItem in Wishlist
        
        viewModel.$RemoveItemsInWishlistResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if self.getItemsArr?.count != 0 {
                            self.getItemsArr?.remove(at: self.indexNeedtoBeDeleted) }
                            self.collecV.reloadData()
                           if self.getItemsArr?.count == 0 {
                              self.collecV.setEmptyView(message: "No Data Found")
                          } else {
                            self.collecV.setEmptyView(message: "")
                        }
                    }
                })
            }.store(in: &cancellables)
        
    }
}
