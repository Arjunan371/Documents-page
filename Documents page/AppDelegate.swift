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

extension UIApplication {
    static var statusBarFrame: CGRect {
        let window = shared.windows.filter { $0.isKeyWindow }.first
        let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
        return statusBarFrame
    }
    static func topViewController(base: UIViewController? = ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            if let presented = selected.presentedViewController {
                return topViewController(base: presented)
            } else {
                return tab
            }

        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
