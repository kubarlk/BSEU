//
//  ScheduleTableViewCell.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    static let cellIdentifier = "ScheduleTableViewCell"
    
    let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let numberOfPairLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    let audienceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(named: "labelColor")
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
        self.mainView.layer.cornerRadius = 20
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
        mainView.addSubview(numberOfPairLabel)
        mainView.addSubview(audienceLabel)
        mainView.addSubview(subjectLabel)
        mainView.addSubview(typeLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            numberOfPairLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            numberOfPairLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            numberOfPairLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            
            audienceLabel.topAnchor.constraint(equalTo: numberOfPairLabel.bottomAnchor, constant: 8),
            audienceLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            audienceLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            
            subjectLabel.topAnchor.constraint(equalTo: audienceLabel.bottomAnchor, constant: 8),
            subjectLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            subjectLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            
            typeLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            typeLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            typeLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setAttributedText(for label: UILabel, boldText: String, normalText: String) {
        let attrsBold = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold)]
        let attrsNorm = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrsBold)
        let normalString = NSMutableAttributedString(string: normalText, attributes: attrsNorm)

        attributedString.append(normalString)
        label.attributedText = attributedString
    }

   
    
    func configure(with lessonsGrouped: [LessonsGrouped],for indexPath: IndexPath) {
        let lesson = lessonsGrouped[indexPath.section].lessons[indexPath.row]
    
        let lessonTime = LessonTime(rawValue: lesson.numberOfPair)
      
//        let pairBoldText = "\("numberOfPairLabel".localized()): "
        let pairBoldText = "\("🕒")  "
        let pairNormalText = "\(lessonTime?.stringValue ?? "")"
        
//        let audienceBoldText = "\("audienceLabel".localized()): "
        let audienceBoldText = "\("🏢")  "
        let audienceNormalText = "\(lesson.audience)"
        
//        let subjectBoldText = "\("subjectLabel".localized()): "
        let subjectBoldText = "\("📓")  "
        let subjectNormalText = "\(lesson.subject)"
        
//        let typeBoldText = "\("typeLabel".localized()): "
        let typeBoldText = "\("🔔")  "
        let typeNormalText = "\(lesson.type)"

        setAttributedText(for: numberOfPairLabel, boldText: pairBoldText, normalText: pairNormalText)
        setAttributedText(for: audienceLabel, boldText: audienceBoldText, normalText: audienceNormalText)
        setAttributedText(for: subjectLabel, boldText: subjectBoldText, normalText: subjectNormalText)
        setAttributedText(for: typeLabel, boldText: typeBoldText, normalText: typeNormalText)
    }
}

enum LessonTime: Int, CaseIterable {
    case first = 1
    case second = 2
    case third = 3
    case fourth = 4
    case fifth = 5
    case sixth = 6
    case seventh = 7
    case eighth = 8
    case nine = 9
    
    var stringValue: String {
        switch self {
        case .first:
            return "8:15 - 9:35"
        case .second:
            return "9:45 - 11:05"
        case .third:
            return "11:15 - 12:35"
        case .fourth:
            return "13:05 - 14:25"
        case .fifth:
            return "14:35 - 15:55"
        case .sixth:
            return "16:05 - 17:25"
        case .seventh:
            return "17:45 - 19:05"
        case .eighth:
            return "19:15 - 20:35"
        case .nine:
            return "20:40 - 22:00"
        }
    }
}
