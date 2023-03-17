//
//  TabBarController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    static func newInstanse() -> UIViewController {
        let tabBarViewController = TabBarController()

        return UINavigationController(rootViewController: tabBarViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func createTabs() -> [UIViewController] {
        [
            ScheduleVCFactory.scheduleVC(),
            TeachersVCFactory.teachersVC(),
            InfoVCFactory.infoVC()
        ]
    }
    
    private func setupTabs() {
        self.tabBar.isHidden = true
        viewControllers = createTabs()
        
        self.tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "tabBarAppearanceColor")
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        self.tabBar.isHidden = false
    }
}

