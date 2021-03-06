//
//  Error.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
enum GourmentError: Error {
    case unexpectedServerError
    var errorTitle: String? {
        switch self {
        case .unexpectedServerError:
            return "予期せぬサーバーエラーが起きました"
        }
    }
}

