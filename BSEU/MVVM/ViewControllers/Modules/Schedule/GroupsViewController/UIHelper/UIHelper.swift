//
//  UIHelper.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class UIHelper {
    static let shared = UIHelper()
    
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "bgColor")
        return view
    }
    
    func makeFlatView(alpha: CGFloat = 1) -> UIView {
        let flatView = UIView()
        flatView.backgroundColor = UIColor(named: "stripeColor")
        flatView.translatesAutoresizingMaskIntoConstraints = false
        flatView.alpha = alpha
        return flatView
    }
    
    func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(named: "optionColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "bgColor")
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }
}

