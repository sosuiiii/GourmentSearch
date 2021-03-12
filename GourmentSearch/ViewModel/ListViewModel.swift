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
    var save: AnyObserver<Shop> {get}
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
    var save: AnyObserver<Shop>
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
            if textOver.0 == nil {return}
            _validatedText.accept(textOver.0!)
            if textOver.1 == nil {return}
            _alert.accept(textOver.1)
        }
        
        let _search = PublishRelay<String>()
        self.search = AnyObserver<String>() { text in
            _search.accept(text.element!)
        }
        _search.flatMapLatest({ text -> Observable<HotPepperResponse> in
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery())
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print("responseCount:\(response.results.shop.count)")
                _datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
            case .error(_):
                _alert.accept(.unexpectedServerError)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        self.save = AnyObserver<Shop>() { shop in
            let object = ShopObject(shop: shop.element!)
            RealmManager.addEntity(object: object)
            print("EntityList:\(RealmManager.getEntityList(type: ShopObject.self))")
        }
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {return self}
    var outputs: ListViewModelOutput {return self}
}
