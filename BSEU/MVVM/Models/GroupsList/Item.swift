//
//  Item.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

struct Item: Codable, Equatable {
    var id: String
    var name: String
    var number: Int
}

extension Item {
    init?(from object: Any, key: String) throws {
        guard let array = object as? [Any],
                array.count == 2,
              let name = array[0] as? String,
              let number = array[1] as? Int else {
            return nil
        }
        self.name = name
        self.number = number
        self.id = key
    }
}
