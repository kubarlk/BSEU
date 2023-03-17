//
//  ScheduleViewDelegate.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

protocol ScheduleViewDelegate: AnyObject {
    func buttonTapped(withTag tag: Int)
}
