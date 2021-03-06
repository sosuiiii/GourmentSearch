//
//  GenreDataSource.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import RxDataSources

struct MockDataSource {
    var items: [MockData]
}
extension MockDataSource: SectionModelType {
    init(original: MockDataSource, items: [MockData]) {
        self = original
        self.items = items
    }
}
///ジャンルマスタAPIのレスポンス。
///https://webservice.recruit.co.jp/hotpepper/genre/v1/?key=[YOUR_API-KEY]
struct GenreData {
    static let mockData = [
        MockData(genreName: "居酒屋", genreCode: "G001"),
        MockData(genreName: "ダイニングバー\nバル", genreCode: "G002"),
        MockData(genreName: "カフェ\nスイーツ", genreCode: "G014"),
        MockData(genreName: "創作料理", genreCode: "G003"),
        MockData(genreName: "和食", genreCode: "G004"),
        MockData(genreName: "洋食", genreCode: "G005"),
        MockData(genreName: "イタリアン\nフレンチ", genreCode: "G006"),
        MockData(genreName: "中華", genreCode: "G007"),
        MockData(genreName: "焼肉\nホルモン", genreCode: "G008"),
        MockData(genreName: "韓国料理", genreCode: "G017"),
        MockData(genreName: "アジア\nエスニック料理", genreCode: "G009"),
        MockData(genreName: "各国料理", genreCode: "G010"),
        MockData(genreName: "カラオケ\nパーティ", genreCode: "G011"),
        MockData(genreName: "バー\nカクテル", genreCode: "G012"),
        MockData(genreName: "ラーメン", genreCode: "G013"),
        MockData(genreName: "お好み焼き\nもんじゃ", genreCode: "G016"),
        MockData(genreName: "その他グルメ", genreCode: "G015")
    ]
    
}
