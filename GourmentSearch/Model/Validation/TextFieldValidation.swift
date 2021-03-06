//
//  TextFieldValidation.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation

open class TextFieldValidation {
    static func validateOverCount(text: String) -> (String, AlertType?) {
        if text.count >= 50 {
            let validText = String(text.prefix(50))
            return (validText, .textOver)
        }
        return (text, nil)
    }
 }
