//
//  MapViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//
import Foundation
import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol MapViewModelInput {
    
}

protocol MapViewModelOutput {
    
}

protocol MapViewModelType {
    var inputs: MapViewModelInput {get}
    var outputs: MapViewModelOutput {get}
}

class MapViewModel: MapViewModelInput, MapViewModelOutput {
    
    init() {
    }
}

extension MapViewModel: MapViewModelType {
    var inputs: MapViewModelInput {return self}
    var outputs: MapViewModelOutput {return self}
}
