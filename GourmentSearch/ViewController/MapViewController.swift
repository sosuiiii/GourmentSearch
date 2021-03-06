//
//  MapViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let detailView = DetailSearchView(frame: UIScreen.main.bounds)
        view.addSubview(detailView)
        detailView.show()
    }
}
