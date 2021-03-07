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
    
    override var isSelected: Bool {
        didSet {
            baseView.backgroundColor = isSelected ? UIColor.systemYellow.withAlphaComponent(0.7) : .systemGray6
            genreTitle.textColor = isSelected ? .white : .black
        }
    }
    
    func setupCell(item: Genre) {
        genreTitle.text = item.name
        if QueryShareManager.shared.getQuery()["genre"] != nil {
            if QueryShareManager.shared.getQuery()["genre"] as! String == item.code {
                self.isSelected = true
            }
        } else {
            self.isSelected = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
