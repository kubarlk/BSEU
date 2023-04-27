//
//  NetworkManager.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    func loadGroups(completion: @escaping(University?) -> Void)
    func loadTeachers(completion: @escaping (Result<[Teacher], Error>) -> Void)
    func loadEngTeachers(completion: @escaping (Result<[Teacher], Error>) -> Void)
    func loadSchedule(with id: String, completion: @escaping ([LessonsGrouped]?) -> Void)
    func loadEngSchedule(with id: String, completion: @escaping ([LessonsGrouped]?) -> Void)
    func fetchItem(from groups: [Group]) -> [Item]
}

final class NetworkManager: NetworkManagerProtocol {
    
    func loadGroups(completion: @escaping(University?) -> Void) {
        
        guard let url = URL(string: "") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let jsonData = data, error == nil else {
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary else {
                return
            }
            
            var faculties: [Faculty] = []
            if let facultiesJson = json["faculties"] as? [String: String] {
                for(key, value) in facultiesJson {
                    let item = Faculty(id: key, name: value)
                    faculties.append(item)
                }
            }
            
            var forms: [Form] = []
            if let formsJson = json["forms"] as? [String: [Any]] {
                for(key, value) in formsJson {
                    if value.count == 2,
                       let description = value[0] as? String,
                       let list = value[1] as? [Int ]{
                        let item = Form(name: key, description: description, list: list)
                        forms.append(item)
                    }
                }
            }
            
            var groups: [Group] = []
            var result: ParseType = .unknown
            if let groupsJson = json["groups"] as? [String: Any] {
                result = self.parse(key: "group", value: groupsJson)
                if case .dictionary(let key, _ , let listGroup) = result,
                   key == "group",
                   let listGroup = listGroup {
                    groups = listGroup
                }
            }
            let model = University(faculties: faculties, forms: forms, groups: groups)
            completion(model)
        }.resume()
    }
    
    private func parse(key: String, value: Any) -> ParseType {
        if let item = try? Item(from: value, key: key) {
            return .item(value: item)
        }
        if let dicionary = value as? [String: Any] {
            var result: [String: Any] = [:]
            var resultArray: [Any] = []
            var listGroup: [Group] = []
            for(key2, value2) in dicionary {
                let _result = parse(key: key2, value: value2)
                if case .item(let item) = _result {
                    resultArray.append(item)
                }
                if case .dictionary(_, let value, let groups) = _result {
                    let group = Group(name: key2, listGroup: groups)
                    listGroup.append(group)
                    result[key2] = value
                }
                
                if case .array(_, let value, let group) = _result {
                    if let group {
                        listGroup.append(group)
                    }
                    result[key2] = value
                }
            }
            if resultArray.count > 0 {
                let listItem = resultArray as? [Item]
                let group = Group(name: key, listItem: listItem)
                return .array(key: key, value: resultArray, group: group)
            } else {
                return .dictionary(key: key, value: result, groups: listGroup)
            }
        }
        return .unknown
    }
    
    func fetchItem(from groups: [Group]) -> [Item] {
        var items = [Item]()
        for group in groups {
            if let groupItems = group.listItem {
                items.append(contentsOf: groupItems)
            }
            if let subGroups = group.listGroup {
                items.append(contentsOf: fetchItem(from: subGroups))
            }
        }
        return items
    }
    //MARK: loadTeachers
    func loadTeachers(completion: @escaping (Result<[Teacher], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "TeachersData", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let teachers = try decoder.decode([Teacher].self, from: data)
                completion(.success(teachers))
            } catch let error {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not find Teachers.json in bundle"])))
        }
    }
    
    func loadEngTeachers(completion: @escaping (Result<[Teacher], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: "TeachersDataEng", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let teachers = try decoder.decode([Teacher].self, from: data)
                completion(.success(teachers))
            } catch let error {
                completion(.failure(error))
            }
        } else {
            completion(.failure(NSError(domain: "com.example.app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not find Teachers.json in bundle"])))
        }
    }
    //MARK: loadSchedule
    func loadSchedule(with id: String, completion: @escaping ([LessonsGrouped]?) -> Void) {
        guard let url = URL(string: "") else {
            completion(nil)
            fatalError("Invalid URL")
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil)
                print("Invalid response")
                return
            }
            
            guard let jsonData = data else {
                completion(nil)
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let lessons = try decoder.decode([Lessons].self, from: jsonData)
                //grouping
                var lessonsGrouped: [LessonsGrouped] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy.MM.dd" // set the date format string
                let groupedLessons = Dictionary(grouping: lessons, by: { dateFormatter.date(from: $0.date)! }) // convert the date strings to Date objects using the date formatter
                let sortedGroupedLessons = groupedLessons.sorted(by: { $0.key < $1.key }) // sort the grouped lessons by date
                for (date, lessons) in sortedGroupedLessons {
                    let dateString = dateFormatter.string(from: date) // convert the Date object back to a string using the date formatter
                    let lessonGrouped = LessonsGrouped(date: dateString, lessons: lessons)
                    lessonsGrouped.append(lessonGrouped)
                }
                print(lessonsGrouped)
                completion(lessonsGrouped)
            } catch {
                completion(nil)
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func loadEngSchedule(with id: String, completion: @escaping ([LessonsGrouped]?) -> Void) {
        guard let url = URL(string: "") else {
            completion(nil)
            fatalError("Invalid URL")
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil)
                print("Invalid response")
                return
            }
            
            guard let jsonData = data else {
                completion(nil)
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let lessons = try decoder.decode([Lessons].self, from: jsonData)
                //grouping
                var lessonsGrouped: [LessonsGrouped] = []
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yy.MM.dd" // set the date format string
                let groupedLessons = Dictionary(grouping: lessons, by: { dateFormatter.date(from: $0.date)! }) // convert the date strings to Date objects using the date formatter
                let sortedGroupedLessons = groupedLessons.sorted(by: { $0.key < $1.key }) // sort the grouped lessons by date
                for (date, lessons) in sortedGroupedLessons {
                    let dateString = dateFormatter.string(from: date) // convert the Date object back to a string using the date formatter
                    let lessonGrouped = LessonsGrouped(date: dateString, lessons: lessons)
                    lessonsGrouped.append(lessonGrouped)
                }
                print(lessonsGrouped)
                completion(lessonsGrouped)
            } catch {
                completion(nil)
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
