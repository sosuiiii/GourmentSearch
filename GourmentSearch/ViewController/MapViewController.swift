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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //MARK: Input
        detailButton.rx.tap.subscribe({ [weak self] _ in
            let detailView = DetailSearchView(frame: UIScreen.main.bounds)
            self?.view.addSubview(detailView)
            detailView.show()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.subscribe({ [weak self] text in
            self?.viewModel.inputs.searchText.onNext(text.element!)
        }).disposed(by: disposeBag)
        
        
        
        //MARK: Output
        viewModel.outputs.validatedText.bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.alert.subscribe({ [weak self] alertType in
            if UserDefaults.standard.bool(forKey: "showAlert") {return}
            let alertView = AlertView(frame: UIScreen.main.bounds)
            self?.view.addSubview(alertView)
            alertView.show(type: alertType.element!!)
        }).disposed(by: disposeBag)
    }
}

extension MapViewController: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
    }
    
    func negativeTapped(type: AlertType) {
    }
}
//ビュー
extension MapViewController {
    func setupView() {
        searchBar.delegate = self
    }
}
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
