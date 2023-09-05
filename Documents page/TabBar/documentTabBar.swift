
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
            let imageNames = ["bookmark", "doc", "check"]
            
            for (index, tabBarItem) in items.enumerated() {
                if let originalImage = UIImage(named: imageNames[index]) {
                    let targetSize = CGSize(width: 24, height: 24) // Adjust the size as needed
                    
                    let resizedImage = resizeImage(image: originalImage, targetSize: targetSize)
                    
                    // Set different colors for selected and unselected states
                    let selectedColor = UIColor.white
                    let unselectedColor = UIColor.white.withAlphaComponent(0.5)
                    
                    // Create tinted images for selected and unselected states
                    let selectedImage = resizedImage.withTintColor(selectedColor, renderingMode: .alwaysOriginal)
                    let unselectedImage = resizedImage.withTintColor(unselectedColor, renderingMode: .alwaysOriginal)
                    
                    tabBarItem.image = unselectedImage
                    tabBarItem.selectedImage = selectedImage
                }
            }
        }
        
        // Customize the tab bar background color and tints
        tabBar.backgroundColor = .systemBlue
        tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        tabBar.tintColor = UIColor.white
    }

    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage
    }
     
        }
