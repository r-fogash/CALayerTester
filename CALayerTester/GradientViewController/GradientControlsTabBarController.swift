//
//  GradientControlsTabBarController.swift
//  CALayerTester
//
//  Created by Robert on 28.04.2023.
//

import UIKit

class GradientControlsTabBarController: UITabBarController, GradientSettingsContainer {
    
    var settings: GradientSettings! {
        didSet { populateGradientSettings() }
    }
    
    func populateGradientSettings() {
        viewControllers?
            .compactMap { $0 as? GradientSettingsContainer }
            .forEach { $0.settings = settings }
        
    }


}
