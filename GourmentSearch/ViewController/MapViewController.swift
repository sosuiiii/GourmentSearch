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
        Repository.getGenres().subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func detailTapped(_ sender: Any) {
        let detailView = DetailSearchView(frame: UIScreen.main.bounds)
        view.addSubview(detailView)
        detailView.show()
    }
}
