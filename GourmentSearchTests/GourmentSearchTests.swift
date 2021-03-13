//
//  GourmentSearchTests.swift
//  GourmentSearchTests
//
//  Created by TanakaSoushi on 2021/03/06.
//

import XCTest
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
