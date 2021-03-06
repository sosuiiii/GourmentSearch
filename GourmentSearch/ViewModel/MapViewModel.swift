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
    var searchText: AnyObserver<String>{get}
}

protocol MapViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
}

protocol MapViewModelType {
    var inputs: MapViewModelInput {get}
    var outputs: MapViewModelOutput {get}
}

class MapViewModel: MapViewModelInput, MapViewModelOutput {
    
    //Input
    var searchText: AnyObserver<String>
    //Output
    var alert: Observable<AlertType?>
    var validatedText: Observable<String>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let _alert = PublishRelay<AlertType?>()
        self.alert = _alert.asObservable()
        
        let _validatedText = PublishRelay<String>()
        self.validatedText = _validatedText.asObservable()
        
        let _serachText = PublishRelay<String>()
        self.searchText = AnyObserver<String>() { text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            _serachText.accept(textOver.0)
            if textOver.1 == nil {return}
            _alert.accept(textOver.1)
        }
        _serachText.subscribe({ text in
            _validatedText.accept(text.element!)
        }).disposed(by: disposeBag)
    }
}

extension MapViewModel: MapViewModelType {
    var inputs: MapViewModelInput {return self}
    var outputs: MapViewModelOutput {return self}
}
