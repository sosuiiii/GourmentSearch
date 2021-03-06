//
//  ErrorHandler.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Moya
import RxSwift

final class APIResponseStatusCodeHandler {
    //ステータスコードハンドリング共通メソッド
    static func handleStatusCode(_ response: PrimitiveSequence<SingleTrait, Response>.Element) throws {
        print("handleStatusCode: \(response.statusCode)")
        switch response.statusCode {
        
        case 200...399:
            break
        //FIXME 400などでハンドリングしたい
        //予期せぬエラーの共通処理
        default:
            throw GourmentError.unexpectedServerError
            
        }
    }
}
