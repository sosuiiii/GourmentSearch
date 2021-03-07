//
//  ModalViewController.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/07.
//

import UIKit
import PanModal
import Instantiate
import InstantiateStandard
import RxSwift
import RxCocoa
import RxDataSources

class ModalViewController: UIViewController, StoryboardInstantiatable  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var datasource: RxCollectionViewSectionedReloadDataSource<HotPepperResponseDataSource>?
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
extension ModalViewController: HotPepperCollectionViewCellDelegate {
    func way(row: Int) {
        //viewModelにrowを送り情報から経路検索
    }
    
    func save(row: Int) {
        //viewModelにrowを送り情報から経路検索
    }
}

//MARK: ビュー
extension ModalViewController {
    func setupView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(UINib(nibName: HotPepperResponseCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: HotPepperResponseCollectionViewCell.reusableIdentifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        datasource = RxCollectionViewSectionedReloadDataSource<HotPepperResponseDataSource>(configureCell: {_, collectionView, indexPath, items in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotPepperResponseCollectionViewCell.reusableIdentifier, for: indexPath) as! HotPepperResponseCollectionViewCell
            cell.setupCell(item: items, row: indexPath.row)
            cell.delegate = self
            return cell
        })
    }
}

extension ModalViewController: UICollectionViewDelegate {
    
}


//MARK: UICollectionViewDelegateFlowLayout
extension ModalViewController: UICollectionViewDelegateFlowLayout {
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


//MARK: ハーフモーダルの設定
extension ModalViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(350)
    }
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height - 350)
    }
    var panModalBackgroundColor: UIColor {
        return .clear
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    var shouldRoundTopCorners: Bool {
        return true
    }
    var showDragIndicator: Bool {
        return true
    }
    var isUserInteractionEnabled: Bool {
        return true
    }
}
