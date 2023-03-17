//
//  UIActivityIndicatorView+Extension.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func scale(factor: CGFloat) {
        guard factor > 0.0 else { return }
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}
