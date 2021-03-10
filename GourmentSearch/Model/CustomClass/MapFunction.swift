//
//  MapFunction.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/10.
//

import Foundation
import Direction
import GoogleMaps
open class MapFunction {
    
    static func showRoute(_ direction: Direction) -> GMSMutablePath? {
        guard let route = direction.routes.first, let leg = route.legs.first else { return nil}
        let path = GMSMutablePath()
        for step in leg.steps {
            path.add(CLLocationCoordinate2D(latitude: step.startLocation.lat,
                                            longitude: step.startLocation.lng))
            path.add(CLLocationCoordinate2D(latitude: step.endLocation.lat,
                                            longitude: step.endLocation.lng))
        }
        return path
        // 曲がるところを結んだ線を Map 上に表示する
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeWidth = 4.0
//        polyline.map = map
    }
}
