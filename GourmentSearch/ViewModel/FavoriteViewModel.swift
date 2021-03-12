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


protocol FavoriteViewModelInput {
    var updateFavorite: AnyObserver<Void> {get}
    var delete: AnyObserver<String> {get}
}

protocol FavoriteViewModelOutput {
    var dataSource: Observable<[FavoriteShopDataSource]>{get}
}

protocol FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {get}
    var outputs: FavoriteViewModelOutput {get}
}

class FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput {
    
    //Input
    var updateFavorite: AnyObserver<Void>
    var delete: AnyObserver<String>
    //Output
    var dataSource: Observable<[FavoriteShopDataSource]>
    
    init() {
        let objects = RealmManager.getEntityList(type: ShopObject.self)
        var obj:[ShopObject] = []
        for object in objects {
            obj.append(object)
        }
        let datasource = [FavoriteShopDataSource(items: obj)]
        
        let _dataSource = BehaviorRelay<[FavoriteShopDataSource]>(value: datasource)
        dataSource = _dataSource.asObservable()
        
        updateFavorite = AnyObserver<Void>() { _ in
            let objects = RealmManager.getEntityList(type: ShopObject.self)
            var obj:[ShopObject] = []
            for object in objects {
                obj.append(object)
            }
            let datasource = [FavoriteShopDataSource(items: obj)]
            _dataSource.accept(datasource)
        }
        
        self.delete = AnyObserver<String>() { name in
            RealmManager.deleteOneObject(type: ShopObject.self, name: name.element!)
        }
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {return self}
    var outputs: FavoriteViewModelOutput {return self}
}
