//
//  TopStripeView.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

final class TopStripeView: UIView {
    
    private let topStripeView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "stripeColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(topStripeView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStripeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topStripeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topStripeView.topAnchor.constraint(equalTo: topAnchor),
            topStripeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

