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

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = FavoriteViewModel() as FavoriteViewModelType
    private var datasource: RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>?
    
    override func viewWillAppear(_ animated: Bool) {
        //タブバーなのでwillでアップデートする
        viewModel.inputs.updateFavorite.onNext(Void())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //input
        
        
        //output
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
        
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

extension FavoriteViewController: UITableViewDelegate {
    
}
