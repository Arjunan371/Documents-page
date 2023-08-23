//
//  documentTabBar.swift
//  Documents page
//
//  Created by Digival on 18/08/23.
//

import UIKit

class documentTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        forTabBarController()
        self.selectedIndex = 1
//        for tabbarImage in 0..<images.count {
//            items[tabbarImage].image = UIImage(systemName: images[tabbarImage])
//
//        }
   
    }
    func forTabBarController() {
        let documentView = AllDocumentsView()
               let mySessionView = MySessionsViewController()
               let allActionsView = AllActionsViewController()
               
               documentView.title = "Document"
               allActionsView.title = "All Activities"
               mySessionView.title = "My Sessions"
                       
               // Set view controllers for the tab bar controller
               setViewControllers([mySessionView, documentView, allActionsView], animated: false)
               
               // Customize the appearance of the tab bar items
               if let items = tabBar.items {
                   let images = ["book", "doc", "note"]
                   
                   for (index, tabBarItem) in items.enumerated() {
                       if let image = UIImage(systemName: images[index]) {
                           // Set different colors for selected and unselected states
                           let selectedColor = UIColor.white
                           let unselectedColor = UIColor.white.withAlphaComponent(0.5)
                           
                           // Create tinted images for selected and unselected states
                           let selectedImage = image.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
                           let unselectedImage = image.withTintColor(unselectedColor, renderingMode: .alwaysOriginal)

                           tabBarItem.image = unselectedImage
                           tabBarItem.selectedImage = selectedImage

                       }
                   }
               }
               
               // Customize the tab bar background color
        tabBar.backgroundColor = .systemBlue
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        tabBar.tintColor = UIColor.white
        
    }
     
        }
