//
//  TabViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/21.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([
            createMapViewController(),
            createListViewController(),
            createFavoriteViewController()
        ], animated: false)
    }
    private func createMapViewController() -> UIViewController {
        let mapViewModel = MapViewModel()
        let dependency = MapViewController.Dependency(viewModel: mapViewModel)
        let mapViewController = MapViewController.instantiate(with: dependency)
        return mapViewController
    }
    private func createListViewController() -> UIViewController {
        let listViewModel = ListViewModel()
        let dependency = ListViewController.Dependency(viewModel: listViewModel)
        let listViewController = ListViewController.instantiate(with: dependency)
        return listViewController
    }
    private func createFavoriteViewController() -> UIViewController {
        let favoriteViewModel = FavoriteViewModel()
        let dependency = FavoriteViewController.Dependency(viewModel: favoriteViewModel)
        let favoriteViewController = FavoriteViewController.instantiate(with: dependency)
        return favoriteViewController
    }
}
