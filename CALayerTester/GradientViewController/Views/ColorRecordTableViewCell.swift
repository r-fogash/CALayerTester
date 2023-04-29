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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
