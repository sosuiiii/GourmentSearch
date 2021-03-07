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
}
