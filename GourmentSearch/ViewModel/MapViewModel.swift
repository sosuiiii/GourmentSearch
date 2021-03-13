//
//  MapViewModel.swift
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

protocol MapViewModelInput {
    var searchText: AnyObserver<String>{get}
    var search: AnyObserver<String>{get}
    var location: AnyObserver<(String, String)> {get}
    var save: AnyObserver<Shop> {get}
}

protocol MapViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
    var datasource: Observable<[HotPepperResponseDataSource]>{get}
    var showCell: Observable<Void>{get}
    var direction: Observable<Direction>{get}
    var hud: Observable<HUDContentType>{get}
    var hide: Observable<Void> {get}
}

protocol MapViewModelType {
    var inputs: MapViewModelInput {get}
    var outputs: MapViewModelOutput {get}
    
}

class MapViewModel: MapViewModelInput, MapViewModelOutput {
    
    //Input
    @AnyObserverWrapper var searchText: AnyObserver<String>
    @AnyObserverWrapper var search: AnyObserver<String>
    @AnyObserverWrapper var location: AnyObserver<(String, String)>
    @AnyObserverWrapper var save: AnyObserver<Shop>
    //Output
    @PublishRelayWrapper var alert: Observable<AlertType?>
    @PublishRelayWrapper var validatedText: Observable<String>
    @PublishRelayWrapper var datasource: Observable<[HotPepperResponseDataSource]>
    @PublishRelayWrapper var showCell: Observable<Void>
    @PublishRelayWrapper var direction: Observable<Direction>
    @PublishRelayWrapper var hud: Observable<HUDContentType>
    @PublishRelayWrapper var hide: Observable<Void>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        
        let _ = $searchText.subscribe({ text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            if textOver.0 == nil { return }
            self.$validatedText.accept(textOver.0!)
            if textOver.1 == nil {return}
            self.$alert.accept(textOver.1)
        }).disposed(by: disposeBag)
        
        let _ = $search.flatMapLatest({ text -> Observable<HotPepperResponse> in
            self.$hud.accept(.progress)
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery())
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print("responceCount:\(response.results.shop.count)")
                self.$datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
                self.$showCell.accept(Void())
                self.$hide.accept(Void())
            case .error(_):
                self.$hud.accept(.error)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        let _ = $location.flatMapLatest({ startEnd  -> Observable<Direction> in
            return try Repository.direction(start: startEnd.0, goal: startEnd.1)
        }).subscribe({ event in
            switch event {
            case .next(let direction):
                self.$direction.accept(direction)
                print(direction)
            case .error(let error):
                print(error)
                self.$alert.accept(.error)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        
        
        let _ = $save.subscribe({ shop in
            let object = ShopObject(shop: shop.element!)
            RealmManager.addEntity(object: object)
            print("EntityList:\(RealmManager.getEntityList(type: ShopObject.self))")
            self.$hud.accept(.success)
        }).disposed(by: disposeBag)
    }
}

extension MapViewModel: MapViewModelType {
    var inputs: MapViewModelInput {return self}
    var outputs: MapViewModelOutput {return self}
}
