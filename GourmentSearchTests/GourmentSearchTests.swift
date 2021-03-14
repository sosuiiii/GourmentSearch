//
//  GourmentSearchTests.swift
//  GourmentSearchTests
//
//  Created by TanakaSoushi on 2021/03/06.
//

import XCTest
import RxSwift
import Quick
import Nimble
import RxTest
import PKHUD

@testable import GourmentSearch

class ValidationTests: XCTestCase {
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidation() throws {
        XCTContext.runActivity(named: "文字数に応じて適切な文字列とアラートタイプが返ってくる", block: { _ in
            let textOver = TextFieldValidation.validateOverCount(text: "111111111122222222223333333333444444444455555555556")
            XCTAssertEqual(textOver.0?.count, 50)
            XCTAssertEqual(textOver.1, .textOver)
            let textNonOver = TextFieldValidation.validateOverCount(text: "1")
            XCTAssertNil(textNonOver.1)
            XCTAssertEqual(textNonOver.0?.count, 1)
        })
        
        XCTContext.runActivity(named: "10万1以上で10万が返ってくる。それ未満はそれ自体が返る。", block: { _ in
            let feeOver = FeeInputValidation.isOver(fee: 100001)
            XCTAssertEqual(feeOver.0, 100000)
            XCTAssertTrue(feeOver.1)
            let feeNoneOver = FeeInputValidation.isOver(fee: 99999)
            XCTAssertEqual(feeNoneOver.0, 99999)
            XCTAssertFalse(feeNoneOver.1)
        })
        
        XCTContext.runActivity(named: "金額に応じて適切な予算コードが返ってくる", block: { _ in
            var budget = FeeInputValidation.getBudgetCode(fee: 499)
            XCTAssertEqual(budget, BudgetCode.b009.code)
            budget = FeeInputValidation.getBudgetCode(fee: 501)
            XCTAssertEqual((budget), BudgetCode.b010.code)
            budget = FeeInputValidation.getBudgetCode(fee: 1001)
            budget = FeeInputValidation.getBudgetCode(fee: 1501)
            XCTAssertEqual((budget), BudgetCode.b001.code)
            budget = FeeInputValidation.getBudgetCode(fee: 2001)
            XCTAssertEqual((budget), BudgetCode.b002.code)
            budget = FeeInputValidation.getBudgetCode(fee: 3001)
            XCTAssertEqual((budget), BudgetCode.b003.code)
            budget = FeeInputValidation.getBudgetCode(fee: 4001)
            XCTAssertEqual((budget), BudgetCode.b008.code)
            budget = FeeInputValidation.getBudgetCode(fee: 5001)
            XCTAssertEqual((budget), BudgetCode.b004.code)
            budget = FeeInputValidation.getBudgetCode(fee: 7001)
            XCTAssertEqual((budget), BudgetCode.b005.code)
            budget = FeeInputValidation.getBudgetCode(fee: 10001)
            XCTAssertEqual((budget), BudgetCode.b006.code)
            budget = FeeInputValidation.getBudgetCode(fee: 15001)
            XCTAssertEqual((budget), BudgetCode.b012.code)
            budget = FeeInputValidation.getBudgetCode(fee: 20001)
            XCTAssertEqual((budget), BudgetCode.b013.code)
            budget = FeeInputValidation.getBudgetCode(fee: 30001)
            XCTAssertEqual((budget), BudgetCode.b014.code)
        })
    }
}

class ViewModelTests: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        //MARK: DetailSearchViewModel
        describe("DetailSearchViewModelの入出力テスト") {
            context("適切なクエリがシングルトンに追加される") {
                let scheduler = TestScheduler(initialClock: 0, resolution: 0.1)
                let input = [
                    Recorded.next(1, "肉"),
                ]
                let intInput = [
                    Recorded.next(1, 1)
                ]
                it("検索ワードをクエリに追加、適切なアラートタイプの返却") {
                    var validTextObserver: TestableObserver<String>
                    var alertType: TestableObserver<AlertType?>
                    do {
                        let viewModel: DetailSearchViewModelType = DetailSearchViewModel()
                        let input = scheduler.createHotObservable(input)
                        input.asObservable()
                            .subscribe(onNext: { value in
                                viewModel.inputs.search.onNext(value)
                            }).disposed(by: self.disposeBag)
                        
                        validTextObserver = scheduler.createObserver(String.self)
                        alertType = scheduler.createObserver(AlertType?.self)
                        viewModel.outputs.validSearch.bind(to: validTextObserver).disposed(by: self.disposeBag)
                        viewModel.outputs.alert.bind(to: alertType).disposed(by: self.disposeBag)
                        scheduler.start()
                    }
                    expect(validTextObserver.events).to(equal([
                        Recorded.next(1, "肉")
                    ]))
                    let keyword = QueryShareManager.shared.getQuery()["keyword"] as! String
                    XCTAssertEqual(keyword, "肉")
                    expect(alertType.events).to(equal([
                        Recorded.next(1, nil)
                    ]))
                }
                it("距離選択時のクエリ追加確認"){
                    let viewModel: DetailSearchViewModelType = DetailSearchViewModel()
                    var activeLength: TestableObserver<Int>
                    do {
                        let input = scheduler.createHotObservable(intInput)
                        input.asObservable().subscribe(onNext: { value in
                            viewModel.inputs.lengthTapped.onNext(value)
                        }).disposed(by: self.disposeBag)
                        activeLength = scheduler.createObserver(Int.self)
                        viewModel.outputs.activeLength.bind(to: activeLength)
                            .disposed(by: self.disposeBag)
                        scheduler.start()
                    }
                    expect(activeLength.events).to(equal([
                        Recorded.next(1, 1)
                    ]))
                    
                    viewModel.inputs.lengthTapped.onNext(1)
                    let range = QueryShareManager.shared.getQuery()["range"] as! String
                    XCTAssertEqual(range, "1")
                }
                it("料金入力時のクエリ確認"){
                    let viewModel: DetailSearchViewModelType = DetailSearchViewModel()
                    viewModel.inputs.feeInput.onNext("3000")
                    let budget = QueryShareManager.shared.getQuery()["budget"] as! String
                    XCTAssertEqual(budget, BudgetCode.b002.code)
                }
                it("こだわり条件のクエリ確認"){
                    let viewModel: DetailSearchViewModelType = DetailSearchViewModel()
                    viewModel.inputs.wifi.onNext(1)
                    viewModel.inputs.personalSpace.onNext(1)
                    viewModel.inputs.credit.onNext(1)
                    viewModel.inputs.freeFood.onNext(1)
                    viewModel.inputs.freeDrink.onNext(1)
                    viewModel.inputs.japLiquor.onNext(1)
                    viewModel.inputs.shochu.onNext(1)
                    viewModel.inputs.cocktail.onNext(1)
                    viewModel.inputs.wine.onNext(1)
                    let query = QueryShareManager.shared.getQuery()
                    XCTAssertEqual(query["wifi"] as! String, "1")
                    XCTAssertEqual(query["private_room"] as! String, "1")
                    XCTAssertEqual(query["card"] as! String, "1")
                    XCTAssertEqual(query["free_food"] as! String, "1")
                    XCTAssertEqual(query["free_drink"] as! String, "1")
                    XCTAssertEqual(query["sake"] as! String, "1")
                    XCTAssertEqual(query["shochu"] as! String, "1")
                    XCTAssertEqual(query["cocktail"] as! String, "1")
                    XCTAssertEqual(query["wine"] as! String, "1")
                }
            }
        }
    }
}
