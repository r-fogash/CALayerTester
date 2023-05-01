//
//  LayerTypeViewController.swift
//  CALayerTester
//
//  Created by Robert on 28.04.2023.
//

import UIKit

class LayerTypeViewController: UIViewController, GradientSettingsContainer {

    var settings: GradientSettings!
    
    @IBOutlet weak var startXSlider: UISlider!
    @IBOutlet weak var stopXSlider: UISlider!
    @IBOutlet weak var startYSlider: UISlider!
    @IBOutlet weak var stopYSlider: UISlider!
    
    @IBOutlet weak var startXLabel: ControlValueLabel!
    @IBOutlet weak var startYLabel: ControlValueLabel!
    @IBOutlet weak var stopXLabel: ControlValueLabel!
    @IBOutlet weak var stopYLabel: ControlValueLabel!
    
    @IBOutlet weak var gradientTypeSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGradientTypeSegmentedSelector()
        updateLabelValues()
        updateSliderValues()
    }
    
    @IBAction func sliderValueDidChange(_ slider: UISlider) {
        let value = CGFloat(slider.value)
        switch slider {
        case startXSlider: settings.startPoint.x = value
        case startYSlider: settings.startPoint.y = value
        case stopXSlider: settings.endPoint.x = value
        case stopYSlider: settings.endPoint.y = value
        default: break
        }
        updateLabelValues()
    }
    
    @IBAction func gradientTypeDidChange(_ segmentedControl: UISegmentedControl) {
        settings.gradientType = GradientSettings.GradientType.allCases[segmentedControl.selectedSegmentIndex]
    }
    
    private func updateGradientTypeSegmentedSelector() {
        gradientTypeSegmentControl.selectedSegmentIndex = GradientSettings.GradientType.allCases.firstIndex(of: settings.gradientType)!
    }
    
    private func updateLabelValues() {
        guard isViewLoaded else { return }
        
        startXLabel.setValue(settings.startPoint.x)
        startYLabel.setValue(settings.startPoint.y)
        stopXLabel.setValue(settings.endPoint.x)
        stopYLabel.setValue(settings.endPoint.y)
    }
    
    private func updateSliderValues() {
        startXSlider.value = Float(settings.startPoint.x)
        startYSlider.value = Float(settings.startPoint.y)
        stopXSlider.value = Float(settings.endPoint.x)
        stopYSlider.value = Float(settings.endPoint.y)
    }

}
