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
    private var toolBar = UIToolbar()
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
        saveButton.isHidden = true
        setupToolBar(toolBar, target: self, action: #selector(done))
        feeField.inputAccessoryView = toolBar
        
        
        //MARK: 閉じる、リセット
        closeButton.rx.tap.subscribe({ [weak self] _ in
            self?.dismiss()
        }).disposed(by: disposeBag)
        
        resetButton.rx.tap.subscribe({ [weak self] _ in
            let alertView = AlertView(frame: UIScreen.main.bounds)
            alertView.delegate = self
            self?.addSubview(alertView)
            alertView.show(type: .reset)
        }).disposed(by: disposeBag)
        
        //MARK: ジャンル
        collectionView.rx.itemSelected.subscribe({ indexPath in
            guard let indexPath = indexPath.element else {return}
            let genre = GenreShareManager.shared.genres[indexPath.row]
            QueryShareManager.shared.addQuery(key: "genre", value: genre.code)
        }).disposed(by: disposeBag)
        
        //MARK: 距離
        //~300m
        lengthFirst.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.lengthTapped.onNext(1)
        }).disposed(by: disposeBag)
        //~500m
        lengthSecond.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.lengthTapped.onNext(2)
        }).disposed(by: disposeBag)
        //~1000m
        lengthThird.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.lengthTapped.onNext(3)
        }).disposed(by: disposeBag)
        //~2000m
        lengthFourth.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.lengthTapped.onNext(4)
        }).disposed(by: disposeBag)
        //~3000m
        lengthFifth.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.lengthTapped.onNext(5)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.activeLength.subscribe({ [weak self] int in
            guard let self = self else {return}
            let buttons = [self.lengthFirst, self.lengthSecond, self.lengthThird,
                           self.lengthFourth, self.lengthFifth]
            for i in 0...4 {
                if i + 1 == int.element! {
                    self.activeLength(button: buttons[i]!, active: true)
                } else {
                    self.activeLength(button: buttons[i]!, active: false)
                }
            }
        }).disposed(by: disposeBag)
        
        //MARK:料金
        feeField.rx.text.orEmpty.bind(to: viewModel.inputs.feeInput).disposed(by: disposeBag)
        
        viewModel.outputs.validFee.bind(to: feeField.rx.text).disposed(by: disposeBag)
        
        //MARK:こだわり条件
        withWifi.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.withWifi.tag)
            self.activeOther(button: self.withWifi)
        }).disposed(by: disposeBag)
        withPersonalSpace.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.withPersonalSpace.tag)
            self.activeOther(button: self.withPersonalSpace)
        }).disposed(by: disposeBag)
        credit.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.credit.tag)
            self.activeOther(button: self.credit)
        }).disposed(by: disposeBag)
        freeFood.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.freeFood.tag)
            self.activeOther(button: self.freeFood)
        }).disposed(by: disposeBag)
        freeDrink.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.freeDrink.tag)
            self.activeOther(button: self.freeDrink)
        }).disposed(by: disposeBag)
        japLiquor.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.japLiquor.tag)
            self.activeOther(button: self.japLiquor)
        }).disposed(by: disposeBag)
        shochu.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.shochu.tag)
            self.activeOther(button: self.shochu)
        }).disposed(by: disposeBag)
        cocktail.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.cocktail.tag)
            self.activeOther(button: self.cocktail)
        }).disposed(by: disposeBag)
        wine.rx.tap.subscribe({ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.inputs.wifi.onNext(self.wine.tag)
            self.activeOther(button: self.wine)
        }).disposed(by: disposeBag)
        numberOfPeople.rx.text.orEmpty.bind(to: viewModel.inputs.numberOfPeople).disposed(by: disposeBag)
        
        viewModel.outputs.resetOtherOutput.subscribe({ [weak self] _ in
            guard let self = self else {return}
            let buttons = [self.withWifi, self.withPersonalSpace, self.credit, self.freeFood, self.freeDrink, self.japLiquor, self.shochu,self.cocktail,self.wine]
            for button in buttons {
                self.activeOther(button: button ?? UIButton(), reset: true)
            }
        }).disposed(by: disposeBag)
        
        
        
        //MARK:アラート
        viewModel.outputs.alert.subscribe({ [weak self] type in
            if AlertShareManager.shared.shown {return}
            let alertView = AlertView(frame: UIScreen.main.bounds)
            self?.addSubview(alertView)
            alertView.show(type: .feeOver)
        }).disposed(by: disposeBag)
    }
    
    
    @objc func done() {
        if feeField.text == "" {
            viewModel.inputs.feeInput.onNext("")
        }
        endEditing(true)
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
            QueryShareManager.shared.resetQuery()
            viewModel.inputs.lengthTapped.onNext(99)
            collectionView.reloadData()
            feeField.text = nil
            numberOfPeople.text = nil
            viewModel.inputs.resetOther.onNext(Void())
        default:
            break
        }
    }
    
    func negativeTapped(type: AlertType) {
        switch type {
        case .noSave:
            dismiss()
        case .reset:
            break
        default:
            break
        }
    }
}

//MARK: UISearchBarDelegate
extension DetailSearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
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
        viewModel.outputs.items.bind(to: collectionView.rx.items(dataSource: datasource!))
            .disposed(by: disposeBag)
    }
    func activeLength(button: UIButton, active: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if active {
                button.backgroundColor = .systemYellow
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            }
        })
    }
    func activeOther(button: UIButton, reset: Bool = false) {
        if reset {
            button.tag = 0
            button.setImage(UIImage(named: "check_off"), for: .normal)
            return
        }
        
        if button.tag == 0 {
            button.tag = 1
            button.setImage(UIImage(named: "check_on"), for: .normal)
        } else {
            button.tag = 0
            button.setImage(UIImage(named: "check_off"), for: .normal)
        }
        
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
    func setupToolBar(_ toolBar: UIToolbar, target: UIView, action: Selector) {
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let spacerItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        toolBar.setItems([spacerItem, doneItem], animated: true)
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
