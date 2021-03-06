//
//  HotPepperResponseTableViewCell.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Instantiate
import InstantiateStandard

class HotPepperResponseTableViewCell: UITableViewCell, Reusable {

    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var genreAndStation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(item: Shop) {
        logoImage.image = getImageFromURL(url: item.logoImage)
        name.text = item.name
        budget.text = item.budget?.name
        genreAndStation.text = "\(item.genre.name)/\(item.stationName ?? "")駅"
    }
    
    func getImageFromURL(url: URL?) -> UIImage {
        let url = url
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
}
