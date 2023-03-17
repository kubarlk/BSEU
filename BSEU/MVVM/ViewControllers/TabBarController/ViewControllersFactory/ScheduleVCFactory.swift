//
//  ScheduleVCFactory.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class ScheduleVCFactory {
    static func scheduleVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        guard let navController = storyboard.instantiateViewController(identifier: "scheduleVC") as? UINavigationController,
            let vc = navController.topViewController as? ScheduleViewController
        else {
            return UIViewController()
        }
        vc.tabBarItem = UITabBarItem(title: "scheduleItem".localized(), image: UIImage(systemName: "tablecells"), selectedImage: UIImage(systemName: "tablecells.fill"))
        let viewModel = ScheduleViewModel()
        vc.viewModel = viewModel
        return navController
    }
}
