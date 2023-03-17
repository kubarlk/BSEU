//
//  Lessons.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

struct Lessons: Codable {
    let date: String
    let numberOfPair: Int
    let audience: String
    let subject: String
    let type: String
    
    enum CodingKeys: Int, CodingKey {
        case date = 0
        case numberOfPair = 1
        case audience = 2
        case subject = 3
        case type = 4
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        date = try container.decode(String.self)
        numberOfPair = try container.decode(Int.self)
        audience = try container.decode(String.self)
        subject = try container.decode(String.self)
        type = try container.decode(String.self)
    }
}
