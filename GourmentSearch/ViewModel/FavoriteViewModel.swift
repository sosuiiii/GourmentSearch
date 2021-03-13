//
//  FavoriteViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/12.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD


protocol FavoriteViewModelInput {
    var updateFavorite: AnyObserver<Void> {get}
    var delete: AnyObserver<String> {get}
}

protocol FavoriteViewModelOutput {
    var dataSource: Observable<[FavoriteShopDataSource]>{get}
    var hud: Observable<HUDContentType>{get}
}

protocol FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {get}
    var outputs: FavoriteViewModelOutput {get}
}

class FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput {
    
    //Input
    @AnyObserverWrapper var updateFavorite: AnyObserver<Void>
    @AnyObserverWrapper var delete: AnyObserver<String>
    //Output
    var dataSource: Observable<[FavoriteShopDataSource]>
    @PublishRelayWrapper var hud: Observable<HUDContentType>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let objects = RealmManager.getEntityList(type: ShopObject.self)
        var obj:[ShopObject] = []
        for object in objects {
            obj.append(object)
        }
        let datasource = [FavoriteShopDataSource(items: obj)]
        
        //レルムのお気に入りリストを流す
        let _dataSource = BehaviorRelay<[FavoriteShopDataSource]>(value: datasource)
        dataSource = _dataSource.asObservable()
        
        //お気に入り削除
        let _ = $delete.subscribe({ name in
            RealmManager.deleteOneObject(type: ShopObject.self, name: name.element!)
            let objects = RealmManager.getEntityList(type: ShopObject.self)
            var obj:[ShopObject] = []
            for object in objects {
                obj.append(object)
            }
            let datasource = [FavoriteShopDataSource(items: obj)]
            self.$hud.accept(.success)
            _dataSource.accept(datasource)
        }).disposed(by: disposeBag)
        
        //お気に入り削除後に削除後のデータを流す
        let _ = $updateFavorite.subscribe({ _ in
            let objects = RealmManager.getEntityList(type: ShopObject.self)
            var obj:[ShopObject] = []
            for object in objects {
                obj.append(object)
            }
            let datasource = [FavoriteShopDataSource(items: obj)]
            _dataSource.accept(datasource)
        }).disposed(by: disposeBag)
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {return self}
    var outputs: FavoriteViewModelOutput {return self}
}
