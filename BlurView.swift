//
//  BlurView.swift
//  BlurViewTest
//
//  Created by hanwe lee on 2020/12/30.
//  Copyright © 2020 hanwe. All rights reserved.
//

import UIKit

class BackgroundModeBlurView: UIView {
    
    //MARK: IBOutlet
    
    //MARK: life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    //MARk: internal function
    
    internal func initView() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        makeBlurView()
        self.layer.masksToBounds = true
        self.isHidden = true
    }
    
    //MARk: private function
    
    @objc private func appMovedToBackground() {
        self.isHidden = false
    }
    
    @objc private func appMovedToForeground() {
        self.isHidden = true
    }
    
    private func makeBlurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }

}
