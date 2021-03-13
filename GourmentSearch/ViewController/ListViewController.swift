//
//  ListViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PKHUD

class ListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = ListViewModel() as ListViewModelType
    private var datasource: RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>?
    private var toolBar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        //MARK: Input
        detailButton.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            let detailView = DetailSearchView(frame: UIScreen.main.bounds)
            detailView.viewModel.outputs.validSearch.bind(to: self.searchBar.rx.text)
                .disposed(by: self.disposeBag)
            self.view.addSubview(detailView)
            self.view.endEditing(true)
            detailView.show()
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.bind(to: viewModel.inputs.searchText).disposed(by: disposeBag)
        
        
        //MARK: Output
        viewModel.outputs.validatedText.bind(to: searchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.datasource.bind(to: tableView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
        
        viewModel.outputs.alert.subscribe({ [weak self] alertType in
            let alertView = AlertView(frame: UIScreen.main.bounds)
            self?.view.addSubview(alertView)
            alertView.show(type: alertType.element!!)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.hud.subscribe({ type in
            HUD.show(type.element!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
                HUD.hide()
            })
        }).disposed(by: disposeBag)
        
        viewModel.outputs.hide.subscribe({ _ in
            HUD.hide()
        }).disposed(by: disposeBag)
    }
}
//MARK: HotPepperTableViewCellDelegate
extension ListViewController: HotPepperTableViewCellDelegate {
    func starTapped(item: Shop?, on: Bool) {
        if let shop = item, on{
            viewModel.inputs.save.onNext(shop)
        } else if let shop = item, !on {
            let name = shop.name
            viewModel.inputs.delete.onNext(name)
        }
    }
}

//MARK: AlertViewDelegate
extension ListViewController: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
    }
    
    func negativeTapped(type: AlertType) {
    }
}
//MARK: UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
//MARK:ビュー
extension ListViewController {
    func setupView() {
        searchBar.delegate = self
        setupToolBar(toolBar, target: self, action: #selector(done))
        searchBar.inputAccessoryView = toolBar
        
        tableView.register(UINib(nibName: HotPepperResponseTableViewCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HotPepperResponseTableViewCell.reusableIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        datasource = RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>(configureCell: { _, tableView, indexPath, items in
            let cell = tableView.dequeueReusableCell(withIdentifier: HotPepperResponseTableViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseTableViewCell
            cell.setupCell(item: items)
            cell.delegate = self
            return cell
        })
    }
    func setupToolBar(_ toolBar: UIToolbar, target: UIViewController, action: Selector) {
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: action)
        toolBar.setItems([spacerItem, doneItem], animated: true)
    }
    @objc func done() {
        searchBar.text = ""
        self.view.endEditing(true)
    }
}
//MARK:UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.inputs.search.onNext(searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
}
