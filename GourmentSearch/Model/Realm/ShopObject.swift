//
//  ShopObject.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import Foundation
import RealmSwift

class ShopObject: Object{
    @objc dynamic var name = ""
    @objc dynamic var genre = ""
    @objc dynamic var station = ""
    @objc dynamic var lat = 0
    @objc dynamic var lng = 0
    @objc dynamic var budget = ""
    
    func save(item: Shop) {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch let error{
            print("Realmインスタンスの代入に失敗しました:\(error)")
        }
        
        do {
            try realm?.write {
                realm?.add(ShopObject(value: [
                    "name": item.name,
                    "genre": item.genre,
                    "station": item.stationName ?? "_",
                    "lat": item.lat,
                    "lng": item.lng,
                    "budget": item.budget?.name ?? "_"
                ]))
            }
        } catch let error {
            print("Realmへの保存に失敗しました:\(error)")
        }
    }
}
struct Hoge {
    var name: String
}
