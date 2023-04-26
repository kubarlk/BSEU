//
//  ScheduleViewModel.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class ScheduleViewModel {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    var lessonsGrouped: [LessonsGrouped] = []
    
    func fetchSchedule(with id: String, completion: @escaping () -> Void) {
        dataManager.fetchSchedule(with: id) { [weak self] lessonsGrouped in
            self?.lessonsGrouped = lessonsGrouped
            completion()
        }
    }
    
    func fetchEngSchedule(with id: String, competion: @escaping() -> Void) {
        dataManager.fetchEngSchedule(with: id) { [weak self] lessonsGrouped in
            self?.lessonsGrouped = lessonsGrouped
            competion()
        }
    }
}
