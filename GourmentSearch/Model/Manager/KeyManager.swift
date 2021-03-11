//
//  KeyManager.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/11.
//

import Foundation
class KeyManager {
    
    static let shared = KeyManager()
    private init(){}
    var key = ""
    
    static func getKeys() -> NSDictionary? {
        let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")
        guard let path = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: path)
    }

    static func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
