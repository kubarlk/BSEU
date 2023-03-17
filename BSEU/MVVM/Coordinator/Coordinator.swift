//
//  Coordinator.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    private(set) var navigationController = UINavigationController()
    private var childViewControllers: [UIViewController] = []
    private weak var window: UIWindow?
    
    func start(window: UIWindow?) {
        navigationController = .init(rootViewController: LoadingAppViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        checkAuthority()
    }
    
    // MARK: - Check Authentification
    private func checkAuthority() {
        showMainTabBarViewController()
    }
    
    //MARK: Selectors
    // Write logic for SignIn and SignOut
    @objc private func showAuth() {
        if let tabBarVC = childViewControllers.first as? TabBarController {
            tabBarVC.viewControllers?.forEach { $0.dismiss(animated: true) }
            tabBarVC.dismiss(animated: true)
        }
        checkAuthority()
    }
    
    //MARK: SignIn methods
    private func showMainTabBarViewController() {
        cleanChildViewControllers()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let tabBarViewController = TabBarController.newInstanse()
            tabBarViewController.modalPresentationStyle = .fullScreen
            
            self.childViewControllers = [tabBarViewController]
            self.navigationController.present(tabBarViewController, animated: true)
        }
    }

    // MARK: - Clean ChildViewControllers
    private func cleanChildViewControllers() {
        childViewControllers = []
        navigationController.dismiss(animated: true)
    }
    
}
