//
//  HotPepperResponseDataSource.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import RxDataSources

struct HotPepperResponseDataSource {
    var items: [Shop]
}
extension HotPepperResponseDataSource: SectionModelType {
    init(original: HotPepperResponseDataSource, items: [Shop]) {
        self = original
        self.items = items
    }
}
