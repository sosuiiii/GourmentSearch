//
//  QueryShareManager.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import RxSwift

class QueryShareManager {
    private var queries:[String:Any] = [:]
    static let shared = QueryShareManager()
    private init() {}
    
    func addQuery(key: String, value: String?) {
        if value != nil {
            QueryShareManager.shared.queries[key] = value
        } else {
            QueryShareManager.shared.queries[key] = nil
        }
        print("addQuery::\(queries)")
        
    }
    func getQuery() -> [String:Any]{
//        print("getQuery::\(queries)")
        return QueryShareManager.shared.queries
    }
    func resetQuery() {
        QueryShareManager.shared.queries = [:]
        print("getQuery::\(queries)")
    }
    
    func addQuery(key: String, int: Event<Int>) {
        if let int = int.element, int == 0 {
            QueryShareManager.shared.addQuery(key: key, value: nil)
            return
        }
        QueryShareManager.shared.addQuery(key: key, value: "\(int.element ?? 0)")
    }
}
