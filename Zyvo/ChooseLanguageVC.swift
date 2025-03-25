//
//  ChooseLanguageVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class ChooseLanguageVC:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var backAction:(_ str : String ) -> () = { str in}
    var locales: [Locale] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell using the nib
        let nib = UINib(nibName: "ChooseLanguageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ChooseLanguageCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
     
        // Fetch available locales (languages + regions)
            let localeIdentifiers = Locale.availableIdentifiers
            locales = localeIdentifiers.map { Locale(identifier: $0) }
        
        
        // Filter locales where the region is not empty
        locales = locales.filter { locale in
            guard let regionCode = locale.regionCode else { return false }
            return !regionCode.isEmpty
        }

        // Sort locales alphabetically by localized language name
        locales.sort { (locale1, locale2) -> Bool in
            let languageName1 = Locale.current.localizedString(forLanguageCode: locale1.languageCode ?? "") ?? ""
            let languageName2 = Locale.current.localizedString(forLanguageCode: locale2.languageCode ?? "") ?? ""
            return languageName1 < languageName2
        }
        
        

    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locales.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseLanguageCell", for: indexPath) as! ChooseLanguageCell
        
        let locale = locales[indexPath.row]
                let languageName = locale.localizedString(forLanguageCode: locale.languageCode ?? "") ?? "Unknown Language"
                let regionName = locale.localizedString(forRegionCode: locale.regionCode ?? "") ?? "Unknown Region"
              
        cell.lbl_LanguageTitle.text = languageName
        cell.lbl_CountryName.text = regionName

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let locale = locales[indexPath.row]
        let languageName = locale.localizedString(forLanguageCode: locale.languageCode ?? "") ?? "Unknown Language"
        print("selected Language Name :\(languageName)")
        
        self.backAction("\(languageName)")
        self.dismiss(animated: true)
  
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
        // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
         sizeForItemAt indexPath: IndexPath) -> CGSize {
                // Calculate the width based on screen size, subtracting padding or spacing as needed
                let padding: CGFloat = 10  // Example padding (adjust as needed)
                let collectionViewWidth = collectionView.frame.width - padding
                let cellWidth = collectionViewWidth / 2  // Display 2 cells per row

                // Return the size with fixed height of 110
                return CGSize(width: cellWidth, height: 110)
            }
    }

extension ChooseLanguageVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //--- Change Scroll View Indicator Color and Width ---//
        let verticalIndicatorView = scrollView.subviews[scrollView.subviews.count - 1].subviews[0]
        let horizontalIndicatorView = scrollView.subviews[scrollView.subviews.count - 2].subviews[0]

        // Change color
        verticalIndicatorView.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        horizontalIndicatorView.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)

        
    }
}

