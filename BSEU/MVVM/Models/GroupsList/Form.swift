//
//  Form.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

struct Form: Codable {
    var name: String
    var description: String
    var list: [Int]
}
