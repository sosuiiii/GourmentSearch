//
//  FavoriteViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FavoriteViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = ListViewModel()
    private var datasource: RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    private func setupView() {
        tableView.register(UINib(nibName: HotPepperResponseTableViewCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HotPepperResponseTableViewCell.reusableIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        datasource = RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>(configureCell: { _, tableView, indexPath, items in
            let cell = tableView.dequeueReusableCell(withIdentifier: HotPepperResponseTableViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseTableViewCell
            cell.setupFavorite(item: items)
//            cell.delegate = self
            return cell
        })
    }
}
