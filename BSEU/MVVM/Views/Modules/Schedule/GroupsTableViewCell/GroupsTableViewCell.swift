//
//  GroupsTableViewCell.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

final class GroupsTableViewCell: UITableViewCell {
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "cellGroupLabelColor")
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(named: "cellBackGroundColor")
        self.mainView.backgroundColor = UIColor(named: "cellMainViewColor")
        self.mainView.layer.cornerRadius = mainView.frame.height/2
        self.mainView.layer.shadowColor = UIColor(named: "cellMainViewShadow")?.cgColor
        self.mainView.layer.shadowOpacity = 1
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.mainView.layer.shadowRadius = 4
        self.mainView.layer.masksToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(mainView)
        mainView.addSubview(groupLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //groupLabel
            groupLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            groupLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5),
            groupLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -5),
            groupLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            //mainView
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}

extension GroupsTableViewCell: Configurable {
    func configure(with presentationObject: Any) {
        guard let teacher = presentationObject as? Item else { return }
        groupLabel.text = teacher.name
    }
}

