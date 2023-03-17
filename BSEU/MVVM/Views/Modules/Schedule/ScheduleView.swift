//
//  ScheduleView.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class ScheduleView: UIView {
    
    private let viewModel = ScheduleViewModel()
    weak var delegate: ScheduleViewDelegate?
    
    let chooseGroupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("chooseGroupButton".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = UIColor(named: "buttonBackGroundColor")
        button.setTitleColor(UIColor(named: "buttonTitleLabelColor"), for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "titleScheduleLabel".localized()
        label.textColor = UIColor(named: "mainTitleLabelColor")
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonShadow() {
        chooseGroupButton.layer.cornerRadius = 16
        chooseGroupButton.layer.shadowColor = UIColor(named: "buttonShadowColor")?.cgColor
        chooseGroupButton.layer.shadowOpacity = 1
        chooseGroupButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        chooseGroupButton.layer.shadowRadius = 4
        chooseGroupButton.layer.masksToBounds = false
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        setupGroupButton()
        setupLabels()
        setupConstraints()
    }
    
    private func setupGroupButton() {
        chooseGroupButton.tag = 1
        addSubview(chooseGroupButton)
        chooseGroupButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupLabels() {
        addSubview(titleLabel)
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Notify delegate that the button was tapped
            self.delegate?.buttonTapped(withTag: sender.tag)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            //            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            //chooseGroupButton
            chooseGroupButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            chooseGroupButton.heightAnchor.constraint(equalToConstant: 44),
            chooseGroupButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            chooseGroupButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chooseGroupButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}

