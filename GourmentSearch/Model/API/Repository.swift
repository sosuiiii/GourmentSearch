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
}
extension Repository {
    static func search(keyValue: [String:Any], completion: @escaping (HotPepperResponse) -> ()){
        apiProvider.request(.search(keyValue: keyValue)) { response in
            switch response {
            case let .success(response):
                do {
                    let decodedData = try JSONDecoder().decode(HotPepperResponse.self, from: response.data)
                    completion(decodedData)
                } catch let error {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    static func getGenre(completion: @escaping (Genre) -> ()) {
        apiProvider.request(.getGenre) { response in
            switch response {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(Genre.self, from: response.data)
                    completion(decodedData)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    static func getGenres() -> Observable<GenreResponse> {
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
    
}
