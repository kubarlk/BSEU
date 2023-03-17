//
//  University.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

struct University: Codable {
    var faculties: [Faculty]?
    var forms: [Form]?
    var groups: [Group]?
}
