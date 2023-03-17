//
//  GroupsViewControllerDelegate.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 18.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

protocol GroupsViewControllerDelegate: AnyObject {
    func didSelectCell(withData data: Item)
}
