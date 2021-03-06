//
//  AlertView.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit
import Instantiate
import InstantiateStandard
import IBAnimatable
import RxSwift
import RxCocoa

enum AlertType {
    case noSave
    case save
    case reset
    case delete
    case error
    case textOver
    case unexpectedServerError
}

protocol AlertViewDelegate: class {
    func positiveTapped(type: AlertType)
    func negativeTapped(type: AlertType)
}

class AlertView: UIView, Reusable {
    
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popView: AnimatableView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    private var disposeBag = DisposeBag()
    weak var delegate:AlertViewDelegate?
    private var type:AlertType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        
        positiveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)
        
        negativeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)
    }
    
    func initializeView() {
        let view = Bundle.main.loadNibNamed(AlertView.reusableIdentifier, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    @IBAction func positiveTapped(_ sender: Any) {
        delegate?.positiveTapped(type: type!)
        dismiss()
    }
    @IBAction func negativeTapped(_ sender: Any) {
        delegate?.negativeTapped(type: type!)
        dismiss()
    }
    
    
    func show(type: AlertType) {
        print(UserDefaults.standard.bool(forKey: "showAlert"))
        
        if UserDefaults.standard.bool(forKey: "showAlert") {return}
        
        UserDefaults.standard.setValue(true, forKey: "showAlert")
        print(UserDefaults.standard.bool(forKey: "showAlert"))
        
        self.type = type
        switch type {
        case .noSave:
            message.text = "保存せずに終了しますか？"
            positiveButton.setTitle("終了する", for: .normal)
            negativeButton.setTitle("終了しない", for: .normal)
        case .save:
            message.text = "条件を保存しました"
            positiveButton.setTitle("閉じる", for: .normal)
            negativeButton.isHidden = true
        case .reset:
            message.text = "検索条件をリセットしますか？"
            positiveButton.setTitle("リセットする", for: .normal)
            negativeButton.setTitle("リセットしない", for: .normal)
        case .delete:
            message.text = "本当に削除しますか？"
            positiveButton.setTitle("削除する", for: .normal)
            negativeButton.setTitle("削除しない", for: .normal)
        case .error:
            message.text = "エラーが発生しました。\n時間をおいてもう一度\n操作を試してください。"
            positiveButton.setTitle("閉じる", for: .normal)
            negativeButton.isHidden = true
        case .textOver:
            message.text = "文字数が50文字を超過しています。"
            positiveButton.setTitle("閉じる", for: .normal)
            negativeButton.isHidden = true
        case .unexpectedServerError:
            message.text = "予期せぬサーバーエラーが起きました"
            positiveButton.setTitle("閉じる", for: .normal)
            negativeButton.isHidden = true
        }
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        popView.animate(.zoomInvert(way: .in), duration: 0.5, damping: nil, velocity: nil, force: nil).delay(0.1)
    }
    private func dismiss() {
        UserDefaults.standard.setValue(false, forKey: "showAlert")
        print(UserDefaults.standard.bool(forKey: "showAlert"))
        backgroundView.backgroundColor = .clear
        popView.animate(.zoomInvert(way: .out), duration: 0.5, damping: nil, velocity: nil, force: nil).completion {
            self.removeFromSuperview()
        }
    }
}
