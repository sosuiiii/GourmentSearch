//
//  HotPepperResponseTableViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Instantiate
import InstantiateStandard
import SDWebImage

class HotPepperResponseTableViewCell: UITableViewCell, Reusable {

    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genreAndStation: UILabel!
    private var noImageURL = URL(string: "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(item: Shop) {
        setImageBySDWebImage(with: item.logoImage ?? noImageURL)
        name.text = item.name
        budget.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(item.stationName ?? "")駅"
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
    
}
