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
    var location: AnyObserver<(String, String)> {get}
}

protocol MapViewModelOutput {
    var alert: Observable<AlertType?>{get}
    var validatedText: Observable<String>{get}
    var datasource: Observable<[HotPepperResponseDataSource]>{get}
    var showCell: Observable<Void>{get}
    var direction: Observable<Direction>{get}
}

protocol MapViewModelType {
    var inputs: MapViewModelInput {get}
    var outputs: MapViewModelOutput {get}
    
}

class MapViewModel: MapViewModelInput, MapViewModelOutput {
    
    //Input
    var searchText: AnyObserver<String>
    var search: AnyObserver<String>
    var location: AnyObserver<(String, String)>
    //Output
    var alert: Observable<AlertType?>
    var validatedText: Observable<String>
    var datasource: Observable<[HotPepperResponseDataSource]>
    var showCell: Observable<Void>
    var direction: Observable<Direction>
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        let _alert = PublishRelay<AlertType?>()
        self.alert = _alert.asObservable()
        
        let _validatedText = PublishRelay<String>()
        self.validatedText = _validatedText.asObservable()
        
        let _showCell = PublishRelay<Void>()
        self.showCell = _showCell.asObservable()
        
        let _datasource = PublishRelay<[HotPepperResponseDataSource]>()
        self.datasource = _datasource.asObservable()
        
        let _direction = PublishRelay<Direction>()
        self.direction = _direction.asObservable()
        
        self.searchText = AnyObserver<String>() { text in
            let textOver = TextFieldValidation.validateOverCount(text: text.element!)
            if textOver.0 == nil { return }
            _validatedText.accept(textOver.0!)
            if textOver.1 == nil {return}
            _alert.accept(textOver.1)
        }
        
        let _search = PublishRelay<String>()
        self.search = AnyObserver<String>() { text in
            _search.accept(text.element!)
        }
        _search.flatMapLatest({ text -> Observable<HotPepperResponse> in
            var validText = text
            if text.isEmpty { validText = "あ"}
            let shared = QueryShareManager.shared
            shared.addQuery(key: "keyword", value: validText)
            return try Repository.search(keyValue: shared.getQuery())
        }).subscribe({ event in
            switch event {
            case .next(let response):
                print("responceCount:\(response.results.shop.count)")
                _datasource.accept([HotPepperResponseDataSource(items: response.results.shop)])
                _showCell.accept(Void())
            case .error(_):
                _alert.accept(.unexpectedServerError)
            case .completed:
                break
            }
        }).disposed(by: disposeBag)
        let _location = PublishRelay<(String, String)>()
        self.location = AnyObserver<(String, String)>() { startEnd in
            guard let startEnd = startEnd.element else {return}
            _location.accept(startEnd)
        }
        _location.flatMapLatest({ startEnd  -> Observable<Direction> in
            return try Repository.direction(start: startEnd.0, goal: startEnd.0)
        }).subscribe({ event in
            switch event {
            case .next(let direction):
                _direction.accept(direction)
                print(direction)
            case .error(let error):
                print(error)
                _alert.accept(.error)
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
