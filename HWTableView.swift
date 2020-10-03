//
//  HWTableViewVer2.swift
//  MyTableViewTest
//
//  Created by hanwe lee on 2020/09/29.
//  Copyright © 2020 hanwe. All rights reserved.
//

import UIKit
import SkeletonView
import SnapKit

@objc protocol HWTableViewDelegate:class {
    @objc optional func hwTableView(_ hwTableVIew: HWTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func hwTableView(_ hwTableVIew: HWTableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func hwTableView(_ hwTableVIew: HWTableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    @objc optional func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    @objc optional func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool
    @objc optional func scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    
    @objc optional func callNextPage(_ scrollView:UIScrollView)
}

@objc protocol HWTableViewDatasource:class {
    func hwTableView(_ hwTableView: HWTableView, numberOfRowsInSection section: Int) -> Int
    func hwTableView(_ hwTableView: HWTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func hwTableViewSekeletonViewCellIdentifier(_ hwTableView: HWTableView) -> String
    func hwTableViewSekeletonViewHeight(_ hwTableView: HWTableView) -> CGFloat
    @objc optional func hwTableViewSekeletonViewCount(_ hwTableView: HWTableView) -> Int
    @objc optional func hwTableView(_ hwtableView: HWTableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    @objc optional func numberOfSections(in hwtableView: HWTableView) -> Int
    @objc optional func hwTableView(_ hwtableView: HWTableView, viewForHeaderInSection section: Int) -> UIView?
    @objc optional func hwTableView(_ hwtableView: HWTableView, heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func hwTableView(_ hwtableView: HWTableView, viewForFooterInSection section: Int) -> UIView?
    @objc optional func hwTableView(_ hwtableView: HWTableView, heightForFooterInSection section: Int) -> CGFloat
    
}

class HWTableView: UIView {
    
    //MARK: public property
    
    public weak var delegate:HWTableViewDelegate?
    public weak var dataSource:HWTableViewDatasource?
    
    public lazy var tableView:UITableView = UITableView(frame: self.bounds)
    public lazy var separatorStype:UITableViewCell.SeparatorStyle = self.tableView.separatorStyle {
        didSet {
            self.tableView.separatorStyle = self.separatorStype
        }
    }
    
    public var callNextPageBeforeOffset:CGFloat = 150
    
    //MARK: private property
    private var isShowDisplayAnimation:Bool = false
    private var reloadFlag:Bool = false
    private let defaultCellHeight:CGFloat = 100
    private var numberOfRows:UInt = 0
    private var noResultView:UIView?
    
    //MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: private func
    
    private func initUI() {
        self.tableView.backgroundColor = .clear
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints{ (make) in
            make.leading.equalTo(self.snp.leading).offset(0)
            make.trailing.equalTo(self.snp.trailing).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.isSkeletonable = true
    }
    
    private func getSkeletonCellBestCount(cellHeight:CGFloat) -> Int {
        var result:Int = 0
        result = Int(self.bounds.height/cellHeight)
        if self.bounds.height.truncatingRemainder(dividingBy: cellHeight) != 0 {
            result += 1
        }
        return result
    }
    
    //MARK: public func
    public func showSkeletonHW() {
        DispatchQueue.main.async { [weak self] in
            self?.isShowDisplayAnimation = false
            self?.tableView.isSkeletonable = true
            self?.showAnimatedGradientSkeleton()
            self?.startSkeletonAnimation()
        }
        
    }

    public func hideSkeletonHW() {
        DispatchQueue.main.async { [weak self] in
            self?.isShowDisplayAnimation = true
            self?.stopSkeletonAnimation()
            self?.hideSkeleton()
            self?.tableView.reloadData() //리로드를 안해주면 데이터가 이상하게 set된다 ㅡㅡ; skeletonview 버그인듯
            self?.reloadFlag = true
        }
    }
    
    public func addNoResultView(_ view:UIView) {
        self.noResultView = view
        guard let subView = self.noResultView else { return }
        self.addSubview(subView)
        subView.superview?.bringSubviewToFront(subView)
        subView.snp.makeConstraints{ (make) in
            make.leading.equalTo(self.snp.leading).offset(0)
            make.trailing.equalTo(self.snp.trailing).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }
        subView.isHidden = true
    }
    
    public func removeNoResultView() {
        self.noResultView = nil
    }
    
    public func showNoResultView(completion:(() -> ())?) {
        DispatchQueue.main.async { [weak self] in
            self?.noResultView?.isHidden = false
            self?.isShowDisplayAnimation = true
            completion?()
        }
    }
    
    public func hideNoResultView(completion:(() -> ())?) {
        DispatchQueue.main.async { [weak self] in
            self?.noResultView?.isHidden = true
            self?.isShowDisplayAnimation = true
            self?.reloadFlag = false
            completion?()
        }
        
    }
    
    //MARK: public func for tableView
    
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func reloadData() {
        self.tableView.reloadData()
    }
    
    public func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

}

extension HWTableView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("willDisplay")
        if self.isShowDisplayAnimation {
            cell.transform = CGAffineTransform(translationX: 0, y: 100 * 1.0)
            cell.alpha = 0
            UIView.animate(
                withDuration: 0.5,
                delay: 0 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
        self.delegate?.hwTableView?(self, willDisplay: cell, forRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print("didEndDisplay")
        if reloadFlag {
            if self.isShowDisplayAnimation {
                self.isShowDisplayAnimation = false
                self.reloadFlag = false
            }
        }
        self.delegate?.hwTableView?(self, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.hwTableView?(self, didSelectRowAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll?(scrollView)
        
        let offset = scrollView.contentOffset;
        let bounds = scrollView.bounds;
        let size = scrollView.contentSize;
        let inset = scrollView.contentInset;
        let y = offset.y + bounds.size.height - inset.bottom;
        let h = size.height;
        if y + self.callNextPageBeforeOffset >= h {
            self.delegate?.callNextPage?(scrollView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.delegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
}

extension HWTableView:SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return self.dataSource?.hwTableViewSekeletonViewCellIdentifier(self) ?? ""
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellHight:CGFloat = self.dataSource?.hwTableViewSekeletonViewHeight(self) ?? 0
        return self.dataSource?.hwTableViewSekeletonViewCount?(self) ?? self.getSkeletonCellBestCount(cellHeight: cellHight)
    }
}

extension HWTableView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfSections?(in: self) ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ds = self.dataSource  else { return 0 }
        self.numberOfRows = UInt(ds.hwTableView(self, numberOfRowsInSection: section))
        return Int(self.numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dataSource!.hwTableView(self, cellForRowAt: indexPath)
//        cell.hideSkeleton()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dataSource?.hwTableView?(self, heightForRowAt: indexPath) ?? self.defaultCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.dataSource?.hwTableView?(self, viewForHeaderInSection: section) ?? nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataSource?.hwTableView?(self, heightForHeaderInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.dataSource?.hwTableView?(self, viewForFooterInSection: section) ?? nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.dataSource?.hwTableView?(self, heightForFooterInSection: section) ?? 0
    }
}
