//
//  TeachersVCFactory.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class TeachersVCFactory {
    static func teachersVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Teachers", bundle: nil)
        guard let navController = storyboard.instantiateViewController(identifier: "teachersVC") as? UINavigationController,
            let vc = navController.topViewController as? TeachersViewController
        else {
            return UIViewController()
        }
        vc.tabBarItem = UITabBarItem(title: "teachersItem".localized(), image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        let viewModel = TeachersViewModel()
        vc.viewModel = viewModel
        return navController
    }
}
