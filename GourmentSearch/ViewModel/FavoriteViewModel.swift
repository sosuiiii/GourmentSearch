//
//  FavoriteViewModel.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/12.
//

import Foundation


protocol FavoriteViewModelInput {
    
}

protocol FavoriteViewModelOutput {
    
}

protocol FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {get}
    var outputs: FavoriteViewModelOutput {get}
}

class FavoriteViewModel: FavoriteViewModelInput, FavoriteViewModelOutput {
    
    init() {
    }
}

extension FavoriteViewModel: FavoriteViewModelType {
    var inputs: FavoriteViewModelInput {return self}
    var outputs: FavoriteViewModelOutput {return self}
}
