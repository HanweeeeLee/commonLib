//
//  SplashView.swift
//  SplashViewTest
//
//  Created by hanwe on 2021/01/17.
//

import UIKit

class SplashView: UIView {
    
    class func instance() -> SplashView {
        return UINib(nibName: "SplashView", bundle: .main).instantiate(withOwner: nil, options: nil).first as! SplashView
    }
}
