//
//  GroupsViewControllerTableViewHelpers.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class GroupsViewControllerTableViewHelpers {
    
    private let viewModel: GroupsViewModel = GroupsViewModel()
    private let groupsTableViewCellIdentifier = "GroupsTableViewCell"
    private let savedGroupsTableViewCellIdentifier = "SavedGroupsTableViewCell"
    private(set) var filteredGroups: [Item] = []
    private(set) var savedGroups: [Item] = []
    private var isDownloadingStarted: Bool = true
    private let tableView: UITableView
    private let savedTableView: UITableView
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(named: "spinnerColor")
        spinner.scale(factor: 2.0)
        return spinner
    }()
    
    init(tableView: UITableView, savedTableView: UITableView) {
        self.tableView = tableView
        self.savedTableView = savedTableView
        guard let items = viewModel.getSavedGroups() else { return }
        items.forEach { item in
            if !savedGroups.contains(item) || savedGroups.isEmpty {
                self.savedGroups.append(item)
            }
        }
    }
    
    func fetchGroups(_ view: UIView) {
        self.tableView.isHidden = true
        guard isDownloadingStarted else { return }
        self.setupDownloadingAnimation(view)
        viewModel.fetchGroups { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filteredGroups = self.viewModel.groups
                self.tableView.isHidden = false
                self.spinner.removeFromSuperview()
                self.isDownloadingStarted = false
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupDownloadingAnimation(_ view: UIView) {
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func registerCell() {
        tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: groupsTableViewCellIdentifier)
    }
    
    func registerSavedCell() {
        savedTableView.register(SavedGroupsTableViewCell.self, forCellReuseIdentifier: savedGroupsTableViewCellIdentifier)
    }
    
    func getNumberOfAllCells() -> Int {
        return filteredGroups.count
    }
    
    func getNumberOfSavedCells() -> Int {
        return savedGroups.count
    }
    
    func getGroup(at index: Int) -> Item {
        return filteredGroups[index]
    }
    
    func getSavedGroup(at index: Int) -> Item {
        return savedGroups[index]
    }
    
    func getAllCell(for indexPath: IndexPath) -> UITableViewCell {
        return getAllGroupCell(for: indexPath)
    }
    
    func getSavedCell(for indexPath: IndexPath) -> UITableViewCell {
        return getSavedGroupCell(for: indexPath)
    }
    
    private func getAllGroupCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupsTableViewCellIdentifier, for: indexPath) as? GroupsTableViewCell else {
            return UITableViewCell()
        }
        setupSelectedView(cell: cell)
        let group = filteredGroups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    private func getSavedGroupCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = savedTableView.dequeueReusableCell(withIdentifier: savedGroupsTableViewCellIdentifier, for: indexPath) as? SavedGroupsTableViewCell else {
            return UITableViewCell()
        }
        setupSavedSelectedView(cell: cell)
        let group = savedGroups[indexPath.row]
        cell.configure(with: group)
        return cell
    }
    
    private func setupSelectedView(cell: GroupsTableViewCell) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
    
    private func setupSavedSelectedView(cell: SavedGroupsTableViewCell) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedView
    }
    
    func deleteGroup(commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = savedGroups[indexPath.row]
            guard indexPath.row < savedGroups.count else { return }
            viewModel.removeSavedGroup(itemToDelete)
            savedGroups.remove(at: indexPath.row)
            savedTableView.deleteRows(at: [indexPath], with: .middle)
            savedTableView.reloadData()
        }
    }
    
    
    func getCellHeight(for indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func filterAllData(with text: String) {
        if text.isEmpty {
            filteredGroups = viewModel.groups
        } else {
            filteredGroups = viewModel.groups.filter { group in
                group.name.localizedCaseInsensitiveContains(text)
            }
        }
        tableView.reloadData()
    }
    
    func filteredSavedData(with text: String) {
        if text.isEmpty {
            savedGroups = viewModel.getSavedGroups() ?? []
        } else {
            savedGroups = viewModel.getSavedGroups()?.filter { group in
                group.name.localizedCaseInsensitiveContains(text)
            } ?? []
        }
        savedTableView.reloadData()
    }
    
    func saveSavedGroup(_ group: Item) {
        guard let savedGroups = viewModel.getSavedGroups() else { return }
        let groupExists = savedGroups.contains { savedGroup in
            savedGroup.id == group.id
        }
        // Save the group if it doesn't exist in the database
        if !groupExists {
            viewModel.saveSavedGroup(group)
        }
    }
}

