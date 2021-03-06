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
    var datasource: Observable<[HotPepperResponseDataSource]>{get}
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
        
        //materialzieを使わないとエラーで購読破棄される
        _search.flatMapLatest({ text -> Observable<Event<HotPepperResponse>> in
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery()).materialize()
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print(response)
                _datasource.accept([HotPepperResponseDataSource(items: (response.element?.results.shop)!)])
            case .error(_):
                _alert.accept(.unexpectedServerError)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {return self}
    var outputs: ListViewModelOutput {return self}
}
