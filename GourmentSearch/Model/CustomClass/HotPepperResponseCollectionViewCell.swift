//
//  HotPepperResponseCollectionViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import UIKit
import Instantiate
import InstantiateStandard

protocol HotPepperCollectionViewCellDelegate: class {
    func way(row: Int)
    func save(row: Int)
}


class HotPepperResponseCollectionViewCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var genreAndStation: UILabel!
    @IBOutlet weak var way: UIButton!
    @IBOutlet weak var save: UIButton!
    weak var delegate:HotPepperCollectionViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(item: Shop, row: Int) {
//        logoImage.image = item.logoImage
        name.text = item.name
        fee.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(String(describing: item.stationName))"
    }
    @IBAction func wayTapped(_ sender: Any) {
        
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    
}
