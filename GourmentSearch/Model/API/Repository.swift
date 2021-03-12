//
//  Repository.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import Moya
import RxSwift

final class Repository {
    private static let apiProvider = MoyaProvider<GourmentAPI>()
    private static let mapProvider = MoyaProvider<MapAPI>()
}
extension Repository {
    
    static func search(keyValue: [String: Any]) throws -> Observable<HotPepperResponse> {
        return apiProvider.rx.request(.search(keyValue: keyValue))
            .map { response in
                try APIResponseStatusCodeHandler.handleStatusCode(response)
                return try JSONDecoder().decode(HotPepperResponse.self, from: response.data)
        }.asObservable()
    }
    static func getGenre() -> Observable<GenreResponse> {
        return Observable.create({ observer in
            apiProvider.request(.getGenre) { response in
                switch response {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(GenreResponse.self, from: response.data)
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    } catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create{}
        })
    }
    
    
    static func direction(start: String, goal: String) throws -> Observable<Direction> {
        return mapProvider.rx.request(.search(start: start, goal: goal))
            .map { response in
                try APIResponseStatusCodeHandler.handleStatusCode(response)
                return try JSONDecoder().decode(Direction.self, from: response.data)
            }.asObservable()
    }
}
