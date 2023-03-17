//
//  Group.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

struct Group: Codable {
    var name: String
    var listItem: [Item]?
    var listGroup: [Group]?
}
