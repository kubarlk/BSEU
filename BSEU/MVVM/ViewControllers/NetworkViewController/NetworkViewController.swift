//
//  NetworkViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit
import Lottie

final class NetworkViewController: UIViewController {

    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
      super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        setupAnimation()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeWindow))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func closeWindow() {
        // close the window
        dismiss(animated: true)
    }
    
    private func setupAnimation() {
        animationView = .init(name: "connection")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
}
