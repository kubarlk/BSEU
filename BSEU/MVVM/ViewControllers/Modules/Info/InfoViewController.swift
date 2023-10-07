//
//  InfoViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit
import Lottie

class InfoViewController: UIViewController {
    
    var viewModel: InfoViewModel!
    
    private let animationView = LottieAnimationView(name: "info")
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "titleInfoLabel".localized()
        label.textColor = UIColor(named: "mainTitleLabelColor")
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "suggestionLabel".localized()
        label.textColor = UIColor(named: "mainTitleLabelColor")
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "copyrightLabel".localized()
        label.textColor = UIColor(named: "copyrightLabelColor")
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("shareAppButton".localized(), for: .normal)
        button.setTitleColor(UIColor(named: "buttonTitleLabelColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor(named: "buttonBackGroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func buttonTapped() {
        UIView.animate(withDuration: 0.2, animations: {
            self.shareButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.shareButton.transform = .identity
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard  let url = URL(string: "https://apps.apple.com/ru/app/6446797482") else { return }
            let activityVC = UIActivityViewController(activityItems: [
                url
            ], applicationActivities: nil)
            // Present the activity view controller
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(titleLabel)
        view.addSubview(copyrightLabel)
        view.addSubview(shareButton)
        view.addSubview(suggestionLabel)
        view.addSubview(animationView)
        shareButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setupButtonShadow()
        setupInfoAnim()
        setupConstraints()
    }
    
    func setupButtonShadow() {
        shareButton.layer.cornerRadius = 16
        shareButton.layer.shadowColor = UIColor(named: "buttonShadowColor")?.cgColor
        shareButton.layer.shadowOpacity = 1
        shareButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        shareButton.layer.shadowRadius = 4
        shareButton.layer.masksToBounds = false
    }
    
    private func setupInfoAnim() {
        view.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 250),
            animationView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        animationView.play()
    }

    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //copyrightLabel
            copyrightLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            copyrightLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            copyrightLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            //shareButton
            shareButton.heightAnchor.constraint(equalToConstant: 44),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shareButton.bottomAnchor.constraint(equalTo: copyrightLabel.topAnchor, constant: -10),
            
            //suggestionLabel
            suggestionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            suggestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            suggestionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
}

