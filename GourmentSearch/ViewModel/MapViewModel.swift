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
    var search: AnyObserver<String>{get}
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
    var search: AnyObserver<String>
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
        
        self.searchText = AnyObserver<String>() { text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            _validatedText.accept(textOver.0)
            if textOver.1 == nil {return}
            _alert.accept(textOver.1)
        }
        
        let _search = PublishRelay<String>()
        self.search = AnyObserver<String>() { text in
            _search.accept(text.element!)
        }
        _search.flatMapLatest({ text -> Observable<Event<HotPepperResponse>> in
            var validText = text
            //空文字で投げるとステータスコード200で
            //別の構造体が返ってくるため無理やり制御
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery()).materialize()
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print(response)
            case .error(_):
                _alert.accept(.unexpectedServerError)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
    }
}

extension MapViewModel: MapViewModelType {
    var inputs: MapViewModelInput {return self}
    var outputs: MapViewModelOutput {return self}
}
