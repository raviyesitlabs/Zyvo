//
//  Misllanious.swift
//  Tradesman
//
//  Created by satyam dwivedi on 12/07/24.
//

import Foundation
import UIKit

class SkeletonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        self.layer.cornerRadius = 4.0
        startShimmering()
    }
    
    private func startShimmering() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.85, alpha: 1.0).cgColor,
            UIColor(white: 0.75, alpha: 1.0).cgColor,
            UIColor(white: 0.85, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = self.bounds
        gradientLayer.frame.size.width *= 1.5
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.5
        animation.fromValue = -self.bounds.width
        animation.toValue = self.bounds.width
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmer")
        self.layer.mask = gradientLayer
    }
}
extension UIView{
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}
