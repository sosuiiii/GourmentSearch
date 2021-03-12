//
//  ModalViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol ModalViewModelInput {
    var save: AnyObserver<Shop>{get}
    var waySearch: AnyObserver<Shop>{get}
}

protocol ModalViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
    var datasource: Observable<[HotPepperResponseDataSource]>{get}
}

protocol ModalViewModelType {
    var inputs: ModalViewModelInput {get}
    var outputs: ModalViewModelOutput {get}
}

class ModalViewModel: ModalViewModelInput, ModalViewModelOutput {
    
    //Input
    var save: AnyObserver<Shop>
    var waySearch: AnyObserver<Shop>
    //Output
    var alert: Observable<AlertType?>
    var validatedText: Observable<String>
    var datasource: Observable<[HotPepperResponseDataSource]>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let _alert = PublishRelay<AlertType?>()
        self.alert = _alert.asObservable()
        
        let _validatedText = PublishRelay<String>()
        self.validatedText = _validatedText.asObservable()
        
        let _datasource = PublishRelay<[HotPepperResponseDataSource]>()
        self.datasource = _datasource.asObservable()
        
        self.save = AnyObserver<Shop>() { shop in
        }
        
        let _waySearch = PublishRelay<Shop>()
        self.waySearch = AnyObserver<Shop>() { shop in
        }
        
        _waySearch.subscribe({ shop in
             
        }).disposed(by: disposeBag)
    }
}

extension ModalViewModel: ModalViewModelType {
    var inputs: ModalViewModelInput {return self}
    var outputs: ModalViewModelOutput {return self}
}
