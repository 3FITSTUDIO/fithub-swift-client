//
//  Label.swift
//  fit-swift-client
//
//  Created by admin on 05/11/2019.
//  Copyright © 2019 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class Label : UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(label: String, fontSize: CGFloat = 15) {
        self.init()
        setup()
        self.text = label
        self.fontSize(size: fontSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.textColor = .white
        self.setFont(fontName: FithubUI.Fonts.mainAvenir)
    }
}
