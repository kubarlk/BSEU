//
//  TeachersTableViewCell.swift
//  BSEUapp
//
//  Created by Kirill Kubarskiy on 16.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

final class TeachersTableViewCell: UITableViewCell {
    @IBOutlet weak var positionAndDegreeLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor(named: "cellBackGroundColor")
        self.mainView.backgroundColor = UIColor(named: "cellMainViewColor")
        self.mainView.layer.cornerRadius = 20
        self.mainView.layer.shadowColor = UIColor(named: "cellMainViewShadow")?.cgColor
        self.mainView.layer.shadowOpacity = 1
        self.mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.mainView.layer.shadowRadius = 4
        self.mainView.layer.masksToBounds = false
        self.arrowImage.tintColor = UIColor(named: "arrowImageColor")
        self.arrowView.backgroundColor = UIColor(named: "cellMainViewColor")
        self.urlImage.clipsToBounds = false
        self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(named: "cellGroupLabelColor")
        positionAndDegreeLabel.textColor = UIColor(named: "cellGroupLabelColor")
        positionAndDegreeLabel.sizeToFit()
    }
}

extension TeachersTableViewCell: Configurable {
    func configure(with presentationObject: Any) {
        guard let teacher = presentationObject as? Teacher else { return }
        titleLabel.text = teacher.name
        let image = UIImage(named: "\(teacher.pictureURL)")
        urlImage.image = image
        positionAndDegreeLabel.text = teacher.positionAndDegree
    }
}

