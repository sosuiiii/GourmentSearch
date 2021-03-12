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
    dynamic var logoImage:URL?
    dynamic var lat = 0.0
    dynamic var lng = 0.0
    
    convenience init(response: Shop) {
        self.init()
        name = response.name
        budgetName = response.budget?.name ?? ""
        genre = response.genre.name
        station = response.stationName ?? ""
        logoImage = response.logoImage
        lat = response.lat
        lng = response.lng
    }
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
