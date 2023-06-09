//
//  TransformationsViewController.swift
//  CALayerTester
//
//  Created by Robert on 20.04.2023.
//

import UIKit

class TransformationsViewController: UIViewController {

    @IBOutlet weak var xSlider: UISlider!
    @IBOutlet weak var ySlider: UISlider!
    @IBOutlet weak var zSlider: UISlider!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var perspectiveLabel: UILabel!
    @IBOutlet weak var perspectiveSlider: UISlider!
    
    var imageLayer: CALayer!
    var imageRatio: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
        updateLabels()
    }
    
    override func viewWillLayoutSubviews() {
        let width = contentView.frame.width
        let height = imageRatio * width
        let x = CGFloat(0)
        let y = (contentView.frame.height - height) / 2
        
        imageLayer.frame = .init(x: x, y: y, width: width, height: height)
        
        super.viewWillLayoutSubviews()
    }

    @IBAction func sliderDidChange(_ slider: UISlider) {
        updateTransform()
    }
    
    @IBAction func perspectiveDidChange(_ slider: UISlider) {
        updateTransform()
    }
    
    private func updateLabels() {
        xLabel.text = "X: " + String(format: "%.2f", xSlider.value)
        yLabel.text = "Y: " + String(format: "%.2f", ySlider.value)
        zLabel.text = "Z: " + String(format: "%.2f", zSlider.value)
    }
    
    private func updateTransform() {
        // perspective
        let perspective = CGFloat(perspectiveSlider.value * 500 + 1)
        perspectiveLabel.text = "1 / -\(perspective)"
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -perspective
        
        let xAngle = -Double.pi * Double(xSlider.value)
        let yAngle = -Double.pi * Double(ySlider.value)
        let zAngle = -Double.pi * Double(zSlider.value)
        
        transform = CATransform3DRotate(transform, xAngle, 1, 0, 0)
        transform = CATransform3DRotate(transform, yAngle, 0, 1, 0)
        transform = CATransform3DRotate(transform, zAngle, 0, 0, 1)
        
        imageLayer.transform = transform
        
        updateLabels()
    }
    
    private func loadImage() {
        let image = UIImage(named: "eia1956-test-pattern.jpg")!
        imageRatio = image.size.height / image.size.width
        
        imageLayer = CALayer()
        imageLayer.frame = CGRect(origin: .zero, size: contentView.frame.size)
        imageLayer.contents = image.cgImage
        
        contentView.layer.addSublayer(imageLayer)
    }

}
