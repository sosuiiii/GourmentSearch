//
//  GenreCollectionViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Instantiate
import InstantiateStandard

class GenreCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var genreTitle: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            baseView.backgroundColor = isHighlighted ? .systemGray5 : .systemGray6
        }
    }
    
    func setupCell(item: Genre) {
        genreTitle.text = item.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
