//
//  GradientSettings.swift
//  CALayerTester
//
//  Created by Robert on 28.04.2023.
//

import UIKit
import Combine

class GradientSettings {
    enum GradientType: CaseIterable {
        case axial
        case radial
        case conic
    }
    
    class ColorRecord {
        var color: UIColor
        var position: CGFloat
        
        init(color: UIColor, position: CGFloat) {
            self.color = color
            self.position = position
        }
    }
    
    @Published
    var startPoint: CGPoint = .init(x: 0, y: 0.5)
    @Published
    var endPoint: CGPoint = .init(x: 1, y: 0.5)
    @Published
    var gradientType: GradientType = .axial
    
    @Published
    var colors: [ColorRecord] = [
        .init(color: .red, position: 0.33),
        .init(color: .green, position: 0.66),
        .init(color: .blue, position: 1)
    ]
    
    var didUpdateColorLocations: ( () -> Void )?
    
    init() {
        colors = calculateLocations(for: colors)
    }
    
    func addColor(_ color: UIColor) {
        var updatedColors = colors
        updatedColors.append(.init(color: color, position: 1))
        
        colors = calculateLocations(for: updatedColors)
    }
    
    func deleteColor(at index: Int) {
        let updatedColors = colors
        colors = calculateLocations(for: updatedColors)
    }
    
    func calculateLocations(for colors: [ColorRecord]) -> [ColorRecord] {
        let mColors = colors
        let numberOfColors = mColors.count
        
        if numberOfColors == 0 {
            return mColors
        }
        if numberOfColors == 1 {
            mColors[0].position = 1
        }
        
        let start = CGFloat(0)
        mColors[0].position = start
        
        let step: CGFloat = 1 / CGFloat(numberOfColors - 1)
        for i in 1..<numberOfColors {
            mColors[i].position = start + CGFloat(i) * step
        }
        return mColors
    }
    
    func didUpdateColorsLocation() {
        didUpdateColorLocations?()
    }
}
