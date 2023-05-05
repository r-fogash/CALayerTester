//
//  StrokingViewController.swift
//  CALayerTester
//
//  Created by Robert on 04.05.2023.
//

import UIKit

class StrokingViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var strokeStartSlider: UISlider!
    @IBOutlet weak var strokeEndSlider: UISlider!
    @IBOutlet weak var strokeStartLabel: UILabel!
    @IBOutlet weak var strokeEndLabel: UILabel!
    @IBOutlet weak var lineWidthStepper: UIStepper!
    @IBOutlet weak var lineWidthLabel: UILabel!
    
    private var shapeLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolbar = UIToolbar()
        let item = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneInput))
        toolbar.items = [item]
        toolbar.frame = .init(origin: .zero, size: .init(width: view.frame.width, height: 40))
        textView.inputAccessoryView = toolbar
    }
    
    @objc func doneInput() {
        textView.resignFirstResponder()
        applyValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addLinesToStroke()
        applyValues()
        setStrokeProgressSliderValues()
        
        setStokeProgressLabelValues()
        setLineWidthLabelValue()
        setLineWidthStepperValue()
    }
    
    @IBAction func sliderValuesDidChange(_ sender: UISlider) {
        shapeLayer.strokeStart = CGFloat(strokeStartSlider.value)
        shapeLayer.strokeEnd = CGFloat(strokeEndSlider.value)
        
        setStokeProgressLabelValues()
    }
    
    @IBAction func lineWidthDidChangeValue(_ stepper: UIStepper) {
        shapeLayer.lineWidth = stepper.value
        setLineWidthLabelValue()
    }
    
    private func addLinesToStroke() {
        let path = UIBezierPath()
        let startX = CGFloat(10)
        let endX = contentView.bounds.width - 2 * startX
        let y = CGFloat(50)
        path.move(to: .init(x: startX, y: y))
        path.addLine(to: .init(x: endX, y: y))
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineCap = .square
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [NSNumber(value: 20), NSNumber(value: 5)]
        
        contentView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = contentView.layer.bounds
        shapeLayer.contentsGravity = .resizeAspect
    }
    
    fileprivate func setStokeProgressLabelValues() {
        strokeStartLabel.text = String(format: "Stroke start: %0.2f", shapeLayer.strokeStart)
        strokeEndLabel.text = String(format: "Stroke end: %0.2f", shapeLayer.strokeEnd)
    }
    
    fileprivate func setStrokeProgressSliderValues() {
        strokeStartSlider.value = Float(shapeLayer.strokeStart)
        strokeEndSlider.value = Float(shapeLayer.strokeEnd)
    }
    
    private func setLineWidthLabelValue() {
        lineWidthLabel.text = String(format: "Line width: %i", Int(shapeLayer.lineWidth))
    }
    
    private func setLineWidthStepperValue() {
        lineWidthStepper.value = shapeLayer.lineWidth
    }
    
    private func applyValues() {
        guard let text = textView.text,
              text.isEmpty == false else
        {
            shapeLayer.lineDashPattern = nil
            return
        }
        
        var scannedValues = [Int]()
        let scanner = Scanner(string: text)
        scanner.charactersToBeSkipped = nil
        
        var value = 0
        while scanner.scanInt(&value) {
            let searchedChars = NSCharacterSet(charactersIn: "0123456789")
            scannedValues.append(value)
            let _ = scanner.scanUpToCharacters(from: searchedChars as CharacterSet)
        }
        
        print("did scan values \(scannedValues)")
        
        shapeLayer.lineDashPattern = scannedValues.map { NSNumber(value: $0) }
    }

}

extension StrokingViewController: UITextViewDelegate {
    
}
