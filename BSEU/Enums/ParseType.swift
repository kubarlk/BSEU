//
//  ParseType.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

enum ParseType {
    case dictionary(key: String, value: [String: Any], groups: [Group]? = nil)
    case array(key: String, value: [Any], group: Group? = nil)
    case item(value: Item)
    case unknown
}
