//
//  DetailSearchViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import RxCocoa


protocol DetailSerachViewModelInput {
    var row: AnyObserver<Int> {get}
    var lengthTapped: AnyObserver<Int> {get}
    var feeInput: AnyObserver<String?> {get}
}

protocol DetailSearchViewModelOutput {
    var items: Observable<[GenreDataSource]> {get}
    var activeLength: Observable<Int> {get}
    var alert: Observable<AlertType> {get}
    var validFee: Observable<String> {get}
}

protocol DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {get}
    var outputs: DetailSearchViewModelOutput {get}
}

class DetailSearchViewModel: DetailSerachViewModelInput, DetailSearchViewModelOutput {
    
    //Input
    var row: AnyObserver<Int>
    var lengthTapped: AnyObserver<Int>
    var feeInput: AnyObserver<String?>
    
    //Output
    var items: Observable<[GenreDataSource]>
    var activeLength: Observable<Int>
    var alert: Observable<AlertType>
    var validFee: Observable<String>
    
    init() {
        
        let genreDataSource = [GenreDataSource(items: GenreShareManager.shared.genres)]
        
        let _items = BehaviorRelay<[GenreDataSource]>(value: genreDataSource)
        items = _items.asObservable()
        
        let _activeLength = PublishRelay<Int>()
        activeLength = _activeLength.asObservable()
        
        let _alert = PublishRelay<AlertType>()
        alert = _alert.asObservable()
        
        let _validFee = PublishRelay<String>()
        validFee = _validFee.asObservable()
        
        //ジャンル
        self.row = AnyObserver<Int>() { row in
            guard let row = row.element else {return}
        }
        //距離 1-300m ~  5-3000m 99-リセット
        self.lengthTapped = AnyObserver<Int>() { range in
            guard let range = range.element else {return}
            _activeLength.accept(range)
            if range == 99 {return}
            QueryShareManager.shared.addQuery(key: "range", value: "\(range)")
            
        }
        
        self.feeInput = AnyObserver<String?> { str in
            guard let str = str.element, let str2 = str else {return}
            guard let fee = Int(str2) else {return}
            let validFee = FeeInputValidation.isOver(fee: fee)
            let over = validFee.1
            if over {
                _alert.accept(.feeOver)
            }
            print("予算:\(validFee.0)円")
            _validFee.accept("\(validFee.0)")
        }
    }
}

extension DetailSearchViewModel: DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {return self}
    var outputs: DetailSearchViewModelOutput {return self}
}
