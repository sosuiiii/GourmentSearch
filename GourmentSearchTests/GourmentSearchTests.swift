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

//テスト用shopデータ
//let shop = Shop(id: "J001154102", name: "桜ガーデン SAKURA GARDEN 渋谷本店", logoImage: URL(string: "https://imgfp.hotp.jp/IMGH/87/25/P026518725/P026518725_69.jpg")!, nameKana: "しぶや　こしつ　にくとちーず　たべほうだい　さくらがーでん　しぶやほんてん", address: "東京都渋谷区宇田川町30-5 JOWビル5F", stationName: "渋谷", ktaiCoupon: 0, largeServiceArea: GourmentSearch.Area(code: "SS10", name: "関東"), serviceArea: GourmentSearch.Area(code: "SA11", name: "東京"), largeArea: GourmentSearch.Area(code: "Z011", name: "東京"), middleArea: GourmentSearch.Area(code: "Y030", name: "渋谷"), smallArea: GourmentSearch.Area(code: "X097", name: "渋谷センター街"), lat: 35.6609121157, lng: 139.6980097882, genre: GourmentSearch.Genre(code: "G001", name: "居酒屋"), subGenre: GourmentSearch.Genre(code: "G002", name: "ダイニングバー・バル"), budget: GourmentSearch.Budget(code: "B002", name: "2001～3000円", average: "2490円～2990円（1990円～コース受付！）"), budgetMemo: "1990円～コース受付！", catch: "チーズ好きの為の食べ放題 オシャレ個室ご用意♪", capacity: 95, access: "渋谷駅ハチ公口から4分/渋谷センター街の宇田川交番の向かいの1F 磯丸水産さんの5階が当店です。", mobileAccess: "渋谷駅ﾊﾁ公口から4分/宇田川交番の前のﾋﾞﾙ5階です", urls: GourmentSearch.Urls(pc: URL(string: "https://www.hotpepper.jp/strJ001154102/?vos=nhppalsa000016")!, sp: nil), photo: GourmentSearch.Photo(pc: GourmentSearch.Photo.ImageUrl(l: URL(string: "https://imgfp.hotp.jp/IMGH/36/04/P026533604/P026533604_238.jpg")!, m: URL(string: "https://imgfp.hotp.jp/IMGH/36/04/P026533604/P026533604_168.jpg")!, s: URL(string: "https://imgfp.hotp.jp/IMGH/36/04/P026533604/P026533604_58_s.jpg")!), mobile: GourmentSearch.Photo.ImageUrl(l: URL(string: "https://imgfp.hotp.jp/IMGH/36/04/P026533604/P026533604_168.jpg")!, m: nil, s: URL(string: "https://imgfp.hotp.jp/IMGH/36/04/P026533604/P026533604_100.jpg")!)), open: "月～日、祝日、祝前日: 11:30～翌5:00 （料理L.O. 翌4:30 ドリンクL.O. 翌4:30）", close: "年中無休（GW・お盆・年末年始も休まず営業！）", wifi: "あり", wedding: "カラオケ、ビンゴ、マイク、音響、照明使えます！", course: "あり", freeDrink: "あり ：渋谷エリアコスパ◎格安飲み放題2時間980円", freeFood: "あり ：選べるメイン食べ放題&飲み放題2980円より", privateRoom: "あり ：個室30名×2 個室4名×2 個室15名×1 テーブル4名～95名", horigotatsu: "なし ：個室30名×2 個室4名×2 個室15名×1 テーブル4名～95名", tatami: "なし ：個室30名×2 個室4名×2 個室15名×1 テーブル4名～95名", card: "利用可", nonSmoking: "全面禁煙", charter: "貸切可 ：フロア貸切50名～テーブルフロア貸切15名まで。店舗貸切80名まで。", parking: "なし ：お近くのコインパーキングをご利用ください。運転される方の飲酒はNG。～渋谷個室 居酒屋～", barrierFree: "なし ：1990円～コース受付！", otherMemo: "スポーツ観戦ができる！プロジィクター・個室・居酒屋", show: "なし", karaoke: "あり", band: "不可", tv: "あり", english: "あり", pet: "不可", child: "お子様連れ歓迎 ：選べるメイン食べ放題&飲み放題2980円より", lunch: "あり", midnight: "営業している", shopDetailMemo: "ご持参のiPhone・PC・DVD・ブルーレイディスクの映像をモニターで映せます！サプライズ・余興演出に！", couponUrls: GourmentSearch.Urls(pc: URL(string: "https://www.hotpepper.jp/strJ001154102/map/?vos=nhppalsa000016")!, sp: URL(string: "https://www.hotpepper.jp/strJ001154102/scoupon/?vos=nhppalsa000016")))
