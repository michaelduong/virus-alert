//
//  BaseTabBarController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/10/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import SwifterSwift

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavController(viewController: StatsViewController(), title: "Stats", imageName: "stats-icon"),
            createNavController(viewController: UIViewController(), title: "News Feed", imageName: "news-icon"),
            createNavController(viewController: UIViewController(), title: "Settings", imageName: "settings-icon")
        ]
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.setTitleFont(R.font.latoBlack(size: 36)!)
        viewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        return navController
    }
}
