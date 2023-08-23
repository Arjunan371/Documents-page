//
//  AppDelegate.swift
//  Documents page
//
//  Created by Digival on 16/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal var navigationController: UINavigationController!
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let vc = documentTabBar(nibName: "documentTabBar", bundle: nil)

        self.setAsRootViewController([vc])
        // Override point for customization after application launch.
        return true
    }
    func setAsRootViewController(_ controllers: [UIViewController]){
            self.navigationController =  UINavigationController()
            self.navigationController?.viewControllers = controllers
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
        }
}

