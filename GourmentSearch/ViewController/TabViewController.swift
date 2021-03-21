//
//  TabViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/21.
//

import UIKit

class TabViewController: UITabBarController {
    
    var vcs:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapVC()
        setupListVC()
        setupFavoriteVC()
        self.setViewControllers(vcs, animated: false)
    }
    func setupMapVC() {
        let vm = MapViewModel()
        let dependency = MapViewController.Dependency(viewModel: vm)
        let vc = MapViewController.instantiate(with: dependency)
        vcs.append(vc)
    }
    func setupListVC() {
        let vm = ListViewModel()
        let dependency = ListViewController.Dependency(viewModel: vm)
        let vc = ListViewController.instantiate(with: dependency)
        vcs.append(vc)
    }
    func setupFavoriteVC() {
        let vm = FavoriteViewModel()
        let dependency = FavoriteViewController.Dependency(viewModel: vm)
        let vc = FavoriteViewController.instantiate(with: dependency)
        vcs.append(vc)
    }
}
