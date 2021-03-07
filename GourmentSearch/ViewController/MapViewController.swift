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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = MapViewModel()
    private var datasource: RxCollectionViewSectionedReloadDataSource<HotPepperResponseDataSource>?
    private var marker = GMSMarker()
    private var locationManager = CLLocationManager()
    private var shown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRx()
        setupMap()
        collectionView.transform = .init(translationX: 0, y: 250)
        
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
            self.openClose()
        }).disposed(by: disposeBag)
        
        
        //MARK: Output
        viewModel.outputs.validatedText.bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.alert.subscribe({ [weak self] alertType in
            if AlertShareManager.shared.shown {return}
            let alertView = AlertView(frame: UIScreen.main.bounds)
            self?.view.addSubview(alertView)
            alertView.show(type: alertType.element!!)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.datasource.subscribe({ data in
            print(data)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.datasource.bind(to: collectionView.rx.items(dataSource: datasource!)).disposed(by: disposeBag)
        
        viewModel.outputs.showCell.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.listButton.backgroundColor = .white
            self.listButton.isEnabled = true
            if self.shown { return }
            self.openClose()
        }).disposed(by: disposeBag)
        
        
    }
    func openClose() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            if !self.shown {
                self.listButton.transform = .init(translationX: 0, y: -170)
                self.collectionView.transform = .init(translationX: 0, y: 0)
            } else {
                self.listButton.transform = .init(translationX: 0, y: 0)
                self.collectionView.transform = .init(translationX: 0, y: 250)
            }
        }, completion: { _ in
            self.shown.toggle()
        })
    }
}

extension MapViewController: UICollectionViewDelegate{
}


//MARK: UICollectionViewDelegateFlowLayout
extension MapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.85
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    func setupRx() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UINib(nibName: HotPepperResponseCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: HotPepperResponseCollectionViewCell.reusableIdentifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        datasource = RxCollectionViewSectionedReloadDataSource<HotPepperResponseDataSource>(configureCell: {_, collectionView, indexPath, items in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotPepperResponseCollectionViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseCollectionViewCell
            cell.setupCell(item: items, row: indexPath.row)
            return cell
        })
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
