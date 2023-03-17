//
//  TeachersViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit
import CoreData

class TeachersViewController: UIViewController {
    
    var viewModel: TeachersViewModel!
    private let searchBarView = SearchBarView()
    private(set) var teachers: [Teacher] = []
    private(set) var filteredTeachers: [Teacher] = []
    private var expandedIndexPath: IndexPath?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "titleTeachersLabel".localized()
        label.textColor = UIColor(named: "mainTitleLabelColor")
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "bgColor")
        tableView.register(UINib(nibName: "TeachersTableViewCell", bundle: nil), forCellReuseIdentifier: "TeachersTableViewCell")
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "bgColor")
        fetchTeachers()
        setupViews()
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func fetchTeachers() {
        viewModel.fetchTeachers { teachers in
            self.filteredTeachers = teachers
            self.teachers = teachers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupSelectedView(cell: TeachersTableViewCell) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
    
    private func setupViews() {
        //titleLabel
        view.addSubview(titleLabel)
        //searchBarView
        view.addSubview(searchBarView)
        searchBarView.delegate = self
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        //tableView
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //searchBarView
            searchBarView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 40),
            //tableView
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TeachersViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didChangeText text: String) {
        filteredTeachers = []
        if text == "" {
            filteredTeachers = teachers
        }
        for word in teachers {
            if word.name.uppercased().contains(text.uppercased()) {
                filteredTeachers.append(word)
            }
        }
        self.tableView.reloadData()
    }
    
}

extension TeachersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTeachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TeachersTableViewCell", for: indexPath) as? TeachersTableViewCell else { return UITableViewCell() }
        let teacher = filteredTeachers[indexPath.row]
        cell.configure(with: teacher)
        setupSelectedView(cell: cell)
        if indexPath == expandedIndexPath {
            cell.bottomView.isHidden = false
            cell.arrowImage.image = UIImage(systemName: "chevron.up")
        } else {
            cell.bottomView.isHidden = true
            cell.arrowImage.image = UIImage(systemName: "chevron.down")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == expandedIndexPath {
            expandedIndexPath = nil
        } else {
            expandedIndexPath = indexPath
        }
        tableView.reloadData()
        //amimate
        if let cell = tableView.cellForRow(at: indexPath) as? TeachersTableViewCell {
            UIView.animate(withDuration: 0.3, animations: {
                cell.mainView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    cell.mainView.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == expandedIndexPath {
            return UITableView.automaticDimension
        } else {
            return 70
        }
    }
}
