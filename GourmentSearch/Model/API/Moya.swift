//
//  Moya.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//
import Moya

enum GourmentAPI {
    case search(keyValue: [String:Any])
    case getGenre
}

extension GourmentAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://webservice.recruit.co.jp/")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "hotpepper/gourmet/v1/"
        case .getGenre:
            return "hotpepper/genre/v1/"
        }
    }
    
    var method: Method {
        switch self {
        case .search:
            return .get
        case .getGenre:
            return .get
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    var parameters: [String: Any] {
        var parameter = [
            "key": "APIKEY",
            "format": "json",
            "count": 50
        ] as [String : Any]
        switch self {
        case .search(let keyValue):
            keyValue.forEach({ key, value in
                parameter[key] = value
            })
            return parameter
        case .getGenre:
            return parameter
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .search:
            return Moya.URLEncoding.queryString
        case .getGenre:
            return Moya.URLEncoding.queryString
        }
    }
    
    var task: Task {
        switch self {
        case .search:
            print(parameters)
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        case .getGenre:
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

//MARK: 経路検索
enum MapAPI {
    case search(start: String, goal: String)
}
extension MapAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api/directions")!
    }
    
    var path: String {
        switch self {
        case .search:
            return "/json"
        }
    }
    
    var method: Method {
        switch self {
        case .search:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    var parameters: [String: Any] {
        
        var parameter = ["key":"APIKEY"] as [String : Any]
        switch self {
        case .search(let start, let goal):
            parameter["origin"] = start
            parameter["destination"] = goal
            return parameter
        }
    }
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .search:
            return Moya.URLEncoding.queryString
        }
    }
    var task: Task {
        switch self {
        case .search:
            print(parameters)
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
    }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
