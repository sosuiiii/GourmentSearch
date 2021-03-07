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
    
    var search: AnyObserver<String> {get}
    var row: AnyObserver<Int> {get}
    var lengthTapped: AnyObserver<Int> {get}
    var feeInput: AnyObserver<String> {get}
    
    var wifi: AnyObserver<Int> {get}
    var personalSpace: AnyObserver<Int> {get}
    var credit: AnyObserver<Int> {get}
    var freeFood: AnyObserver<Int> {get}
    var freeDrink: AnyObserver<Int> {get}
    var japLiquor: AnyObserver<Int> {get}
    var shochu: AnyObserver<Int> {get}
    var cocktail: AnyObserver<Int> {get}
    var wine: AnyObserver<Int> {get}
    
    var resetOther: AnyObserver<Void> {get}
}

protocol DetailSearchViewModelOutput {
    var validSearch: Observable<String> {get}
    var items: Observable<[GenreDataSource]> {get}
    var activeLength: Observable<Int> {get}
    var alert: Observable<AlertType?> {get}
    var validFee: Observable<String> {get}
    
    var wifiActive: Observable<Bool> {get}
    var personalSpaceActive: Observable<Bool> {get}
    var creditActive: Observable<Bool> {get}
    var freeFoodActive: Observable<Bool> {get}
    var freeDrinkActive: Observable<Bool> {get}
    var japLiquorActive: Observable<Bool> {get}
    var shochuActive: Observable<Bool> {get}
    var cocktailActive: Observable<Bool> {get}
    var wineActive: Observable<Bool> {get}
    
    var resetOtherOutput: Observable<Void> {get}
}

protocol DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {get}
    var outputs: DetailSearchViewModelOutput {get}
}

class DetailSearchViewModel: DetailSerachViewModelInput, DetailSearchViewModelOutput {
    
    //Input
    var search: AnyObserver<String>
    var row: AnyObserver<Int>
    var lengthTapped: AnyObserver<Int>
    var feeInput: AnyObserver<String>
    var wifi: AnyObserver<Int>
    var personalSpace: AnyObserver<Int>
    var credit: AnyObserver<Int>
    var freeFood: AnyObserver<Int>
    var freeDrink: AnyObserver<Int>
    var japLiquor: AnyObserver<Int>
    var shochu: AnyObserver<Int>
    var cocktail: AnyObserver<Int>
    var wine: AnyObserver<Int>
    var resetOther: AnyObserver<Void>
    
    //Output
    var validSearch: Observable<String>
    var items: Observable<[GenreDataSource]>
    var activeLength: Observable<Int>
    var alert: Observable<AlertType?>
    var validFee: Observable<String>
    var wifiActive: Observable<Bool>
    var personalSpaceActive: Observable<Bool>
    var creditActive: Observable<Bool>
    var freeFoodActive: Observable<Bool>
    var freeDrinkActive: Observable<Bool>
    var japLiquorActive: Observable<Bool>
    var shochuActive: Observable<Bool>
    var cocktailActive: Observable<Bool>
    var wineActive: Observable<Bool>
    var resetOtherOutput: Observable<Void>
    
    init() {
        
        let genreDataSource = [GenreDataSource(items: GenreShareManager.shared.genres)]
        
        let _items = BehaviorRelay<[GenreDataSource]>(value: genreDataSource)
        items = _items.asObservable()
        let _activeLength = PublishRelay<Int>()
        activeLength = _activeLength.asObservable()
        let _alert = PublishRelay<AlertType?>()
        alert = _alert.asObservable()
        let _validFee = PublishRelay<String>()
        validFee = _validFee.asObservable()
        let _wifiActive = PublishRelay<Bool>()
        wifiActive = _wifiActive.asObservable()
        let _personalSpaceActive = PublishRelay<Bool>()
        personalSpaceActive = _personalSpaceActive.asObservable()
        let _creditActive = PublishRelay<Bool>()
        creditActive = _creditActive.asObservable()
        let _freeFoodActive = PublishRelay<Bool>()
        freeFoodActive = _freeFoodActive.asObservable()
        let _freeDrinkActive = PublishRelay<Bool>()
        freeDrinkActive = _freeDrinkActive.asObservable()
        let _japLiquorActive = PublishRelay<Bool>()
        japLiquorActive = _japLiquorActive.asObservable()
        let _shochuActive = PublishRelay<Bool>()
        shochuActive = _shochuActive.asObservable()
        let _cocktailActive = PublishRelay<Bool>()
        cocktailActive = _cocktailActive.asObservable()
        let _wineActive = PublishRelay<Bool>()
        wineActive = _wineActive.asObservable()
        let _resetOtherOutput = PublishRelay<Void>()
        resetOtherOutput = _resetOtherOutput.asObservable()
        let _validSearch = PublishRelay<String>()
        validSearch = _validSearch.asObservable()
        
        //検索
        self.search = AnyObserver<String>() { text in
            guard let text = text.element else {return}
            let validText = TextFieldValidation.validateOverCount(text: text)
            QueryShareManager.shared.addQuery(key: "keyword", value: validText.0)
            _validSearch.accept(validText.0)
            _alert.accept(validText.1)
        }
        
        //ジャンル
        self.row = AnyObserver<Int>() { row in
//            GenreCollectionViewCellで管理
        }
        //距離 1-300m ~  5-3000m 99-リセット
        self.lengthTapped = AnyObserver<Int>() { range in
            guard let range = range.element else {return}
            _activeLength.accept(range)
            if range == 99 {return}
            QueryShareManager.shared.addQuery(key: "range", value: "\(range)")
            
        }
        //料金
        self.feeInput = AnyObserver<String> { str in
            guard let str = str.element else {return}
            if str.isEmpty {
                QueryShareManager.shared.addQuery(key: "budget", value: "B011")
            }
            guard let fee = Int(str) else {return}
            let validFee = FeeInputValidation.isOver(fee: fee)
            let over = validFee.1
            if over {
                _alert.accept(.feeOver)
            }
            print("予算:\(validFee.0)円")
            let code = FeeInputValidation.getBudgetCode(fee: validFee.0)
            QueryShareManager.shared.addQuery(key: "budget", value: code)
            _validFee.accept("\(validFee.0)")
        }
        //こだわり条件
        self.wifi = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "wifi", int: int)
        }
        self.personalSpace = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "private_room", int: int)
        }
        self.credit = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "card", int: int)
        }
        self.freeFood = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "free_food", int: int)
        }
        self.freeDrink = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "free_drink", int: int)
        }
        self.japLiquor = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "sake", int: int)
        }
        self.shochu = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "shochu", int: int)
        }
        self.cocktail = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "cocktail", int: int)
        }
        self.wine = AnyObserver<Int> { int in
            QueryShareManager.shared.addQuery(key: "wine", int: int)
        }
        self.resetOther = AnyObserver<Void> { _ in
            _resetOtherOutput.accept(Void())
        }
    }
}

extension DetailSearchViewModel: DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {return self}
    var outputs: DetailSearchViewModelOutput {return self}
}
