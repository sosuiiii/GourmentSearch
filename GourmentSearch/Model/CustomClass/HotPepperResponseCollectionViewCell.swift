//
//  HotPepperResponseCollectionViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import UIKit
import Instantiate
import InstantiateStandard
import SDWebImage

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
    
    private var noImageURL = URL(string: "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png")
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(item: Shop, row: Int) {
        setImageBySDWebImage(with: item.logoImage ?? noImageURL)
        name.text = item.name
        fee.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(String(describing: item.stationName))"
    }
    func setImageBySDWebImage(with url: URL?) {
        logoImage.sd_setImage(with: url) { [weak self] image, error, _, _ in
            if error == nil, let image = image {
                self?.logoImage.image = image
            } else {
                print("sd_webImage::error:\(String(describing: error))")
            }
        }
    }
    @IBAction func wayTapped(_ sender: Any) {
        
    }
    @IBAction func saveTapped(_ sender: Any) {
    }
    
}
