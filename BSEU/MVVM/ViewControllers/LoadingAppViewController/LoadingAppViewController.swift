//
//  LoadingAppViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit
import Lottie

final class LoadingAppViewController: UIViewController {
    
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
      super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        setupAnimation()
    }
    
    private func setupAnimation() {
        animationView = .init(name: "LoadingAppAnimation")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
}

