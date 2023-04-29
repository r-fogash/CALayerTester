//
//  ColorRecordTableViewCell.swift
//  CALayerTester
//
//  Created by Robert on 26.04.2023.
//

import UIKit

class ColorRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var colorPreview: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var colorRecord: GradientSettings.ColorRecord!
    var settings: GradientSettings!
    
    func fill(_ colorRecord: GradientSettings.ColorRecord) {
        colorLabel.text = colorRecord.color.hexString
        colorPreview.backgroundColor = colorRecord.color
        positionLabel.text = String(format: "%.3f", colorRecord.position)
        slider.value = Float(colorRecord.position)
        self.colorRecord = colorRecord
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        colorRecord.position = CGFloat(sender.value)
        positionLabel.text = String(format: "%.3f", colorRecord.position)
        settings.didUpdateColorsLocation()
    }
}
