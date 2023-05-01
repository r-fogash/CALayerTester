//
//  ControlValueLabel.swift
//  CALayerTester
//
//  Created by Robert on 01.05.2023.
//

import UIKit

@IBDesignable
class ControlValueLabel: UILabel {

    private var didConfigure = false
    
    override func layoutSubviews() {
        if didConfigure == false {
            didConfigure = true
            textColor = UIColor(named: "textColor")
            font = UIFont(name: "Arial", size: 15)
        }
        super.layoutSubviews()
    }
    
    func setValue(_ value: Float) {
        setValue(CGFloat(value))
    }
    
    func setValue(_ value: CGFloat) {
        text = String(format: "%0.2f", value)
    }
    
    func setValue(_ color: UIColor) {
        text = color.hexString
    }

}
