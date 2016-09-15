//
//  InsetUILabel.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/18/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class InsetUILabel: UILabel {
    @IBInspectable var insetsTop: CGFloat = 0
    @IBInspectable var insetsLeft: CGFloat = 0
    @IBInspectable var insetsRight: CGFloat = 0
    @IBInspectable var insetsBottom: CGFloat = 0
    lazy var insets: UIEdgeInsets = UIEdgeInsets(top: self.insetsTop, left: self.insetsLeft, bottom: self.insetsBottom, right: self.insetsRight)
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
