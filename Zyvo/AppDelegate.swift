//
//  AppDelegate.swift
//  Zyvo
//
//  Created by ravi on 7/11/24.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    var window: UIWindow?
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // Thread.sleep(forTimeInterval: 3)
       IQKeyboardManager.shared.enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyC9NuN_f-wESHh3kihTvpbvdrmKlTQurxw")
        
        GMSServices.provideAPIKey("AIzaSyCoRbKvSDMCEitmr_ZwscpZvoVxiXPF5e4")
        
        StripeAPI.defaultPublishableKey = "pk_test_51QnHZl2Nd862ZJtETiUKw9fMnacKnSy3u27rwJzDsDzGoKV7yFcHWW7Zy68KXflyGZqc5Cjm2ChdpWlaE72R0fp200DSuioFyd"
        
        GIDSignIn.sharedInstance()?.clientID = "231767087258-h2dao7u5jusqdbns3b6kr02e1mso9ehr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        UITabBar.appearance().tintColor = UIColor.darkGray
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        
        APIManager.shared.apiforGetChatToken(role: "guest") { t in
            
        }
        return true
    }
    
    
    
    // for google signin
    internal func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

        handled = GIDSignIn.sharedInstance()!.handle(url)
      if handled {
        return true
      }

      //  facebook login
//        ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

public extension UIApplication {
    
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
       /* if let SSASide = base as? KSideMenuVC {
            if let nav = SSASide.mainViewController as? UINavigationController{
                return topViewController(nav.visibleViewController)
            }
        } */
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
  
}
