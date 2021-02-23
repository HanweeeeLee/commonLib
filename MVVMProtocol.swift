//
//  MVVMProtocol.swift
//  mvvmTest
//
//  Created by hanwe on 2021/02/08.
//  Copyright © 2021 hanwe All rights reserved.
//

import RxSwift

protocol MVVMViewController: class {
    associatedtype MVVMViewModelClassType: MVVMViewModel
    associatedtype SelfType: MVVMViewController
    
    var disposeBag: DisposeBag { get set }
    var isViewModelBinded: Bool { get set }
    var viewModel: MVVMViewModelClassType! { get set }
    
    func bind(viewModel: MVVMViewModel)
    func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T
    
    static func makeViewController(viewModel: MVVMViewModelClassType) -> SelfType?
}

extension MVVMViewController {
    @discardableResult func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T {
        bind(viewModel: viewModel)
        viewModel.subscribeInputs()
        self.isViewModelBinded = true
        return viewModel
    }
}

protocol MVVMView: class {
    associatedtype MVVMViewModelClassType: MVVMViewModel
    associatedtype SelfType: MVVMView
    
    var disposeBag: DisposeBag { get set }
    var isViewModelBinded: Bool { get set }
    var viewModel: MVVMViewModelClassType! { get set }
    
    func bind(viewModel: MVVMViewModel)
    func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T
    
    static func makeView(viewModel: MVVMViewModelClassType) -> SelfType?
}

extension MVVMView {
    @discardableResult func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T {
        bind(viewModel: viewModel)
        viewModel.subscribeInputs()
        self.isViewModelBinded = true
        return viewModel
    }
}

protocol MVVMViewModel: class {
    var disposeBag: DisposeBag { get set }
    
    func subscribeInputs()
}

