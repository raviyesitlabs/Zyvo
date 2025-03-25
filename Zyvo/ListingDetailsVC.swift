//
//  ListingDetailsVC.swift
//  Zyvo
//
//  Created by ravi on 25/11/24.
//

import UIKit
import DropDown

class ListingDetailsVC: UIViewController {
    
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var btnShowMoreReview: UIButton!
    @IBOutlet weak var tblV_Review: UITableView!
    
    @IBOutlet weak var tblVReviewH_Const: NSLayoutConstraint!
    @IBOutlet weak var collecVListingH_Const: NSLayoutConstraint!
    @IBOutlet weak var CollecV_Listing: UICollectionView!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var collecV: UICollectionView!
    @IBOutlet weak var view_Photo: UIView!
    @IBOutlet weak var viewPhoto_Frame: UIView!
    
    @IBOutlet weak var btnReadMore: UIButton!
    var isReadMore = "no"
    var isRewReadMore = "yes"
    var count = 5
    var reviewArr = ["Highest Review","Lowest Review","Recent Review"]
    let items = [" Lawyer ",  "English & Hindi","New York, US"]
    var imgArr = ["myworkicon","languageicon","location line"]
    let dropDown = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collecV.delegate = self
        collecV.dataSource = self
        let nib2 = UINib(nibName: "BankingDetailsCell", bundle: nil)
        collecV?.register(nib2, forCellWithReuseIdentifier: "BankingDetailsCell")
        
        
        let nib = UINib(nibName: "HomeCell", bundle: nil)
        CollecV_Listing?.register(nib, forCellWithReuseIdentifier: "HomeCell")
        CollecV_Listing.delegate = self
        CollecV_Listing.dataSource = self
        CollecV_Listing.layer.cornerRadius = 10
        
        
        tblV_Review.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV_Review.delegate = self
        tblV_Review.dataSource = self
        
        self.tblV_Review.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
//        aboutHostH_Const.constant = 350
        
        viewPhoto_Frame.layer.cornerRadius = 20
        viewPhoto_Frame.layer.borderWidth = 1.0
        viewPhoto_Frame.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        btnShowMoreReview.layer.cornerRadius = btnShowMoreReview.layer.frame.height / 2
        btnShowMoreReview.layer.borderWidth = 1.0
        btnShowMoreReview.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        view_Search.layer.borderWidth = 1
        view_Search.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_Photo.layer.cornerRadius = view_Photo.layer.frame.height / 2
        view_Photo.layer.borderWidth = 4
        view_Photo.layer.borderColor = UIColor.init(red: 234/255, green: 239/255, blue: 244/255, alpha: 0.9).cgColor
      
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
          tblV_Review.layer.removeAllAnimations()
        tblVReviewH_Const.constant = tblV_Review.contentSize.height
          UIView.animate(withDuration: 0.5) {
              self.updateViewConstraints()
          }
          
      }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           updateCollectionViewHeight()
       }
       
       private func updateCollectionViewHeight() {
           // Calculate the number of rows needed
           let numberOfItems = collectionView(CollecV_Listing, numberOfItemsInSection: 0)
           let itemsPerRow: CGFloat = 1
           let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
           
           // Set the item height and spacing
           let itemHeight: CGFloat = 370
           let padding: CGFloat = 10
           let totalPadding = (rows - 1) * padding
           let totalHeight = rows * itemHeight + totalPadding
           
           // Update the collection view height constraint
           collecVListingH_Const.constant = totalHeight
       }
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        if isReadMore == "no" {
            isReadMore = "yes"
            lblDes.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only..."
            btnReadMore.setImage(UIImage(named: "Read Less"), for: .normal)
        } else {
            lblDes.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
            btnReadMore.setImage(UIImage(named: "Read more"), for: .normal)
            isReadMore = "no"
//            lblHeightConstraings.constant = 100
        }
        
        tblV_Review.layer.removeAllAnimations()
      tblVReviewH_Const.constant = tblV_Review.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
        tblV_Review.reloadData()
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnViewMore_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingVC") as! ListingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortReviewBtn(_ sender: UIButton){
        // Set up the dropdown
       
        dropDown.anchorView = sender // You can set it to a UIButton or any UIView
        dropDown.dataSource = reviewArr
        dropDown.direction = .bottom
       
        dropDown.bottomOffset = CGPoint(x: 3, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
                   // Do something with the selected month
                   print("Selected month: \(item)")
                  
               }
        dropDown.show()
    }
    
    @IBAction func btnMoreReview_Tap(_ sender: UIButton) {
        if isRewReadMore == "no" {
            isRewReadMore = "yes"
            count = count - 10
//            tblVH_Const.constant = 250
            sender.setTitle("See More Reviews", for: .normal)
        } else {
            sender.setTitle("See Less Reviews", for: .normal)
          
            isRewReadMore = "no"
            count = count + 10
//            tblVH_Const.constant = 450
        }
        self.tblV_Review.reloadData()
       
    }
    
}

extension ListingDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV {
            return items.count }
        else {
            return 3
        }
      
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankingDetailsCell", for: indexPath) as! BankingDetailsCell
            cell.lbl_title.text = items[indexPath.item]
            cell.img.image = UIImage(named: imgArr[indexPath.item])
            return cell
        }else {
                let cell = CollecV_Listing.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
                cell.view_Instant.isHidden = true
            cell.btnCross.isHidden = true
            cell.btnHeart.isHidden = true
            cell.imgBookMark.isHidden = true
                
            return cell
        }
       
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollecV_Listing {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePopUpVC") as! ImagePopUpVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == CollecV_Listing {
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 1
            let totalSpacing = (numberOfColumns - 1) * spacing
            
            let itemWidth = (CollecV_Listing.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 370 // Fixed height as per your code
            print(itemWidth,itemHeight,"itemWidth,itemHeight")
            return CGSize(width: itemWidth, height: itemHeight)
        }else{
            let spacing: CGFloat = 10 // Adjust spacing as needed
            let numberOfColumns: CGFloat = 2
            let totalSpacing = (numberOfColumns - 1) * spacing

            let itemWidth = (collecV.bounds.width - totalSpacing) / numberOfColumns
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

extension ListingDetailsVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV_Review.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        DispatchQueue.main.async {
            self.tblVReviewH_Const.constant = self.tblV_Review.contentSize.height
            self.tblV_Review.layoutIfNeeded()
        }
        return cell
    }
    
    
}
