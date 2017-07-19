//
//  AppDelegate.swift
//  SNSTM
//
//  Created by tarosekine on 2017/03/19.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NCMB.setApplicationKey("3f267ad5b1ab713b7439853ade078d3877239b15828ccce3864b83d4dd8b4bff", clientKey: "ebf5c95fb490a12fc5d3fceba4560902fb754f0666e26daa59f9ed5b333e5be9")
        
        let ud = UserDefaults.standard
        let isLogin = ud.bool(forKey: "isSignIn")
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        UINavigationController.navigationBar.tintColor = colorLiteral
//        UINavigationBar.appearance().titleTextAttributes = colorliteral
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]


        if isLogin == false {
            // ログイン済でなかった場合、ログイン用のStoryboardを初期画面として起動
            let rootViewController: SignInViewController = UIStoryboard(name: "SignIn", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let navigation = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = navigation
        }
        
        StoryboardHelper.adjust(to: window)

        return true
    
    }

    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

