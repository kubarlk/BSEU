//
//  TeachersViewModel.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

final class TeachersViewModel {
    
    private let dataManager: DataManagerProtocol
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    var teachers: [Teacher] = []
    
    func fetchTeachers(completion: @escaping([Teacher]) -> Void) {
        let currentLanguageCode = Locale.current.languageCode ?? ""
        if currentLanguageCode.lowercased().hasPrefix("ru") {
            dataManager.fetchTeachers { [weak self] teachers in
                self?.teachers = teachers
                completion(teachers)
            }
        } else {
            dataManager.fetchEngTeachers { [weak self] teachers in
                self?.teachers = teachers
                completion(teachers)
            }
        }
    }
}
