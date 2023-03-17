//
//  GroupsViewController.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController {
    
    var viewModel: GroupsViewModel = GroupsViewModel()
    private let dismissHandler = DismissHandler()
    private let topStripeView = TopStripeView()
    private let searchBarView = SearchBarView()
    private var currentTableType: TableType = .all
    weak var delegate: GroupsViewControllerDelegate?
    private lazy var tableViewHelper = GroupsViewControllerTableViewHelpers(tableView: groupsTableView, savedTableView: savedGroupsTableView)
    private lazy var allView = UIHelper.shared.makeContainerView()
    private lazy var favoritesView = UIHelper.shared.makeContainerView()
    private lazy var groupsTableView = UIHelper.shared.makeTableView()
    private lazy var savedGroupsTableView = UIHelper.shared.makeTableView()
    private lazy var allButton = UIHelper.shared.makeButton(title: "allGroups".localized())
    private lazy var favoritesButton = UIHelper.shared.makeButton(title: "savedGroups".localized())
    private lazy var allFlatView = UIHelper.shared.makeFlatView()
    private lazy var favoritesFlatView = UIHelper.shared.makeFlatView(alpha: 0)
    private var stackView: UIStackView!
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bgColor")
        fetchGroups()
        setupViews()
        buttonsTapped()
        dismissKeyboard()
    }
    //MARK: Private func
    private func swipeTables() {
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(favouritesButtonPressed))
        leftSwipeGestureRecognizer.direction = .left
        self.view.addGestureRecognizer(leftSwipeGestureRecognizer)
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(allButtonPressed))
        rightSwipeGestureRecognizer.direction = .right
        self.view.addGestureRecognizer(rightSwipeGestureRecognizer)

    }
    
    private func buttonsTapped() {
        allButton.addTarget(self, action: #selector(allButtonPressed), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(favouritesButtonPressed), for: .touchUpInside)
        swipeTables()
        dismissVC()
    }
    
    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    //MARK: Actions
    @objc private func allButtonPressed() {
        currentTableType = .all
        allFlatView.alpha = 1
        favoritesFlatView.alpha = 0
        UIView.transition(with: groupsTableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.groupsTableView.isHidden = false
        }
        
        UIView.transition(with: savedGroupsTableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.savedGroupsTableView.isHidden = true
        }
    }

    @objc private func favouritesButtonPressed() {
        currentTableType = .saved
        allFlatView.alpha = 0
        favoritesFlatView.alpha = 1
        UIView.transition(with: savedGroupsTableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.savedGroupsTableView.isHidden = false
        }
        
        UIView.transition(with: groupsTableView, duration: 0.3, options: .transitionCrossDissolve) {
            self.groupsTableView.isHidden = true
        }
    }

    private func fetchGroups() {
        tableViewHelper.fetchGroups(self.view)
    }
    
    private func dismissVC() {
        dismissHandler.delegate = self
        dismissHandler.setupGestureRecognizer(on: view)
    }
    //MARK: Setup UI
    private func setupViews() {
        //topStripeView
        view.addSubview(topStripeView)
        topStripeView.translatesAutoresizingMaskIntoConstraints = false
        //searchBarView
        view.addSubview(searchBarView)
        searchBarView.delegate = self
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        //stackView
        setupStackView()
        //tables
        setupGroupsTableView()
        setupSavedGroupsTableView()
        setupConstraints()
    }
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: [allView, favoritesView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        allView.addSubview(allFlatView)
        allView.addSubview(allButton)
        NSLayoutConstraint.activate([
            allButton.centerXAnchor.constraint(equalTo: allView.centerXAnchor),
            allButton.centerYAnchor.constraint(equalTo: allView.centerYAnchor),
            allFlatView.topAnchor.constraint(equalTo: allButton.bottomAnchor),
            allFlatView.widthAnchor.constraint(equalTo: allButton.widthAnchor),
            allFlatView.centerXAnchor.constraint(equalTo: allButton.centerXAnchor),
            allFlatView.heightAnchor.constraint(equalToConstant: 4)
        ])
        favoritesView.addSubview(favoritesFlatView)
        favoritesView.addSubview(favoritesButton)
        NSLayoutConstraint.activate([
            favoritesButton.centerXAnchor.constraint(equalTo: favoritesView.centerXAnchor),
            favoritesButton.centerYAnchor.constraint(equalTo: favoritesView.centerYAnchor),
            favoritesFlatView.topAnchor.constraint(equalTo: favoritesButton.bottomAnchor),
            favoritesFlatView.widthAnchor.constraint(equalTo: favoritesButton.widthAnchor),
            favoritesFlatView.centerXAnchor.constraint(equalTo: favoritesButton.centerXAnchor),
            favoritesFlatView.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    private func setupGroupsTableView() {
        view.addSubview(groupsTableView)
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        NSLayoutConstraint.activate([
            // groupsTableView
            groupsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            groupsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            groupsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            groupsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        tableViewHelper.registerCell()
        DispatchQueue.main.async {
            self.groupsTableView.reloadData()
        }
    }
    
    private func setupSavedGroupsTableView() {
        view.addSubview(savedGroupsTableView)
        savedGroupsTableView.delegate = self
        savedGroupsTableView.dataSource = self
        NSLayoutConstraint.activate([
            // savedGroupsTableView
            savedGroupsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            savedGroupsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            savedGroupsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            savedGroupsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableViewHelper.registerSavedCell()
        DispatchQueue.main.async {
            self.savedGroupsTableView.reloadData()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // topStripeView
            topStripeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topStripeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topStripeView.heightAnchor.constraint(equalToConstant: 4),
            topStripeView.widthAnchor.constraint(equalToConstant: 40),
            // searchBarView
            searchBarView.topAnchor.constraint(equalTo: topStripeView.bottomAnchor, constant: 20),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 40),
            //stackView
            stackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}


//MARK: Gesture recognizer delegate
extension GroupsViewController: DismissHandlerDelegate {
    func dismissViewController() {
        dismissHandler.animate(view)
        dismiss(animated: false)
    }
}

//MARK: SearchBar delegate
extension GroupsViewController: SearchBarViewDelegate {
    func searchBarView(_ searchBarView: SearchBarView, didChangeText text: String) {
        searchBarView.textField.text = text // Clear the text in the search bar
        
        switch currentTableType {
        case .all:
            tableViewHelper.filterAllData(with: text)
        case .saved:
            tableViewHelper.filteredSavedData(with: text)
        }
    }
}

//MARK: TableView delegate
extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case groupsTableView: return tableViewHelper.getNumberOfAllCells()
        case savedGroupsTableView: return tableViewHelper.getNumberOfSavedCells()
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case groupsTableView: return tableViewHelper.getAllCell(for: indexPath)
        case savedGroupsTableView:  return tableViewHelper.getSavedCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case groupsTableView: return tableViewHelper.getCellHeight(for: indexPath)
        case savedGroupsTableView: return tableViewHelper.getCellHeight(for: indexPath)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case groupsTableView:
            let group = tableViewHelper.getGroup(at: indexPath.row)
            // Check if the group is already in the database
            tableViewHelper.saveSavedGroup(group)
            delegate?.didSelectCell(withData: group)
            dismiss(animated: true)
        case savedGroupsTableView:
            let group = tableViewHelper.getSavedGroup(at: indexPath.row)
            delegate?.didSelectCell(withData: group)
            dismiss(animated: true)
        default:
            print("default")
        }
    }

    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView == savedGroupsTableView
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == savedGroupsTableView {
            tableViewHelper.deleteGroup(commit: editingStyle, forRowAt: indexPath)
        }
    }
}
