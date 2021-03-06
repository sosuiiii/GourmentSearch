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
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var listButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private var viewModel = MapViewModel()
    private var datasource: RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>?
    private var marker = GMSMarker()
    private var locationManager = CLLocationManager()
    private var modalVC = ModalViewController.instantiate()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMap()
        
        //MARK: Input
        detailButton.rx.tap.subscribe({ [weak self] _ in
            let detailView = DetailSearchView(frame: UIScreen.main.bounds)
            self?.view.addSubview(detailView)
            detailView.show()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.subscribe({ [weak self] text in
            self?.viewModel.inputs.searchText.onNext(text.element!)
        }).disposed(by: disposeBag)
        
        listButton.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.presentPanModal(self.modalVC)
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

//MARK: GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
//        print(coordinate)
        
        marker.position = coordinate
        marker.title = "The Imperial Palace"
        marker.snippet = "Tokyo"
        marker.map = mapView
        self.mapView = mapView
        
    }
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        print(position)
//    }
    
}
//MARK:ビュー
extension MapViewController {
    func setupView() {
        searchBar.delegate = self
        mapView.delegate = self
    }
    func setupMap() {
        mapView.animate(toZoom: 16)
        let location = CLLocationCoordinate2DMake(35.68154,139.752498)
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.animate(toLocation: locationManager.location?.coordinate ?? location)
        } else {
            mapView.animate(toLocation: location)
        }
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
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

//MARK: AlertViewDelegate
extension MapViewController: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
    }
    
    func negativeTapped(type: AlertType) {
    }
}
