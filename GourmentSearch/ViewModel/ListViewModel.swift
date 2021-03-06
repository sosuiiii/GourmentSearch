//
//  ListViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol ListViewModelInput {
    var searchText: AnyObserver<String>{get}
    var search: AnyObserver<String>{get}
}

protocol ListViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
}

protocol ListViewModelType {
    var inputs: ListViewModelInput {get}
    var outputs: ListViewModelOutput {get}
}

class ListViewModel: ListViewModelInput, ListViewModelOutput {
    
    //Input
    var searchText: AnyObserver<String>
    var search: AnyObserver<String>
    //Output
    var alert: Observable<AlertType?>
    var validatedText: Observable<String>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let _alert = PublishRelay<AlertType?>()
        self.alert = _alert.asObservable()
        
        let _validatedText = PublishRelay<String>()
        self.validatedText = _validatedText.asObservable()
        
        self.searchText = AnyObserver<String>() { text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            _validatedText.accept(textOver.0)
            if textOver.1 == nil {return}
            _alert.accept(textOver.1)
        }
        
        let _search = PublishRelay<String>()
        self.search = AnyObserver<String>() { text in
            _search.accept(text.element!)
        }
        self.search = AnyObserver<String>() { text in
            
        }
        _search.flatMapLatest({ text -> Observable<HotPepperResponse> in
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: text)
            return Repository.search(keyValue: shared.getQuery())
        }).subscribe(onNext: { response in
            
        }, onError: { error in
            _alert.accept(.searchError)
        }).disposed(by: disposeBag)
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {return self}
    var outputs: ListViewModelOutput {return self}
}
