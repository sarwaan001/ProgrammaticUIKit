//
//  DetailScrollView.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/14/21.
//

import UIKit

class DetailScrollView: UIScrollView {
    
//    weak var scrollView: UIScrollView!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
//        print(subview.height)
        self.contentSize = CGSize(width: self.width, height: self.height+subview.height)
    }

}
