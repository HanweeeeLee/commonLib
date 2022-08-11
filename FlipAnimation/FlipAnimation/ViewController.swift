//
//  ViewController.swift
//  FlipAnimation
//
//  Created by hanwe on 2021/10/02.
//

import UIKit

class ViewController: UIViewController, HWFlipViewDelegate {
    func flipViewWillFliped(flipView: HWFlipView, foregroundView: UIView, behindeView: UIView, willShow: HWFlipView.FlipType) {
//        print("flipView: \(flipView), foregroundView: \(foregroundView), behindeView: \(behindeView), willShow: \(willShow)")
    }
    
    func flipViewDidFliped(flipView: HWFlipView, foregroundView: UIView, behindeView: UIView, didShow: HWFlipView.FlipType) {
//        print("flipView: \(flipView), foregroundView: \(foregroundView), behindeView: \(behindeView), willShow: \(didShow)")
    }
    
    @IBOutlet weak var btn: UIButton!
    
//    @IBOutlet weak var flipView: HWFlipView!
    
    var flipView: HWFlipView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let front: UIView = UIView()
//        front.backgroundColor = .yellow
//        let back: UIView = UIView()
//        back.backgroundColor = .darkGray
//        self.flipView.setForegroundView(front)
//        self.flipView.setBehindViewView(back)
        
        let front: UIImageView = UIImageView()
        front.image = UIImage(named: "header")
        let back: UIImageView = UIImageView()
        back.image = UIImage(named: "tomato")
        
        self.flipView = HWFlipView(foregroundView: front, behindView: back)
        
        flipView.delegate = self
        
        self.view.addSubview(self.flipView)
        self.flipView.snp.makeConstraints {
            $0.top.equalTo(self.btn.snp.bottom)
            $0.height.width.equalTo(300)
            $0.centerX.equalTo(self.view)
        }
    }
    
    @IBAction func flipAction(_ sender: Any) {
        self.flipView.flip(complition: {
            print("애니메이션 끝")
        })
    }
    

}

