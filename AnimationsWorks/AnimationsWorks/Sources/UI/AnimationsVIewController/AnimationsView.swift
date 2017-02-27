//
//  AnimationsView.swift
//  AnimationsWorks
//
//  Created by Pavel Bondar on 2/22/17.
//  Copyright © 2017 Pavel Bondar. All rights reserved.
//

import UIKit

enum ViewPosition {
    case visible, hidden
}

fileprivate struct AnitationContants {
    static let leftMultiplier: CGFloat = 3
    static let rightMultiplier: CGFloat = 1.6
    static let velocityValue: CGFloat = 500
    static let fastGestureValue: CGFloat = 0.6
}

class AnimationsView: UIView {
    @IBOutlet weak var movableView: UIView!
    
    private var currentPosition: ViewPosition = .visible
    private var movableViewPosition: CGPoint!
    private var animator: UIViewPropertyAnimator?

    //MARK: -
    //MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.onSwipe(gesture:))))
    }
    
    //MARK: -
    //MARK: Public implementations
    
    func onSwipe(gesture: UIPanGestureRecognizer) {
        let target = movableView
        
        switch gesture.state {
        case .began:
            if animator != nil && animator!.isRunning {
                animator!.stopAnimation(false)
            }
            
            movableViewPosition = target?.frame.origin
        case .changed:
            var translation = gesture.translation(in: self)
            if translation.x <= 0 && currentPosition == .visible { translation.x = 0 }
            target?.frame.origin.x = movableViewPosition!.x + translation.x
        case .ended:
            let v = gesture.velocity(in: self)
            
            let velocity = CGVector(dx: v.x / AnitationContants.velocityValue, dy: v.y / AnitationContants.velocityValue)
            let springParameters = UISpringTimingParameters(mass: 0.5, stiffness: 70, damping: 55, initialVelocity: velocity)
            animator = UIViewPropertyAnimator(duration: 3, timingParameters: springParameters)
            
            animator?.addAnimations { [weak self] in
                self.map { $0.movableView.frame.origin.x = $0.newViewPosition($0.position(with: v)) }
            }
            
            animator?.startAnimation()
        default: break
        }
    }
    
    //MARK: -
    //MARK: Private implementations
    
    private func position(with velocity: CGPoint) -> ViewPosition? {
        let velocityX = velocity.x
        let frame = movableView.frame
        let width = frame.width
        let xPoints = frame.width
        let duration = xPoints / velocityX
        let xValue = frame.origin.x
        
        var position: ViewPosition?
        
        if velocityX > 0 { // swipeLeft
            if currentPosition == .hidden { return .visible }
            if duration < AnitationContants.fastGestureValue { return nil }
            position = xValue > width / AnitationContants.leftMultiplier ? .visible : .hidden
        } else if velocityX < 0 { // swipeRight
            if currentPosition == .visible { return .hidden }
            if duration > -AnitationContants.fastGestureValue { return nil }
            position = xValue < width / AnitationContants.rightMultiplier ? .hidden : .visible
        }

        return position
    }
    
    private func newViewPosition(_ position: ViewPosition?) -> CGFloat {
        var x: CGFloat = 0
        if position ?? currentPosition == .hidden {
            currentPosition = .visible
        } else {
            x = frame.width
            currentPosition = .hidden
        }
        
        return x
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if currentPosition == .hidden {
            movableView.frame.origin.x = frame.width
        }
    }
}
