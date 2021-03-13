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

protocol HotPepperTableViewCellDelegate {
    func starTapped(item: Shop?, on: Bool)
    func favoriteStarTapped(object: ShopObject)
}

class HotPepperResponseTableViewCell: UITableViewCell, Reusable {

    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: CopyLabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genreAndStation: CopyLabel!
    @IBOutlet weak var starIcon: UIImageView!
    private var noImageURL = URL(string: "https://www.shoshinsha-design.com/wp-content/uploads/2020/05/noimage-760x460.png")
    var delegate:HotPepperTableViewCellDelegate?
    private var shop:Shop?
    private var object: ShopObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(item: Shop) {
        shop = item
        setImageBySDWebImage(with: item.logoImage ?? noImageURL)
        name.text = item.name
        budget.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(item.stationName ?? "")駅"
        
        let object = RealmManager.getEntityList(type: ShopObject.self)
        for i in 0..<object.count {
            if object[i].name == item.name {
                starIcon.tag = 1
                starIcon.image = UIImage(named: "star_on")
            } else {
                starIcon.image = UIImage(named: "star_off")
            }
        }
    }
    
    func setupFavorite(item: ShopObject) {
        object = item
        starIcon.tag = 1
        starIcon.image = UIImage(named: "star_on")
        setImageBySDWebImage(with: URL(string: item.logoImage))
        name.text = item.name
        budget.text = item.budgetName
        genreAndStation.text = "\(item.genre)/\(item.station)駅"
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
    @IBAction func starTapped(_ sender: Any) {
        if starIcon.tag == 0 {
            starIcon.tag = 1
            starIcon.image = UIImage(named: "star_on")
            if let shop = shop {
                delegate?.starTapped(item: shop, on: true)
            }
        } else {
            starIcon.tag = 0
            if let shop = shop {
                starIcon.image = UIImage(named: "star_off")
                delegate?.starTapped(item: shop, on: false)
            } else if let object = object {
                delegate?.favoriteStarTapped(object: object)
            }
        }
    }
    
}
