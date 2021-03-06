//
//  HotPepperResponseDataSource.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import RxDataSources

struct HotPepperResponseDataSource {
    var items: [HotPepperResponse]
}
extension HotPepperResponseDataSource: SectionModelType {
    init(original: HotPepperResponseDataSource, items: [HotPepperResponse]) {
        self = original
        self.items = items
    }
}
