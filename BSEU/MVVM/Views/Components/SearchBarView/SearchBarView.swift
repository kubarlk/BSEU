//
//  SearchBarView.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

final class SearchBarView: UIView {
    
    weak var delegate: SearchBarViewDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.layer.borderColor = UIColor(named: "textFieldBorderColor")?.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 12
        textField.placeholder = "textFieldPlaceholder".localized()
        textField.tintColor = UIColor(named: "textFieldTintColor")
        textField.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(named: "bgColor")
    }
    
    private func setupViews() {
        setupTextField()
        setupConstraints()
    }
    
    private func setupTextField() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
            delegate?.searchBarView(self, didChangeText: textField.text ?? "")
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
}


