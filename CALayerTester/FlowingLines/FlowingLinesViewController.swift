//
//  FlowingLinesViewController.swift
//  AnimateLines
//
//  Created by Robert on 08.06.2022.
//

import UIKit

class FlowingLinesViewController: UIViewController, CAAnimationDelegate {

    class Animation: NSObject, CAAnimationDelegate {
        private let repeatTimes: Int
        private let animationTime: TimeInterval = 2
        private let gapTime: TimeInterval = 0.3
        private var numberOfFinishedAnimations = 0
        private var layer1: CAShapeLayer
        private var layer2: CAShapeLayer
        
        init(repeatTimes: Int, layer1: CAShapeLayer, layer2: CAShapeLayer) {
            self.repeatTimes = repeatTimes
            self.layer1 = layer1
            self.layer2 = layer2
        }
        
        private func makeAnimation(layer: CAShapeLayer, timeOffset: TimeInterval) {
            let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            strokeEndAnimation.fromValue = 0
            strokeEndAnimation.toValue = 1
            strokeEndAnimation.duration = animationTime
            strokeEndAnimation.isRemovedOnCompletion = false
            strokeEndAnimation.fillMode = .forwards
            
            let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
            strokeStartAnimation.fromValue = 0
            strokeStartAnimation.toValue = 1
            strokeStartAnimation.duration = animationTime
            strokeStartAnimation.beginTime = (animationTime - gapTime) / 2
            strokeStartAnimation.isRemovedOnCompletion = false
            strokeStartAnimation.fillMode = .forwards
            
            let group = CAAnimationGroup()
            group.duration = animationTime + (animationTime - gapTime) / 2
            group.isRemovedOnCompletion = true
            group.delegate = self

            group.beginTime = CACurrentMediaTime() + timeOffset
            group.animations = [strokeStartAnimation, strokeEndAnimation]
            
            layer.add(group, forKey: "flow animation")
        }
        
        func startAnimations() {
            makeAnimation(layer: layer1, timeOffset: 0)
            makeAnimation(layer: layer2, timeOffset: (animationTime - gapTime) / 2 + gapTime)
        }
        
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            if layer1.animation(forKey: "flow animation") == nil &&
                layer2.animation(forKey: "flow animation") == nil {
                numberOfFinishedAnimations += 1
                
                if numberOfFinishedAnimations < repeatTimes {
                    startAnimations()
                }
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    var layer1: CAShapeLayer!
    var layer2: CAShapeLayer!
    var animations: Animation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layer1 = setupLayer(path: makePath(), parent: containerView.layer)
        layer2 = setupLayer(path: makePath(), parent: containerView.layer)
    }
    
    @IBAction func animate() {
        animations = Animation(repeatTimes: 5, layer1: layer1, layer2: layer2)
        animations.startAnimations()
    }

    private func makePath() -> CGPath {
        let width = containerView.bounds.width
        let height = containerView.bounds.height
        
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 10, y: 10))
        
        path.addCurve(to: CGPoint(x: width - 50, y: height - 35),
                      controlPoint1: .init(x: width - 50, y: 40),
                      controlPoint2: .init(x: 10, y: height - 20))
        path.addLine(to: CGPoint(x: width - 50, y: height - 35))
        return path.cgPath
    }
    
    private func setupLayer(path: CGPath, parent: CALayer) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = containerView.bounds
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.path = path
        layer.strokeStart = 0
        layer.strokeEnd = 0
        
        parent.addSublayer(layer)
        
        return layer
    }

}

