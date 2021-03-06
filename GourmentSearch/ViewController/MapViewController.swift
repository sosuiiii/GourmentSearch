//
//  MapViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MapViewController: UIViewController {
    
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func detailTapped(_ sender: Any) {
        let detailView = DetailSearchView(frame: UIScreen.main.bounds)
        view.addSubview(detailView)
        detailView.show()
    }
}
