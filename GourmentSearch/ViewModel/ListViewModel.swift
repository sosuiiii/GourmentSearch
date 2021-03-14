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
    @AnyObserverWrapper var searchText: AnyObserver<String>
    @AnyObserverWrapper var search: AnyObserver<String>
    @AnyObserverWrapper var save: AnyObserver<Shop>
    @AnyObserverWrapper var delete: AnyObserver<String>
    //Output
    @PublishRelayWrapper var alert: Observable<AlertType?>
    @PublishRelayWrapper var validatedText: Observable<String>
    @PublishRelayWrapper var datasource: Observable<[HotPepperResponseDataSource]>
    @PublishRelayWrapper var hud: Observable<HUDContentType>
    @PublishRelayWrapper var hide: Observable<Void>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        
        $search.flatMapLatest({ text -> Observable<Event<HotPepperResponse>> in
            self.$hud.accept(.progress)
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery()).materialize()
        }).subscribe({ event in
            switch event.element! {
            case .next(let response):
                print("responseCount:\(response.results.shop.count)")
                self.$hide.accept(Void())
                self.$datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
            case .error(_):
                self.$hud.accept(.error)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        let _  = $searchText.subscribe({ text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            if textOver.0 == nil {return}
            self.$validatedText.accept(textOver.0!)
            if textOver.1 == nil {return}
            self.$alert.accept(textOver.1)
        }).disposed(by: disposeBag)
        
        let _ = $save.subscribe({ shop in
            let object = ShopObject(shop: shop.element!)
            RealmManager.addEntity(object: object)
            self.$hud.accept(.success)
            print("EntityList:\(RealmManager.getEntityList(type: ShopObject.self))")
        }).disposed(by: disposeBag)
        
        let _ = $delete.subscribe({ name in
            RealmManager.deleteOneObject(type: ShopObject.self, name: name.element!)
        }).disposed(by: disposeBag)
    }
}

extension ListViewModel: ListViewModelType {
    var inputs: ListViewModelInput {return self}
    var outputs: ListViewModelOutput {return self}
}
