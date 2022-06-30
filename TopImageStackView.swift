//
//  TestStackView.swift
//  StretchStackViewSample
//
//  Created by Hanwe LEE on 2022/06/30.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

@objc protocol TopImageStackViewDelegate: AnyObject {
    @objc optional func topImageShowPercent(_ view: TopImageStackView, percent: Float)
}

class TopImageStackView: UIView {

    // MARK: private UI property
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    private lazy var topImageView = UIImageView().then {
        $0.image = self.topImage
    }
    
    private let stackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
    }
    
    // MARK: private property
    
    weak var delegate: TopImageStackViewDelegate?
    
    // MARK: property
    
    let topImage: UIImage
    let topImageHeight: CGFloat
    
    // MARK: lifeCycle
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(topImage: UIImage, topImageHeight: CGFloat) {
        self.topImage = topImage
        self.topImageHeight = topImageHeight
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setup()
    }
    
    // MARK: private func
    
    private func setup() {
        self.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(self)
        }
        self.scrollView.addSubview(topImageView)
        self.topImageView.snp.makeConstraints {
            $0.left.right.top.equalTo(self.scrollView)
            $0.height.equalTo(self.topImageHeight)
        }
        self.scrollView.addSubview(self.stackView)
        self.stackView.snp.makeConstraints {
            $0.top.equalTo(self.topImageView.snp.bottom)
            $0.left.right.bottom.equalTo(self.scrollView)
            $0.width.equalTo(self.snp.width)
        }
    }
    
    // MARK: func
    
    func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
    
}

extension TopImageStackView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            self.delegate?.topImageShowPercent?(self, percent: 0)
        } else if scrollView.contentOffset.y >= self.topImageHeight {
            self.delegate?.topImageShowPercent?(self, percent: 1)
        } else {
            self.delegate?.topImageShowPercent?(self, percent: Float(scrollView.contentOffset.y / self.topImageHeight))
        }
    }
}

class TopImageStackViewDelegateProxy: DelegateProxy<TopImageStackView, TopImageStackViewDelegate>, DelegateProxyType, TopImageStackViewDelegate {
    
    static func registerKnownImplementations() {
        self.register { (viewController) -> TopImageStackViewDelegateProxy in
            TopImageStackViewDelegateProxy(parentObject: viewController, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: TopImageStackView) -> TopImageStackViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: TopImageStackViewDelegate?, to object: TopImageStackView) {
        object.delegate = delegate
    }
    
}

extension Reactive where Base == TopImageStackView {
    
    var delegate: DelegateProxy<TopImageStackView, TopImageStackViewDelegate> {
        return TopImageStackViewDelegateProxy.proxy(for: self.base)
    }
    
    var showPercent: Observable<Float> {
        return delegate.methodInvoked(#selector(TopImageStackViewDelegate.topImageShowPercent(_:percent:)))
            .map { param in
                return param[1] as? Float ?? 0
            }
    }
    
}
