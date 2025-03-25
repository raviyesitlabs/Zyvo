//
//  HostChooseLanguageVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit

class HostChooseLanguageVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collecV: UICollectionView!
    var backAction:(_ str : String ) -> () = { str in}
   
    var locales: [Locale] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell using the nib
        let nib = UINib(nibName: "ChooseLanguageCell", bundle: nil)
        collecV.register(nib, forCellWithReuseIdentifier: "ChooseLanguageCell")
        
        
//        // Top 50 most popular language codes (ISO 639-1)
//           let popularLanguageCodes = [
//               "en", "es", "fr", "de", "zh", "hi", "ar", "ru", "pt", "ja",
//               "ko", "it", "nl", "tr", "pl", "sv", "no", "da", "fi", "el",
//               "th", "cs", "hu", "ro", "vi", "he", "uk", "id", "ms", "bg",
//               "sk", "sr", "hr", "lt", "sl", "lv", "et", "fa", "ta", "bn",
//               "ml", "te", "kn", "gu", "mr", "or", "pa", "sw", "am", "my"
//           ]
//           
//           // Create Locale objects for the popular languages
//           locales = popularLanguageCodes.map { Locale(identifier: $0) }
//           
//           // Sort locales alphabetically by localized language name
//           locales.sort { (locale1, locale2) -> Bool in
//               let languageName1 = Locale.current.localizedString(forLanguageCode: locale1.languageCode ?? "") ?? ""
//               let languageName2 = Locale.current.localizedString(forLanguageCode: locale2.languageCode ?? "") ?? ""
//               return languageName1 < languageName2
//           }
//
//        
        collecV.dataSource = self
        collecV.delegate = self
//        
//        
////           // Reload the collection view to display the languages
//           collecV.reloadData()

//
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSwitchToGuest(_ sender: UIButton) {
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
        // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
         sizeForItemAt indexPath: IndexPath) -> CGSize {
                // Calculate the width based on screen size, subtracting padding or spacing as needed
//                let padding: CGFloat = 10  // Example padding (adjust as needed)
//                let collectionViewWidth = collectionView.frame.width - padding
//                let cellWidth = collectionViewWidth / 4  // Display 2 cells per row

                // Return the size with fixed height of 110
                return CGSize(width: collectionView.frame.width / 3 - 15, height: 90)
            }
    
}



