//
//  MVVMProtocol.swift
//  mvvmTest
//
//  Created by hanwe on 2021/02/08.
//  Copyright © 2021 hanwe All rights reserved.
//

import RxSwift

protocol MVVMViewController: class {
    var disposeBag: DisposeBag { get set }
    var isViewModelBinded: Bool { get set }
    
    func bind(viewModel: MVVMViewModel)
    func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T
}

extension MVVMViewController {
    
    @discardableResult func bindingViewModel<T: MVVMViewModel>(viewModel: T) -> T {
        bind(viewModel: viewModel)
        viewModel.subscribeInputs()
        self.isViewModelBinded = true
        return viewModel
    }
}

protocol MVVMViewModel: class {
    func subscribeInputs()
}
