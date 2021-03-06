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

class ModalViewController: UIViewController, StoryboardInstantiatable  {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .systemBlue
        // Do any additional setup after loading the view.
        
    }
}

extension ModalViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
            return nil
        }
        // モーダルの高さを画面下端から200にする(モーダルを表示した時のデフォルトの高さ)
        var shortFormHeight: PanModalHeight {
            return .contentHeight(350)
        }
        // モーダルの高さを画面上端から最大400に制限する
        // この値を設定しないとモーダルが画面の一番上までスワイプできてしまう
        var longFormHeight: PanModalHeight {
            return .maxHeightWithTopInset(UIScreen.main.bounds.height - 350)
        }
        // モーダルの背景色
        var panModalBackgroundColor: UIColor {
            return .clear
        }
        // 上にスワイプできるかどうか(デフォルトではtrue)
        var anchorModalToLongForm: Bool {
            return false
        }
        // モーダル上端の角に丸みをつけるかどうか
        var shouldRoundTopCorners: Bool {
            return true
        }
        // ホームボタンがないスマホのホームバーみたいなやつを表示するかどうか
        var showDragIndicator: Bool {
            return true
        }
        // 表示したモーダルをユーザーが操作できるかどうか(falseにすると操作できなくなる)
        var isUserInteractionEnabled: Bool {
            return true
        }
}
