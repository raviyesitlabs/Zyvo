//
//  HostMyTabVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit

class HostMyTabVC: UITabBarController {
    
    // Store the default tab bar height
    var tabBarHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // additionalSafeAreaInsets.bottom = 10

        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            
            // Set the background color of the tab bar to white
               appearance.backgroundColor = UIColor.white
            
            // Set font size for tab bar items
            let font = UIFont.systemFont(ofSize: 14) // Customize your desired font size here
            let titleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.lightGray // Set the default color for the normal state
            ]
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = titleTextAttributes
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = titleTextAttributes
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = titleTextAttributes
            
            // Set selected item attributes
            let selectedTitleTextAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black // Set the color for the selected state
            ]
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedTitleTextAttributes

            // Set badge appearance
            setTabBarItemBadgeAppearance(appearance.stackedLayoutAppearance)
            setTabBarItemBadgeAppearance(appearance.inlineLayoutAppearance)
            setTabBarItemBadgeAppearance(appearance.compactInlineLayoutAppearance)

            // Apply the appearance settings
            tabBar.standardAppearance = appearance

            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }

        // Method to customize badge appearance
        @available(iOS 13.0, *)
         func setTabBarItemBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
            // Set the badge background color
            itemAppearance.normal.badgeBackgroundColor = UIColor.init(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)

            // Set the badge text color (customize this color)
            let badgeTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black // Customize the badge font color here
            ]
            itemAppearance.normal.badgeTextAttributes = badgeTextAttributes

            // Optionally set other states (e.g., selected)
            itemAppearance.selected.badgeTextAttributes = badgeTextAttributes
        }

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
//        if item.title == "Home"{
//            let rootView = self.viewControllers![0] as! UINavigationController
//            rootView.popToRootViewController(animated: false)
//        }else{
            let rootView = self.viewControllers![self.selectedIndex] as! UINavigationController
            rootView.popToRootViewController(animated: false)
//        }
    }
   
    override func viewDidLayoutSubviews() {
            super.viewWillLayoutSubviews()

            tabBar.frame.size.height = 90
            tabBar.frame.origin.y = view.frame.height - 90
    }
   
}
