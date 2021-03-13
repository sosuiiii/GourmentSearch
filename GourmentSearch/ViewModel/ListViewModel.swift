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
import PKHUD

protocol ListViewModelInput {
    var searchText: AnyObserver<String>{get}
    var search: AnyObserver<String>{get}
    var save: AnyObserver<Shop> {get}
    var delete: AnyObserver<String> {get}
}

protocol ListViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
    var datasource: Observable<[HotPepperResponseDataSource]>{get}
    var hud: Observable<HUDContentType>{get}
    var hide: Observable<Void>{get}
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
    var delete: AnyObserver<String>
    //Output
    var alert: Observable<AlertType?>
    var validatedText: Observable<String>
    var datasource: Observable<[HotPepperResponseDataSource]>
    var hud: Observable<HUDContentType>
    var hide: Observable<Void>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let _alert = PublishRelay<AlertType?>()
        self.alert = _alert.asObservable()
        
        let _validatedText = PublishRelay<String>()
        self.validatedText = _validatedText.asObservable()
        
        let _datasource = PublishRelay<[HotPepperResponseDataSource]>()
        self.datasource = _datasource.asObservable()
        
        let _hud = PublishRelay<HUDContentType>()
        self.hud = _hud.asObservable()
        
        let _hide = PublishRelay<Void>()
        self.hide = _hide.asObservable()
        
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
            _hud.accept(.progress)
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery())
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print("responseCount:\(response.results.shop.count)")
                _hide.accept(Void())
                _datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
            case .error(_):
                _hud.accept(.error)
//                _alert.accept(.unexpectedServerError)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        self.save = AnyObserver<Shop>() { shop in
            let object = ShopObject(shop: shop.element!)
            RealmManager.addEntity(object: object)
            _hud.accept(.success)
            print("EntityList:\(RealmManager.getEntityList(type: ShopObject.self))")
        }
        self.delete = AnyObserver<String>() { name in
            RealmManager.deleteOneObject(type: ShopObject.self, name: name.element!)
        }
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {return self}
    var outputs: ListViewModelOutput {return self}
}
