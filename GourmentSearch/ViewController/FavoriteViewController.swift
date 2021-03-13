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
import PKHUD

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = FavoriteViewModel() as FavoriteViewModelType
    private var datasource: RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>?
    private var name = ""
    
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
        
        viewModel.outputs.hud.subscribe({ type in
            HUD.show(type.element!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                HUD.hide()
            })
        }).disposed(by: disposeBag)
        
    }
    
    
}
//MARK: HotPepperTableViewCellDelegate
extension FavoriteViewController: HotPepperTableViewCellDelegate {
    func favoriteStarTapped(object: ShopObject) {
        name = object.name
        let alert = AlertView(frame: UIScreen.main.bounds)
        alert.delegate = self
        view.addSubview(alert)
        alert.show(type: .delete)
    }
    
    func starTapped(item: Shop?, on: Bool) {
    }
}
//MARK: AlertViewDelegate
extension FavoriteViewController: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
            viewModel.inputs.delete.onNext(name)
    }
    func negativeTapped(type: AlertType) {
    }
}

//MARK: ビュー
extension FavoriteViewController {
    private func setupView() {
        tableView.register(UINib(nibName: HotPepperResponseTableViewCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HotPepperResponseTableViewCell.reusableIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        datasource = RxTableViewSectionedReloadDataSource<FavoriteShopDataSource>(configureCell: { _, tableView, indexPath, items in
            let cell = tableView.dequeueReusableCell(withIdentifier: HotPepperResponseTableViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseTableViewCell
            cell.setupFavorite(item: items)
            cell.delegate = self
            return cell
        })
    }
}

//MARK: UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
