//
//  SubUIScrollView.swift
//  GourmentSearch
//
//  Created by TanakaSoushi on 2021/03/06.
//

import UIKit

class SubUIScrollView: UIScrollView {
    
    /// ScrollView上のボタン上でドラッグした時、ドラッグを優先する(tagを1にしておく
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if (view.tag == 1) {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
