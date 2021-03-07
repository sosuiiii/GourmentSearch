//
//  FeeInputValidation.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import Foundation

open class FeeInputValidation {
    static func isOver(fee: Int) -> (Int, Bool) {
        if fee > 100000 {
            return (100000, true)
        } else {
            return (fee, false)
        }
    }
    
    static func getBudgetCode(fee: Int) -> String {
        switch fee {
        case 0...500:
            return BudgetCode.b009.code
        case 501...1000:
            return BudgetCode.b010.code
        case 1001...1500:
            return BudgetCode.b011.code
        case 1501...2000:
            return BudgetCode.b001.code
        case 2001...3000:
            return BudgetCode.b002.code
        case 3001...4000:
            return BudgetCode.b003.code
        case 4001...5000:
            return BudgetCode.b008.code
        case 5001...7000:
            return BudgetCode.b004.code
        case 7001...10000:
            return BudgetCode.b005.code
        case 10001...15000:
            return BudgetCode.b006.code
        case 15001...20000:
            return BudgetCode.b012.code
        case 20001...30000:
            return BudgetCode.b013.code
        case 30001...:
            return BudgetCode.b014.code
        default:
            return BudgetCode.b001.code
        }
    }
}

enum BudgetCode {
    case b009
    case b010
    case b011
    case b001
    case b002
    case b003
    case b008
    case b004
    case b005
    case b006
    case b012
    case b013
    case b014
    
    var code: String {
        switch self {
        case .b009://~500
            return "B009"
        case .b010://501~1000
            return "B010"
        case .b011://1001~1500
            return "B011"
        case .b001://1501~2000
            return "B001"
        case .b002://2001~3000
            return "B002"
        case .b003://3001~4000
            return "B003"
        case .b008://4001~5000
            return "B008"
        case .b004://5001~7000
            return "B004"
        case .b005://7001~10000
            return "B005"
        case .b006://10001~15000
            return "B006"
        case .b012://15001~20000
            return "B012"
        case .b013://20001~30000
            return "B013"
        case .b014://30001~
            return "B014"
        }
    }
}
