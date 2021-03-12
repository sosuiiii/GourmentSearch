//
//  ShopObject.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import UIKit
import Realm
import RealmSwift

@objcMembers
class ShopObject: Object {
    
    dynamic var name = ""
    dynamic var budgetName = ""
    dynamic var genre = ""
    dynamic var station = ""
    dynamic var logoImage = ""
    dynamic var lat = 0.0
    dynamic var lng = 0.0
    
    convenience init(shop: Shop) {
        self.init()
        name = shop.name
        budgetName = shop.budget?.name ?? ""
        genre = shop.genre.name
        station = shop.stationName ?? ""
        lat = shop.lat
        lng = shop.lng
        
        if let logoImage = shop.logoImage {
            self.logoImage = "\(logoImage)"
        }
        
        
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
