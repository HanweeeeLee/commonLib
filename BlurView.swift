//
//  BlurView.swift
//  BlurViewTest
//
//  Created by hanwe lee on 2020/12/30.
//  Copyright © 2020 hanwe. All rights reserved.
//

import SnapKit
import Then

protocol SecureInactiveView where Self: UIViewController {
    func registSecureCoverView()
}

private var secureInactiveViewAssociatedObjectKey: Void?

extension SecureInactiveView {
    private var secureCoverView: SecureInactiveCoverView {
        get {
            var coverView = objc_getAssociatedObject(self, &secureInactiveViewAssociatedObjectKey) as? SecureInactiveCoverView
            if coverView == nil {
                coverView = SecureInactiveCoverView()
                objc_setAssociatedObject(self, &secureInactiveViewAssociatedObjectKey, coverView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return coverView ?? SecureInactiveCoverView()
        }
        set {
            objc_setAssociatedObject(self, &secureInactiveViewAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func registSecureCoverView() {
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationDefine.APP_DID_BECOME_ACTIVE_NOTIFICATION_DEFINE), object: nil, queue: nil) { [unowned self] notification in
            becomeActive(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: Notification.Name(NotificationDefine.APP_WILL_RESIGN_ACTIVE_NOTIFICATION_DEFINE), object: nil, queue: nil) { [unowned self] notification in
            resignActive(notification: notification)
        }
        
        self.view.addSubview(secureCoverView)
        self.secureCoverView.snp.makeConstraints {
            $0.edges.equalTo(self.view)
        }
        self.secureCoverView.isHidden = true
    }
    
    private func becomeActive(notification: Notification) {
        self.secureCoverView.isHidden = true
    }
    
    private func resignActive(notification: Notification) {
        self.secureCoverView.isHidden = false
    }
}

class SecureInactiveCoverView: UIView {
    
    // MARK: private UI property
    
    // MARK: internal UI property
    
    // MARK: private property
    
    // MARK: property
    
    // MARK: lifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        makeBlurView()
    }
    
    // MARK: private func
    
    private func makeBlurView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    // MARK: func
}
