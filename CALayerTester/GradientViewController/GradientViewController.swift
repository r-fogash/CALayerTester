//
//  GradientViewController.swift
//  Gradientlayer
//
//  Created by Robert on 30.05.2022.
//

import UIKit
import CoreGraphics
import CoreImage
import Combine

class GradientViewController: UIViewController, GradientSettingsContainer {
    
    @IBOutlet weak var gradientView: UIView!

    var gradientLayer: CAGradientLayer!
    var settings: GradientSettings! = GradientSettings()
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        
        children.forEach {
            ($0 as? GradientSettingsContainer)?.settings = settings
        }
        
        settings.$startPoint.sink { [unowned self] point in
            gradientLayer.startPoint = point
        }.store(in: &bag)
        
        settings.$endPoint.sink { [unowned self] point in
            gradientLayer.endPoint = point
        }.store(in: &bag)
        
        settings.$gradientType.sink { [unowned self] type in
            switch type {
            case .axial: gradientLayer.type = .axial
            case .conic: gradientLayer.type = .conic
            case .radial: gradientLayer.type = .radial
            }
        }.store(in: &bag)
        
        settings.$colors.sink { [unowned self] colors in
            gradientLayer.colors = colors.map { $0.color.cgColor }
            gradientLayer.locations = colors.map { NSNumber(value: $0.position) }
        }.store(in: &bag)
        
    }

    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.white.withAlphaComponent(0).cgColor
        gradientLayer.frame = gradientView.bounds
        gradientLayer.contentsGravity = .resizeAspect
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
