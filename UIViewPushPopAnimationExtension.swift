//
//  UIViewPushPopAnimationExtension.swift
//  HeroExample
//
//  Created by hanwe lee on 2020/09/18.
//

import UIKit

extension UIView {
    enum UIViewSlidePushDirection {
        case left
        case right
    }
    
    func slidePush(duration: TimeInterval = 0.3, completionDelegate: AnyObject? = nil,direction:UIViewSlidePushDirection,completeHandler:@escaping () -> ()) {
        
        self.alpha = 0.4
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: {[weak self] (finished: Bool) -> Void in
            completeHandler()
        })
        let slidePushTransition = CATransition()
        if let delegate: AnyObject = completionDelegate {
            slidePushTransition.delegate = delegate as? CAAnimationDelegate
        }
        slidePushTransition.type = CATransitionType.push
        var subType:CATransitionSubtype = .fromRight
        switch direction {
        case .left:
            subType = .fromLeft
            break
        case .right:
            subType = .fromRight
            break
        }
        slidePushTransition.subtype = subType
        slidePushTransition.duration = duration
        slidePushTransition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        slidePushTransition.fillMode = CAMediaTimingFillMode.removed
        slidePushTransition.startProgress = 0.85
        self.layer.add(slidePushTransition, forKey: "slidePushTransition")
    }
    
}
