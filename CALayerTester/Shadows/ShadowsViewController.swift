//
//  ShadowsViewController.swift
//  CALayerTester
//
//  Created by Robert on 05.05.2023.
//

import UIKit

class ShadowsViewController: UIViewController {

    private var shapeLayer: CAShapeLayer!
    private var didSetup = false

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowColorView: UIView!
    @IBOutlet weak var shadowColorLabel: ControlValueLabel!
    @IBOutlet weak var shadowOpacityLabel: UILabel!
    @IBOutlet weak var shadowOpacitySlider: UISlider!
    @IBOutlet weak var shadowRadiusLabel: UILabel!
    @IBOutlet weak var shadowRadiusSlider: UISlider!
    @IBOutlet weak var shadowOffsetXStepper: UIStepper!
    @IBOutlet weak var shadowOffsetXLabel: UILabel!
    @IBOutlet weak var shadowOffsetYStepper: UIStepper!
    @IBOutlet weak var shadowOffsetYLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if didSetup == false {
            didSetup = true
            
            installShapeLayer()
            setInitialColorValues()
            setRadiusLabelValue()
            setRadiusSliderValue()
            setOpacityLabelValue()
            setOpacitySliderValue()
            setShadowOffsetXLabelValue()
            setShadowOffsetXStepperValue()
            setShadowOffsetYLabelValue()
            setShadowOffsetYStepperValue()
        }
    }
    
    @IBAction func onTouchShadowColor() {
        showColorSelector()
    }
    
    @IBAction func onShadowRadiusChange(_ slider: UISlider) {
        shapeLayer.shadowRadius = CGFloat(slider.value)
        setRadiusLabelValue()
    }
    
    @IBAction func onShadowOpacityChange(_ slider: UISlider) {
        shapeLayer.shadowOpacity = slider.value
        setOpacityLabelValue()
    }
    
    @IBAction func onShadowOffsetXChange(_ stepper: UIStepper) {
        var shadowOffset = shapeLayer.shadowOffset
        shadowOffset.width = stepper.value
        shapeLayer.shadowOffset = shadowOffset
        setShadowOffsetXLabelValue()
    }
    
    @IBAction func onShadowOffsetYChange(_ stepper: UIStepper) {
        var shadowOffset = shapeLayer.shadowOffset
        shadowOffset.height = shadowOffsetYStepper.value
        shapeLayer.shadowOffset = shadowOffset
        setShadowOffsetYLabelValue()
    }
    
    private func installShapeLayer() {
        let path = UIBezierPath()
        path.move(to: .init(x: 20, y: 50))
        path.addQuadCurve(to: .init(x: containerView.bounds.width - 30, y: 50), controlPoint: .init(x: containerView.bounds.width/2, y: 120))

        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.shadowColor = UIColor.red.cgColor
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = .init(width: 1, height: -3)
        shapeLayer.shadowRadius = 1
        
        containerView.layer.addSublayer(shapeLayer)
        shapeLayer.frame = containerView.bounds
        shapeLayer.contentsGravity = .resizeAspect
    }
    
    private func showColorSelector() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.title = "Shadow color"
        colorPicker.supportsAlpha = true
        colorPicker.delegate = self
        colorPicker.modalPresentationStyle = .popover
        if let shadowColor = shapeLayer.shadowColor {
            colorPicker.selectedColor = UIColor(cgColor: shadowColor)
        }
        self.present(colorPicker, animated: true)
    }
    
    private func setShadowColor(_ color: UIColor) {
        shadowColorView.backgroundColor = color
        shadowColorLabel.setValue(color)
        shapeLayer.shadowColor = color.cgColor
    }
    
    private func setInitialColorValues() {
        let color = UIColor(cgColor: shapeLayer.shadowColor!)
        setShadowColor(color)
    }
    
    private func setRadiusLabelValue() {
        shadowRadiusLabel.text = String(format: "Radius: %0.2f", shapeLayer.shadowRadius)
    }
    
    private func setRadiusSliderValue() {
        shadowRadiusSlider.value = Float(shapeLayer.shadowRadius)
    }
    
    private func setOpacityLabelValue() {
        shadowOpacityLabel.text = String(format: "Opacity: %0.2f", shapeLayer.opacity)
    }
    
    private func setOpacitySliderValue() {
        shadowOpacitySlider.value = Float(shapeLayer.shadowOpacity)
    }
    
    private func setShadowOffsetXLabelValue() {
        shadowOffsetXLabel.text = String(format: "Shadow offset X: %0.2f", shadowOffsetXStepper.value)
    }
    
    private func setShadowOffsetXStepperValue() {
        shadowOffsetXStepper.value = shapeLayer.shadowOffset.width
    }
    
    private func setShadowOffsetYLabelValue() {
        shadowOffsetYLabel.text = String(format: "Shadow offset Y: %0.2f", shadowOffsetYStepper.value)
    }
    
    private func setShadowOffsetYStepperValue() {
        shadowOffsetYStepper.value = shapeLayer.shadowOffset.height
    }

}


// MARK: UIColorPickerViewControllerDelegate

extension ShadowsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        setShadowColor(viewController.selectedColor)
    }
    
}
