//
//  ScheduleViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit
import Lottie

class ScheduleViewController: UIViewController {
    
    private let scheduleView = ScheduleView()
    var viewModel: ScheduleViewModel = ScheduleViewModel()
    private var idGroup: String = ""
    private var groupName: String = ""
    private let animationView = LottieAnimationView(name: "owlAnimation")
    private let owlGreetingView =  LottieAnimationView(name: "owlGreetingAnimation")
    
    private lazy var containerAnimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "bgColor")
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.backgroundColor = UIColor(named: "bgColor")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView?.isUserInteractionEnabled = true
        tableView.isHidden = true
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleView.delegate = self
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !ReachabilityManager.shared.isConnectedToNetwork() {
            presentNetworkVC()
        } else {
            presentSchedule()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scheduleView.setupButtonShadow()
    }
    
    private func presentNetworkVC() {
        let vc = NetworkViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        self.setupAnimation()
    }
    
    private func presentSchedule() {
      guard let group = self.viewModel.fetchGroupID() else {
          return
      }

      if !group.isEmpty {
          self.idGroup = group[0].id
          self.groupName = group[0].name
      }

        let languageCode = Locale.current.languageCode ?? "ru"
        if languageCode == "en" {
            self.viewModel.fetchEngSchedule(with: self.idGroup) {
                DispatchQueue.main.async {
                    if self.viewModel.lessonsGrouped.isEmpty {
                        self.presentAlert(title: "alertTitle".localized(), message: "\("alertMessageFirst".localized()) \(self.groupName) \("alertMessageSecond".localized())")
                        self.setupAnimation()
                    } else {
                        self.owlGreetingView.removeFromSuperview()
                        self.containerAnimView.removeFromSuperview()
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.viewModel.fetchSchedule(with: self.idGroup) {
                DispatchQueue.main.async {
                    if self.viewModel.lessonsGrouped.isEmpty {
                        self.presentAlert(title: "alertTitle".localized(), message: "\("alertMessageFirst".localized()) \(self.groupName) \("alertMessageSecond".localized())")
                        self.setupAnimation()
                    } else {
                        self.owlGreetingView.removeFromSuperview()
                        self.containerAnimView.removeFromSuperview()
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(scheduleView)
        view.addSubview(tableView)
        setupOwlGreetingView()
        setupConstraints()
    }
    
    private func setupOwlGreetingView() {
        view.addSubview(owlGreetingView)
        owlGreetingView.loopMode = .loop
        owlGreetingView.contentMode = .scaleAspectFit
        owlGreetingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            owlGreetingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            owlGreetingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            owlGreetingView.heightAnchor.constraint(equalToConstant: 250),
            owlGreetingView.widthAnchor.constraint(equalToConstant: 250)
        ])
        owlGreetingView.play()
    }
    
    private func setupAnimation() {
        view.addSubview(containerAnimView)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        containerAnimView.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        //Alert
        NSLayoutConstraint.activate([
            //mainView
            containerAnimView.topAnchor.constraint(equalTo: self.scheduleView.bottomAnchor, constant: 0),
            containerAnimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerAnimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerAnimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            //animationView
            animationView.topAnchor.constraint(equalTo: containerAnimView.topAnchor),
            animationView.centerXAnchor.constraint(equalTo: containerAnimView.centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 250),
            animationView.widthAnchor.constraint(equalToConstant: 250),
        ])
        self.tableView.isHidden = true
        animationView.play()
    }
    
    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "alertOk".localized(), style: .default) { (action:UIAlertAction!) in
            self.buttonTapped(withTag: self.scheduleView.chooseGroupButton.tag)
            
        }
        let cancelAction = UIAlertAction(title: "alertCancel".localized(), style: .cancel) { (action:UIAlertAction!) in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // show the alert controller
        present(alertController, animated: true, completion:nil)
    }
    
    private func setupConstraints() {
        scheduleView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //scheduleView
            scheduleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scheduleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scheduleView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            //tableView
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        scheduleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.lessonsGrouped.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lessonsGrouped[section].lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.cellIdentifier, for: indexPath) as? ScheduleTableViewCell else {
            fatalError("Unable to dequeue a reusable cell.")
        }
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
        cell.configure(with: viewModel.lessonsGrouped, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerView.backgroundColor = UIColor(named: "bgColor")
        headerView.addSubview(headerLabel)
        headerLabel.textAlignment = .center
        headerLabel.text = viewModel.lessonsGrouped[section].date
        headerLabel.textColor = UIColor(named: "mainTitleLabelColor")
        headerLabel.font = UIFont(descriptor: UIFontDescriptor.init(name: "Chalkboard SE", size: 25), size: 25)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessons = viewModel.lessonsGrouped[indexPath.section].lessons
        let date = viewModel.lessonsGrouped[indexPath.section].date
        var finalString = "📅  \(date)\n\n"
        lessons.forEach { lesson in
            let numberOfPair = lesson.numberOfPair
            let lessonTime = LessonTime(rawValue: numberOfPair)
            let subject = lesson.subject
            let type = lesson.type
            let audience = lesson.audience
            let pairTime = "\(lessonTime?.stringValue ?? "")"
            
            finalString += "⌚  \(pairTime)\n🏢  \(audience)\n📓  \(subject)\n🔔  \(type)\n\n"
        }
        let activityVC = UIActivityViewController(activityItems: [finalString], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

//MARK: GroupsViewControllerDelegate
extension ScheduleViewController: GroupsViewControllerDelegate {
    func didSelectCell(withData data: Item) {
        self.idGroup = data.id
        self.groupName = data.name
        owlGreetingView.removeFromSuperview()
    }
}

//MARK: Button delegate
extension ScheduleViewController: ScheduleViewDelegate {
    @objc func buttonTapped(withTag tag: Int) {
        switch tag {
        case 1:
            let groupsVC = GroupsViewController()

            groupsVC.delegate = self
            groupsVC.modalPresentationStyle = .fullScreen
            self.present(groupsVC, animated: false)
        default:
            fatalError("Error buttonTapped")
        }
    }
}
