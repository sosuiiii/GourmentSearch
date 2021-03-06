//
//  DetailSearchViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import RxCocoa


protocol DetailSerachViewModelInput {
    var row: AnyObserver<Int> {get}
}

protocol DetailSearchViewModelOutput {
    var items: Observable<[MockDataSource]> {get}
    var genreTitle: Observable<String> {get}
    var genreCode: Observable<String> {get}
}

protocol DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {get}
    var outputs: DetailSearchViewModelOutput {get}
}

class DetailSearchViewModel: DetailSerachViewModelInput, DetailSearchViewModelOutput {
    
    //Input
    var row: AnyObserver<Int>
    
    //Output
    var items: Observable<[MockDataSource]>
    var genreTitle: Observable<String>
    var genreCode: Observable<String>
    
    init() {

        let mockDataSource = [MockDataSource(items: GenreData.mockData)]
        
        let _items = BehaviorRelay<[MockDataSource]>(value: mockDataSource)
        items = _items.asObservable()
        
        let _genreTitle = PublishRelay<String>()
        genreTitle = _genreTitle.asObservable()
        
        let _genreCode = PublishRelay<String>()
        genreCode = _genreCode.asObservable()
        
        self.row = AnyObserver<Int>() { row in
            guard let row = row.element else {return}
            _genreTitle.accept(mockDataSource[0].items[row].genreName)
            _genreCode.accept(mockDataSource[0].items[row].genreCode)
        }
    }
}

extension DetailSearchViewModel: DetailSearchViewModelType {
    var inputs: DetailSerachViewModelInput {return self}
    var outputs: DetailSearchViewModelOutput {return self}
}
