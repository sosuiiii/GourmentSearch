//
//  QueryShareManager.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation

class QueryShareManager {
    private var queries:[String:Any] = [:]
    static let shared = QueryShareManager()
    private init() {}
    
    func addQuery(key: String, value: String) {
        QueryShareManager.shared.queries[key] = value
    }
    func getQuery() -> [String:Any]{
        return QueryShareManager.shared.queries
    }
}
