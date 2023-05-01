//
//  ColorRecordTableViewCell.swift
//  CALayerTester
//
//  Created by Robert on 26.04.2023.
//

import UIKit

class ColorRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var colorPreview: UIView!
    @IBOutlet weak var colorLabel: ControlValueLabel!
    @IBOutlet weak var positionLabel: ControlValueLabel!
    @IBOutlet weak var slider: UISlider!
    
    var colorRecord: GradientSettings.ColorRecord!
    var settings: GradientSettings!
    
    func fill(_ colorRecord: GradientSettings.ColorRecord) {
        self.colorRecord = colorRecord
        colorLabel.setValue(colorRecord.color)
        colorPreview.backgroundColor = colorRecord.color
        updateColorLocationLabel()
        slider.value = Float(colorRecord.position)
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        colorRecord.position = CGFloat(sender.value)
        updateColorLocationLabel()
        settings.didUpdateColorsLocation()
    }
    
    private func updateColorLocationLabel() {
        guard let colorRecord else {
            return
        }
        positionLabel.setValue(colorRecord.position)
    }
}
