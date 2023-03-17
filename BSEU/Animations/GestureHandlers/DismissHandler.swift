//
//  DismissHandler.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation
import UIKit

final class DismissHandler {
    
    weak var delegate: DismissHandlerDelegate?
    
    func setupGestureRecognizer(on view: UIView) {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func respondToGesture() {
        delegate?.dismissViewController()
    }
    
    func animate(_ view: UIView) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        view.window?.layer.add(transition, forKey: nil)
    }
}
