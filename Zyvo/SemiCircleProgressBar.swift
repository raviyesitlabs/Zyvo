////
////  SemiCircleProgressBar.swift
////  Zyvo
////
////  Created by ravi on 3/04/25.
////
//
//
//
//
//




import UIKit
import CoreGraphics


class SemiCircleProgressBar: UIView {
 
    
    var animationDuration: TimeInterval? {
        didSet {
            setNeedsLayout() // will call layoutSubviews where animation happens
        }
    }
    
    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image
    
    private let backgroundShape = CAShapeLayer()
    private let backgroundGradientLayer = CAGradientLayer()
    
    private let strokeShape = CAShapeLayer()
    private let strokeGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradientLayer.removeFromSuperlayer()
        strokeGradientLayer.removeFromSuperlayer()
        
        let radius = bounds.width / 2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.minY + radius + 5 )

        let startAngle: CGFloat = .pi
        let endAngle: CGFloat = 0
        
        // Hemisphere Path
        let filledPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true )
        filledPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
        filledPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
        filledPath.close()
        
        // Background Fill Gradient
        backgroundShape.path = filledPath.cgPath
        backgroundShape.fillColor = UIColor.black.cgColor
        backgroundGradientLayer.frame = bounds
        backgroundGradientLayer.mask = backgroundShape
        backgroundGradientLayer.colors = [
                    UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
                    UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
                ]

        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
        layer.addSublayer(backgroundGradientLayer)
        
        // Arc Line Path (only stroke)
        let strokePath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        strokeShape.path = strokePath.cgPath
        strokeShape.fillColor = UIColor.clear.cgColor
        strokeShape.strokeColor = UIColor.black.cgColor
        strokeShape.lineWidth = 10
        
        // Stroke Gradient
        strokeGradientLayer.frame = bounds
        strokeGradientLayer.mask = strokeShape
        strokeGradientLayer.colors = [
                    UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
                    UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
                    UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
                    UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
                    UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
                ]
        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(strokeGradientLayer)
        
        // Bring image to front
        bringSubviewToFront(imageView)
        imageView.layer.zPosition = 1
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
//        // Starting point
        let startPoint = CGPoint(
            x: centerPoint.x + radius * cos(startAngle),
            y: centerPoint.y + radius * sin(startAngle)
        )
        imageView.center = startPoint
        
        // Animate image along stroke path only (not fill path)
        animateImageAlongArc(path: strokePath)
    }
    
    private func animateImageAlongArc(path: UIBezierPath) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = animationDuration ?? 0.0
        animation.calculationMode = .paced
        animation.fillMode = .forwards
       //animation.timeOffset = animation.duration * 0.93
        //animation.timeOffset = TimeInterval(animation.duration) * 0.85
        animation.isRemovedOnCompletion = false
        imageView.layer.add(animation, forKey: "arcAnimation")
    }
    
//    private func animateImageAlongArc(path: UIBezierPath) {
//        // Create a trimmed version of the path
//        let trimmedPath = UIBezierPath()
//        
//        let center = CGPoint(x: bounds.midX, y: bounds.minY + bounds.width / 2 + 5)
//        let radius = bounds.width / 2
//        let startAngle: CGFloat = .pi
//        let endAngle: CGFloat = 0
//        
//        // Trim end angle (for example, stop at 93%)
//        let trimmedEndAngle = startAngle + (endAngle - startAngle) * 0.93
//
//        trimmedPath.addArc(
//            withCenter: center,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: trimmedEndAngle,
//            clockwise: true
//        )
//
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = trimmedPath.cgPath
//        animation.duration = 10
//        animation.calculationMode = .paced
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        imageView.layer.add(animation, forKey: "arcAnimation")
//    }

}

extension CGPath {
    var length: CGFloat {
        var length: CGFloat = 0.0
        var previousPoint: CGPoint?

        applyWithBlock { element in
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = points[0]
            case .addLineToPoint:
                if let prev = previousPoint {
                    length += hypot(points[0].x - prev.x, points[0].y - prev.y)
                }
                previousPoint = points[0]
            case .closeSubpath:
                break
            default:
                break
            }
        }
        return length
    }

    func point(at distance: CGFloat) -> CGPoint? {
        var traveled: CGFloat = 0
        var result: CGPoint?
        var previousPoint: CGPoint?

        applyWithBlock { element in
            guard result == nil else { return }
            let points = element.pointee.points
            switch element.pointee.type {
            case .moveToPoint:
                previousPoint = points[0]
            case .addLineToPoint:
                if let prev = previousPoint {
                    let segmentLength = hypot(points[0].x - prev.x, points[0].y - prev.y)
                    if traveled + segmentLength >= distance {
                        let t = (distance - traveled) / segmentLength
                        result = CGPoint(
                            x: prev.x + (points[0].x - prev.x) * t,
                            y: prev.y + (points[0].y - prev.y) * t
                        )
                        return
                    }
                    traveled += segmentLength
                }
                previousPoint = points[0]
            default:
                break
            }
        }
        return result
    }
}


//import UIKit
//
//class SemiCircleProgressBar: UIView {
//    
//    private let imageView = UIImageView(image: UIImage(named: "Caminho 27943")) // Replace with your image
//    
//    private let backgroundShape = CAShapeLayer()
//    private let backgroundGradientLayer = CAGradientLayer()
//    
//    private let strokeShape = CAShapeLayer()
//    private let strokeGradientLayer = CAGradientLayer()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupImageView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupImageView()
//    }
//    
//    private func setupImageView() {
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = true
//        addSubview(imageView)
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        backgroundGradientLayer.removeFromSuperlayer()
//        strokeGradientLayer.removeFromSuperlayer()
//        
//        let radius = bounds.width / 1.75
//        let centerPoint = CGPoint(x: bounds.midX, y: bounds.minY  + radius + 5)
//        let startAngle: CGFloat = .pi
//        let endAngle: CGFloat = 0
//        
//        // Hemisphere Path
//        let filledPath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
//        filledPath.addLine(to: CGPoint(x: centerPoint.x + radius, y: centerPoint.y))
//        filledPath.addLine(to: CGPoint(x: centerPoint.x - radius, y: centerPoint.y))
//        filledPath.close()
//        
//        // Background Fill Gradient
//        backgroundShape.path = filledPath.cgPath
//        backgroundShape.fillColor = UIColor.black.cgColor
//        backgroundGradientLayer.frame = bounds
//        backgroundGradientLayer.mask = backgroundShape
//        backgroundGradientLayer.colors = [
//                            UIColor(red: 74/255, green: 237/255, blue: 117/255, alpha: 1).cgColor,
//                            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.64).cgColor,
//                        ]
//        backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 1)
//        backgroundGradientLayer.endPoint = CGPoint(x: 0, y: 0)
//        layer.addSublayer(backgroundGradientLayer)
//        
//        // Arc Line Path (only stroke)
//        let strokePath = UIBezierPath(
//            arcCenter: centerPoint,
//            radius: radius,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true
//        )
//        strokeShape.path = strokePath.cgPath
//        strokeShape.fillColor = UIColor.clear.cgColor
//        strokeShape.strokeColor = UIColor.black.cgColor
//        strokeShape.lineWidth = 10
//        
//        // Stroke Gradient
//        strokeGradientLayer.frame = bounds
//        strokeGradientLayer.mask = strokeShape
//        strokeGradientLayer.colors = [
//            UIColor(red: 153/255, green: 200/255, blue: 23/255, alpha: 1).cgColor,
//            UIColor(red: 253/255, green: 235/255, blue: 72/255, alpha: 1).cgColor,
//            UIColor(red: 254/255, green: 209/255, blue: 55/255, alpha: 1).cgColor,
//            UIColor(red: 247/255, green: 177/255, blue: 30/255, alpha: 1).cgColor,
//            UIColor(red: 215/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
//                        ]
//        strokeGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        strokeGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        layer.addSublayer(strokeGradientLayer)
//        
//        // Bring image to front
//        bringSubviewToFront(imageView)
//        imageView.layer.zPosition = 1
//        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        
//        // Starting point
//        let startPoint = CGPoint(
//            x: centerPoint.x + radius * cos(startAngle),
//            y: centerPoint.y + radius * sin(startAngle)
//        )
//        imageView.center = startPoint
//        
//        // Animate image along stroke path only (not fill path)
//        animateImageAlongArc(path: strokePath)
//    }
//    
//    private func animateImageAlongArc(path: UIBezierPath) {
//        let animation = CAKeyframeAnimation(keyPath: "position")
//        animation.path = path.cgPath
//        animation.duration = 20
//        animation.calculationMode = .paced
//        animation.fillMode = .forwards
//        animation.isRemovedOnCompletion = false
//        imageView.layer.add(animation, forKey: "arcAnimation")
//    }
//}

