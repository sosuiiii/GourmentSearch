//
//  MapEntity.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/10.
//

import Foundation

struct Direction: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let legs: [Leg]
}

struct Leg: Codable {
    let startLocation: LocationPoint //出発地点
    let endLocation: LocationPoint //終点
    let steps: [Step] //経路

    enum CodingKeys: String, CodingKey {
        case startLocation = "start_location"
        case endLocation = "end_location"
        case steps
    }
}

struct Step: Codable {
    let startLocation: LocationPoint
    let endLocation: LocationPoint

    enum CodingKeys: String, CodingKey {
        case startLocation = "start_location"
        case endLocation = "end_location"
    }
}

struct LocationPoint: Codable {
    let lat: Double
    let lng: Double
}
