//
//  DetailSearchView.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Instantiate
import InstantiateStandard
import IBAnimatable
import RxDataSources
import RxSwift
import RxCocoa

protocol DetailSearchViewDelegate: class {
    func save()
    func reset()
    func close()
}

class DetailSearchView: UIView, Reusable {
    
    @IBOutlet var baseView: AnimatableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    //ジャンル
    @IBOutlet weak var genreArrowImage: UIImageView!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //距離
    @IBOutlet weak var lengthArrowImage: UIImageView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var lengthButton: UIButton!
    @IBOutlet weak var scrollView: SubUIScrollView!
    @IBOutlet weak var lengthFirst: UIButton!
    @IBOutlet weak var lengthSecond: UIButton!
    @IBOutlet weak var lengthThird: UIButton!
    @IBOutlet weak var lengthFourth: UIButton!
    @IBOutlet weak var lengthFifth: UIButton!
    
    //料金
    @IBOutlet weak var feeArrowImage: UIImageView!
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var feeButton: UIButton!
    @IBOutlet weak var feeField: UITextField!
    
    //こだわり
    @IBOutlet weak var otherArrowImage: UIImageView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var withWifi: UIButton!
    @IBOutlet weak var withPersonalSpace: UIButton!
    @IBOutlet weak var credit: UIButton!
    @IBOutlet weak var freeFood: UIButton!
    @IBOutlet weak var freeDrink: UIButton!
    @IBOutlet weak var japLiquor: UIButton!
    @IBOutlet weak var shochu: UIButton!
    @IBOutlet weak var cocktail: UIButton!
    @IBOutlet weak var wine: UIButton!
    @IBOutlet weak var numberOfPeople: UITextField!
    
    weak var delegate: DetailSearchViewDelegate?
    var viewModel = DetailSearchViewModel()
    private var datasource: RxCollectionViewSectionedReloadDataSource<GenreDataSource>?
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        setupRx()
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Input/Output
    func setupView() {
        
        searchBar.delegate = self
        closeButton.rx.tap.subscribe({ [weak self] _ in
            let alertView = AlertView(frame: UIScreen.main.bounds)
            alertView.delegate = self
            self?.addSubview(alertView)
            alertView.show(type: .noSave)
        }).disposed(by: disposeBag)
        
        resetButton.rx.tap.subscribe({ [weak self] _ in
            let alertView = AlertView(frame: UIScreen.main.bounds)
            alertView.delegate = self
            self?.addSubview(alertView)
            alertView.show(type: .reset)
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.subscribe({ [weak self] _ in
            let alertView = AlertView(frame: UIScreen.main.bounds)
            alertView.delegate = self
            self?.addSubview(alertView)
            alertView.show(type: .save)
        }).disposed(by: disposeBag)
        
        
        
        viewModel.outputs.items.bind(to: collectionView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
    }
    
    func show() {
        baseView.animate(.slide(way: .in, direction: .up), duration: 0.5, damping: nil, velocity: nil, force: nil).delay(0.1)
        UIApplication.shared.windows.first{$0.isKeyWindow}?.addSubview(self)
    }
    private func dismiss() {
        baseView.animate(.slide(way: .out, direction: .down), duration: 0.5, damping: nil, velocity: nil, force: nil).completion {
            self.removeFromSuperview()
        }
    }
}
//MARK: AlertViewDelegate
extension DetailSearchView: AlertViewDelegate {
    func positiveTapped(type: AlertType) {
        switch type {
        case .save:
            dismiss()
        case .noSave:
            dismiss()
        case .reset:
            dismiss()
        default:
            break
        }
    }
    
    func negativeTapped(type: AlertType) {
        switch type {
        case .noSave:
            dismiss()
        case .reset:
            dismiss()
        default:
            break
        }
    }
}

//MARK: UISearchBarDelegate
extension DetailSearchView: UISearchBarDelegate {
    
}









//MARK: CollectionViewDelegate,DataSource
extension DetailSearchView:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.reusableIdentifier, for: indexPath) as! GenreCollectionViewCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: ビュー
extension DetailSearchView {
    
    @IBAction func genreTapped(_ sender: Any) {
        openCloseAnimation(view: genreView, image: genreArrowImage)
    }
    @IBAction func lengthTapped(_ sender: UIButton) {
        openCloseAnimation(view: lengthView, image: lengthArrowImage)
    }
    @IBAction func feeTapped(_ sender: Any) {
        openCloseAnimation(view: feeView, image: feeArrowImage)
    }
    @IBAction func otherTapped(_ sender: Any) {
        openCloseAnimation(view: otherView, image: otherArrowImage)
    }
    
    func initializeView() {
        let view = Bundle.main.loadNibNamed(DetailSearchView.reusableIdentifier, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        genreArrowImage.transform = .init(rotationAngle: (CGFloat.pi / 2))
        addSubview(view)
    }
    
    func setupRx() {
        collectionView.register(UINib(nibName: GenreCollectionViewCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: GenreCollectionViewCell.reusableIdentifier)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        datasource = RxCollectionViewSectionedReloadDataSource<GenreDataSource>(configureCell:{ _, startCollectionView, indexPath, items in
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.reusableIdentifier, for: indexPath) as! GenreCollectionViewCell
        
            cell.setupCell(item: items)
            return cell
        })
    }
    
    func openCloseAnimation(view: UIView, image: UIImageView) {
        UIView.animate(withDuration: 0.3, animations: {
            if !view.isHidden {
                image.transform = .init(rotationAngle: 0)
                view.alpha = 0
            } else {
                image.transform = .init(rotationAngle: (CGFloat.pi / 2))
                view.alpha = 1
            }
            view.isHidden.toggle()
        })
    }
}
