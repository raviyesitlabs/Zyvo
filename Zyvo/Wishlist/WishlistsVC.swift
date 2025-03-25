//
//  WishlistsVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import Combine

class WishlistsVC: UIViewController {
    
    @IBOutlet weak var view1: UIView!
    var arr = ["Sea view","Cabin in Peshastin","Sea view","Cabin in Peshastin","Sea view","Cabin in Peshastin","Sea view","Cabin in Peshastin"]
    var imgArr = ["img1","img3","img2","img1","img1","img3","img4","img2"]
    
    private var viewModel = WishlistDataViewModel()
    private var cancellables = Set<AnyCancellable>()
   var getWishlistArr : [WishlistDataModel]?
    
    @IBOutlet weak var collecV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindVC()
//      view1.layer.borderWidth = 1.5
//      view1.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
//      view1.layer.cornerRadius = view1.layer.frame.height / 2
        // Register the WishlistCell nib file
        let nib = UINib(nibName: "WishlistCell", bundle: nil)
        collecV.register(nib, forCellWithReuseIdentifier: "WishlistCell")
        collecV.delegate = self
        collecV.dataSource = self
        // Style the collection view
        collecV.layer.cornerRadius = 10
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        viewModel.apiForGetCreatedWishList()
        }
      }
    
    // MARK: - UICollectionView Delegate and DataSource
    extension WishlistsVC: UICollectionViewDelegate, UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return getWishlistArr?.count ?? 0//arr.count
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collecV.dequeueReusableCell(withReuseIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
            let data = getWishlistArr?[indexPath.item]
            // Configure the cell here if needed
            cell.lbl_name.text =  data?.wishlistName ?? "" //arr[indexPath.item]
            // cell.img.image = UIImage(named: imgArr[indexPath.row])
            var image = data?.lastSavedPropertyImage ?? ""
            let imgURL = AppURL.imageURL + image
            cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "img1"))
            cell.lbl_SavedCount.text = "\(data?.itemsInWishlist ?? 0)" + " Saved"
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let data = getWishlistArr?[indexPath.item]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditWishListVC") as! EditWishListVC
            vc.WishlistID = "\(data?.wishlistID ?? 0)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    extension WishlistsVC: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat = 20 // Spacing between cells
            let itemsPerRow: CGFloat = 2 // 1
            let totalPadding = (itemsPerRow - 1) * padding
            let availableWidth = collectionView.frame.width - totalPadding
            let cellWidth = availableWidth / itemsPerRow
            
            return CGSize(width: cellWidth, height: 250) // 400
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

extension WishlistsVC {
    func bindVC(){
        viewModel.$getWishListResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                   // self.showToast(response.message ?? "")
                    self.getWishlistArr = response.data
                    print(self.getWishlistArr ?? [],"getWishlistArr")
                    //self.getItemsArr?.removeAll()
                    if self.getWishlistArr?.count == 0 {
                        self.collecV.setEmptyView(message: "No Data Found")
                    } else {
                        self.collecV.setEmptyView(message: "")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() ) {
                        //  self.updateCollectionViewHeight()
                        self.collecV.reloadData()
                    }
                    
                })
            }.store(in: &cancellables)
    }
}
