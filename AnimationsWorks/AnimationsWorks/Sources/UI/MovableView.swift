//
//  MovableView.swift
//  AnimationsWorks
//
//  Created by Pavel Bondar on 2/24/17.
//  Copyright © 2017 Pavel Bondar. All rights reserved.
//

import UIKit

class MovableView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0
                && subview.isUserInteractionEnabled
                && subview.point(inside: convert(point, to: subview), with: event)
            {
                return true
            }
        }
        
        return false
    }
}
