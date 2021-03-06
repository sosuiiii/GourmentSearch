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

class ListViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var disposeBag = DisposeBag()
    private var viewModel = ListViewModel()
    private var datasource: RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>?

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
        
        viewModel.outputs.datasource.bind(to: tableView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
        
        viewModel.outputs.alert.subscribe({ [weak self] alertType in
            if UserDefaults.standard.bool(forKey: "showAlert") {return}
            let alertView = AlertView(frame: UIScreen.main.bounds)
            self?.view.addSubview(alertView)
            alertView.show(type: alertType.element!!)
        }).disposed(by: disposeBag)
    }
}

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
        tableView.register(UINib(nibName: HotPepperResponseTableViewCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HotPepperResponseTableViewCell.reusableIdentifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        datasource = RxTableViewSectionedReloadDataSource<HotPepperResponseDataSource>(configureCell: { _, tableView, indexPath, items in
            let cell = tableView.dequeueReusableCell(withIdentifier: HotPepperResponseTableViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseTableViewCell
            cell.setupCell(item: items)
            return cell
        })
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
