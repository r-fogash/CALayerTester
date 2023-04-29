//
//  AntAnimationViewController.swift
//  CALayerTester
//
//  Created by Robert on 20.04.2023.
//

import UIKit

class AntAnimationViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    weak var shapeLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupShapeLayer()
    }

    @IBAction func start(_ sender: UIButton) {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.lineDashPhase))
        animation.fromValue = 0
        animation.toValue = -20
        animation.duration = 1
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        shapeLayer?.add(animation, forKey: "line")
    }
    
    private func setupShapeLayer() {
        let layer = CAShapeLayer()
        layer.frame = containerView.bounds
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 50))
        path.addCurve(to: CGPoint(x: containerView.frame.width - 50, y: containerView.frame.height - 10), control1: CGPoint(x: 12, y: 40), control2: CGPoint(x: containerView.frame.width - 150, y: containerView.frame.height))
        
        layer.path = path
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineDashPattern = [ 8,6 ].map { NSNumber(value: $0) }
        layer.lineDashPhase = -2
        
        containerView.layer.addSublayer(layer)
        self.shapeLayer = layer
    }

}
