//
//  FavoriteShopDataSource.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/12.
//

import Foundation
import RxDataSources

struct FavoriteShopDataSource {
    var items: [ShopObject]
}
extension FavoriteShopDataSource: SectionModelType {
    init(original: FavoriteShopDataSource, items: [ShopObject]) {
        self = original
        self.items = items
    }
}
