//
//  GenreDataSource.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import RxDataSources

///ジャンルマスタAPIのレスポンス。
///https://webservice.recruit.co.jp/hotpepper/genre/v1/?key=[YOUR_API-KEY]

struct GenreDataSource {
    var items: [Genre]
}
extension GenreDataSource: SectionModelType {
    init(original: GenreDataSource, items: [Genre]) {
        self = original
        self.items = items
    }
}
