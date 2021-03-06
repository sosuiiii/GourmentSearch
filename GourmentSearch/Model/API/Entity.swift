//
//  Entity.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import CoreLocation

struct MockData {
    var genreName: String
    var genreCode: String
}


struct HotPepperResponse: Codable {
    let results: Result
}

struct Result: Codable {
    
    let apiVersion: String
    let resultsAvailable: Int
    let resultsReturned: String
    let resultsStart: Int
    let shop: [Shop]
    
    enum CodingKeys: String, CodingKey {
        case apiVersion = "api_version"
        case resultsAvailable = "results_available"
        case resultsReturned = "results_returned"
        case resultsStart = "results_start"
        case shop
    }
}

struct Shop: Codable, Identifiable {
    let id: String
    let name: String
    let logoImage: URL?
    let nameKana: String?
    let address: String
    let stationName: String?
    let ktaiCoupon: Int?
    let largeServiceArea: Area?
    let serviceArea: Area?
    let largeArea: Area?
    let middleArea: Area?
    let smallArea: Area?
    let lat: Double
    let lng: Double
    let genre: Genre
    let subGenre: Genre?
    let budget: Budget?
    let budgetMemo: String?
    let `catch`: String
    let capacity: Int?
    let access: String
    let mobileAccess: String?
    let urls: Urls
    let photo: Photo
    let open: String?
    let close: String?
    let partyCapacity: Int?
    let wifi: String?
    let wedding: String?
    let course: String?
    let freeDrink: String?
    let freeFood: String?
    let privateRoom: String?
    let horigotatsu: String?
    let tatami: String?
    let card: String?
    let nonSmoking: String?
    let charter: String?
//    let ktai: String?
    let parking: String?
    let barrierFree: String?
    let otherMemo: String?
//    let sommelier: String?
//    let openAir: String?
    let show: String?
//    let equipment: String?
    let karaoke: String?
    let band: String?
    let tv: String?
    let english: String?
    let pet: String?
    let child: String?
    let lunch: String?
    let midnight: String?
    let shopDetailMemo: String?
    let couponUrls: Urls?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoImage = "logo_image"
        case nameKana = "name_kana"
        case address
        case stationName = "station_name"
        case ktaiCoupon = "ktai_coupon"
        case largeServiceArea = "large_service_area"
        case serviceArea = "service_area"
        case largeArea = "large_area"
        case middleArea = "middle_area"
        case smallArea = "small_area"
        case lat
        case lng
        case genre
        case subGenre = "sub_genre"
        case budget
        case budgetMemo = "budget_memo"
        case `catch`
        case capacity
        case access
        case mobileAccess = "mobile_access"
        case urls
        case photo
        case open
        case close
        case partyCapacity = "party_capacity"
        case wifi
        case wedding
        case course
        case freeDrink = "free_drink"
        case freeFood = "free_food"
        case privateRoom = "private_room"
        case horigotatsu
        case tatami
        case card
        case nonSmoking = "non_smoking"
        case charter
//        case ktai
        case parking
        case barrierFree = "barrier_free"
        case otherMemo = "other_memo"
//        case sommelier
//        case openAir = "open_air"
        case show
//        case equipment
        case karaoke
        case band
        case tv
        case english
        case pet
        case child
        case lunch
        case midnight
        case shopDetailMemo = "shop_detail_memo"
        case couponUrls = "coupon_urls"
    }
    
    var coordinate: CLLocationCoordinate2D {
        guard
            let lat = CLLocationDegrees(String(lat)),
            let lng = CLLocationDegrees(String(lng)) else { fatalError() }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

struct Area: Codable {
    let code: String
    let name: String
}

struct Genre: Codable {
    let code: String
    let name: String
    enum CodingKeys: String, CodingKey {
        case code
        case name
    }
}
struct GenreResponse: Codable {
    let results: GenreArr
}
struct GenreArr: Codable {
    let genre: [Genre]
    enum CodingKeys: String, CodingKey {
        case genre
    }
}

struct Budget: Codable {
    let code: String
    let name: String
    let average: String
}

struct Urls: Codable {
    let pc: URL
    let sp: URL?
}

struct Photo: Codable {
    
    let pc: ImageUrl
    let mobile: ImageUrl?
    
    struct ImageUrl: Codable {
        let l: URL
        let m: URL?
        let s: URL
    }
}
