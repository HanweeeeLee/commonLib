//
//  ViewController.swift
//  SplashViewTest
//
//  Created by hanwe on 2021/01/17.
//

import UIKit

class ViewController: UIViewController, SplashViewProtocol {
    
    @IBOutlet var mainContainerView: UIView!
    
    weak var targetView: UIView?
    var attachedView: UIView? = SplashView.instance()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.targetView = self.mainContainerView
    }

    @IBAction func testStart(_ sender: Any) {
        self.showSplashView(completion: {
            print("쇼우 끝")
        })
        DispatchQueue.global().async {
            usleep(5 * 1000 * 1000)
            DispatchQueue.main.async {
                self.hideSplashView(completion: {
                    print("하이드 끝")
                })
            }
        }
    }
}

