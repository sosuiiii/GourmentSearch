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
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = MapViewModel()
    
    override func viewDidLayoutSubviews() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Input
        detailButton.rx.tap.subscribe({ [weak self] _ in
//            let detailView = DetailSearchView(frame: UIScreen.main.bounds)
//            self?.view.addSubview(detailView)
//            detailView.show()
            self?.setupMap()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.subscribe({ [weak self] text in
//            self?.viewModel.inputs.searchText.onNext(text.element!)
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
        
        setupView()
        setupMap()
    }
}

extension MapViewController: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
    }
    
    func negativeTapped(type: AlertType) {
    }
}
//MARK:ビュー
extension MapViewController {
    func setupView() {
        searchBar.delegate = self
        
    }
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.68154,                                                      longitude: 139.752498, zoom: 13)
                mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//                mapView.isMyLocationEnabled = true
        
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(35.68154,139.752498)
                marker.title = "The Imperial Palace"
                marker.snippet = "Tokyo"
                marker.map = mapView
    }
}
//MARK:UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.inputs.search.onNext(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
