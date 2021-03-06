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

class DetailSearchView: UIView, Reusable {
    
    @IBOutlet var baseView: AnimatableView!
    
    @IBOutlet weak var genreArrowImage: UIImageView!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lengthArrowImage: UIImageView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var lengthButton: UIButton!
    @IBOutlet weak var scrollView: SubUIScrollView!
    
    @IBOutlet weak var feeArrowImage: UIImageView!
    @IBOutlet weak var feeView: UIView!
    @IBOutlet weak var feeButton: UIButton!
    
    @IBOutlet weak var otherArrowImage: UIImageView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        setupRx()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initializeView() {
        let view = Bundle.main.loadNibNamed(DetailSearchView.reusableIdentifier, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        genreArrowImage.transform = .init(rotationAngle: (CGFloat.pi / 2))
        addSubview(view)
    }
    func setupRx() {
    }
    
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
    @IBAction func resetButtonTapped(_ sender: Any) {
        let alertView = AlertView(frame: UIScreen.main.bounds)
        alertView.delegate = self
        addSubview(alertView)
        alertView.show(type: .reset)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        let alertView = AlertView(frame: UIScreen.main.bounds)
        alertView.delegate = self
        addSubview(alertView)
        alertView.show(type: .save)
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        let alertView = AlertView(frame: UIScreen.main.bounds)
        alertView.delegate = self
        addSubview(alertView)
        alertView.show(type: .noSave)
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
