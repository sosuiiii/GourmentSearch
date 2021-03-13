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
    
    var initView: AnyObserver<Void> {get}
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
    @AnyObserverWrapper var initView: AnyObserver<Void>
    @AnyObserverWrapper var search: AnyObserver<String>
    @AnyObserverWrapper var row: AnyObserver<Int>
    @AnyObserverWrapper var lengthTapped: AnyObserver<Int>
    @AnyObserverWrapper var feeInput: AnyObserver<String>
    @AnyObserverWrapper var wifi: AnyObserver<Int>
    @AnyObserverWrapper var personalSpace: AnyObserver<Int>
    @AnyObserverWrapper var credit: AnyObserver<Int>
    @AnyObserverWrapper var freeFood: AnyObserver<Int>
    @AnyObserverWrapper var freeDrink: AnyObserver<Int>
    @AnyObserverWrapper var japLiquor: AnyObserver<Int>
    @AnyObserverWrapper var shochu: AnyObserver<Int>
    @AnyObserverWrapper var cocktail: AnyObserver<Int>
    @AnyObserverWrapper var wine: AnyObserver<Int>
    @AnyObserverWrapper var resetOther: AnyObserver<Void>
    
    //Output
    @PublishRelayWrapper var validSearch: Observable<String>
    var items: Observable<[GenreDataSource]>
    @PublishRelayWrapper var activeLength: Observable<Int>
    @PublishRelayWrapper var alert: Observable<AlertType?>
    @PublishRelayWrapper var validFee: Observable<String>
    @PublishRelayWrapper var wifiActive: Observable<Bool>
    @PublishRelayWrapper var personalSpaceActive: Observable<Bool>
    @PublishRelayWrapper var creditActive: Observable<Bool>
    @PublishRelayWrapper var freeFoodActive: Observable<Bool>
    @PublishRelayWrapper var freeDrinkActive: Observable<Bool>
    @PublishRelayWrapper var japLiquorActive: Observable<Bool>
    @PublishRelayWrapper var shochuActive: Observable<Bool>
    @PublishRelayWrapper var cocktailActive: Observable<Bool>
    @PublishRelayWrapper var wineActive: Observable<Bool>
    @PublishRelayWrapper var resetOtherOutput: Observable<Void>
    
    //property
    private var disposeBag = DisposeBag()
    
    init() {
        
        let genreDataSource = [GenreDataSource(items: GenreShareManager.shared.genres)]
        let _items = BehaviorRelay<[GenreDataSource]>(value: genreDataSource)
        items = _items.asObservable()

        //検索
        let _ = $search.subscribe({ text in
            guard let text = text.element else {return}
            let validText = TextFieldValidation.validateOverCount(text: text)
            QueryShareManager.shared.addQuery(key: "keyword", value: validText.0)
            if validText.0 == nil {return}
            self.$validSearch.accept(validText.0!)
            self.$alert.accept(validText.1)
        }).disposed(by: disposeBag)
        
        //ジャンル
        let _ = $row.subscribe({ row in
//            GenreCollectionViewCellで管理
        }).disposed(by: disposeBag)
        
        //距離 1-300m ~  5-3000m 99-リセット
        let _ = $lengthTapped.subscribe({ range in
            guard let range = range.element else {return}
            self.$activeLength.accept(range)
            if range == 99 {return}
            QueryShareManager.shared.addQuery(key: "range", value: "\(range)")
        }).disposed(by: disposeBag)
        
        //料金
        let _ = $feeInput.subscribe({ str in
            guard let str = str.element else {return}
            if str.isEmpty {
                QueryShareManager.shared.addQuery(key: "budget", value: nil)
            }
            guard let fee = Int(str) else {return}
            let validFee = FeeInputValidation.isOver(fee: fee)
            let over = validFee.1
            if over {
                self.$alert.accept(.feeOver)
            }
            print("予算:\(validFee.0)円")
            let code = FeeInputValidation.getBudgetCode(fee: validFee.0)
            QueryShareManager.shared.addQuery(key: "budget", value: code)
            self.$validFee.accept("\(validFee.0)")
        }).disposed(by: disposeBag)
        
        //こだわり条件
        let _ = $wifi.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "wifi", int: int)
        }).disposed(by: disposeBag)
        let _ = $personalSpace.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "private_room", int: int)
        }).disposed(by: disposeBag)
        let _ = $credit.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "card", int: int)
        }).disposed(by: disposeBag)
        let _ = $freeFood.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "free_food", int: int)
        }).disposed(by: disposeBag)
        let _ = $freeDrink.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "free_drink", int: int)
        }).disposed(by: disposeBag)
        let _ = $japLiquor.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "sake", int: int)
        }).disposed(by: disposeBag)
        let _ = $shochu.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "shochu", int: int)
        }).disposed(by: disposeBag)
        let _ = $cocktail.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "cocktail", int: int)
        }).disposed(by: disposeBag)
        let _ = $wine.subscribe({ int in
            QueryShareManager.shared.addQuery(key: "wine", int: int)
        }).disposed(by: disposeBag)
        let _ = $resetOther.subscribe({ _ in
            self.$resetOtherOutput.accept(Void())
        }).disposed(by: disposeBag)
        
        
        let _ = $initView.subscribe({ _ in
            let queries = QueryShareManager.shared.getQuery()
            print(queries)
            if let keyword = queries["keyword"] {
                print(keyword)
                self.$validSearch.accept(keyword as! String)
            }
            if let range = queries["range"] {
                self.$activeLength.accept(Int(range as! String)!)
            }
            if let _ = queries["wifi"] {
                self.$wifiActive.accept(true)
            }
            if let _ = queries["free_food"] {
                self.$freeFoodActive.accept(true)
            }
            if let _ = queries["free_drink"] {
                self.$freeDrinkActive.accept(true)
            }
            if let _ = queries["sake"] {
                self.$japLiquorActive.accept(true)
            }
            if let _ = queries["shochu"] {
                self.$shochuActive.accept(true)
            }
            if let _ = queries["cocktail"] {
                self.$cocktailActive.accept(true)
            }
            if let _ = queries["wine"] {
                self.$wineActive.accept(true)
            }
        }).disposed(by: disposeBag)
    }
}

extension DetailSearchViewModel: DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {return self}
    var outputs: DetailSearchViewModelOutput {return self}
}
