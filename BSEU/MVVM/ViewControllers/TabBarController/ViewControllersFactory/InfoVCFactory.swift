//
//  InfoVCFactory.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class InfoVCFactory {
    static func infoVC() -> UIViewController {
        let storyboard = UIStoryboard(name: "Info", bundle: nil)
        guard let navController = storyboard.instantiateViewController(identifier: "infoVC") as? UINavigationController,
            let vc = navController.topViewController as? InfoViewController
        else {
            return UIViewController()
        }
        vc.tabBarItem = UITabBarItem(title: "infoItem".localized(), image: UIImage(systemName: "info.square"), selectedImage: UIImage(systemName: "info.square.fill"))
        let viewModel = InfoViewModel()
        vc.viewModel = viewModel
        return navController
    }
}
