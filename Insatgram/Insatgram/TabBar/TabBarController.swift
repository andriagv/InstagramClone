//
//  TabBarController.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        self.delegate = self
    }
    
    private func configureTabs() {
        let vc1 = MainPageViewController()
        let vc2 = SearchPageViewController()
        let vc3 = UIViewController()
        let vc4 = LikesPageViewController()
        let vc5 = ProfilePageViewController()
        
        vc1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "HomeFill")?.withRenderingMode(.alwaysOriginal))
        vc2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Search")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "SearchFill")?.withRenderingMode(.alwaysOriginal))
        vc3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "AddPost")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "AddPost")?.withRenderingMode(.alwaysOriginal))
        vc4.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Heart")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "HeartFill")?.withRenderingMode(.alwaysOriginal))
        vc5.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Profile")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "Profile")?.withRenderingMode(.alwaysOriginal))
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: true)
        self.tabBar.isTranslucent = false
    }
}
