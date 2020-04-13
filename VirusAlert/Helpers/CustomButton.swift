//
//  CustomButton.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/13/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            imageEdgeInsets = .init(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
}
