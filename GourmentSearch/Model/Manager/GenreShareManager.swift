//
//  GenreShareManager.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation

class GenreShareManager {
    var genres:[Genre] = []
    static let shared = GenreShareManager()
    private init() {}
}
