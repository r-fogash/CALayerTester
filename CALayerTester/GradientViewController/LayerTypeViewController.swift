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
    
    @IBOutlet weak var startXLabel: UILabel!
    @IBOutlet weak var startYLabel: UILabel!
    @IBOutlet weak var stopXLabel: UILabel!
    @IBOutlet weak var stopYLabel: UILabel!
    
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
    
    func updateLabelValues() {
        guard isViewLoaded else { return }
        
        startXLabel.text = String(format: "%0.3f", settings.startPoint.x)
        startYLabel.text = String(format: "%0.3f", settings.startPoint.y)
        stopXLabel.text = String(format: "%0.3f", settings.endPoint.x)
        stopYLabel.text = String(format: "%0.3f", settings.endPoint.y)
    }
    
    func updateSliderValues() {
        startXSlider.value = Float(settings.startPoint.x)
        startYSlider.value = Float(settings.startPoint.y)
        stopXSlider.value = Float(settings.endPoint.x)
        stopYSlider.value = Float(settings.endPoint.y)
    }
    
    func updateGradientTypeSegmentedSelector() {
        gradientTypeSegmentControl.selectedSegmentIndex = GradientSettings.GradientType.allCases.firstIndex(of: settings.gradientType)!
    }

}
