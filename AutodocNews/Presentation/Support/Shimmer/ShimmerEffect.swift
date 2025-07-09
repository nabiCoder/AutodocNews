import UIKit

final class ShimmerEffect {
    static let sharedBeginTime = CACurrentMediaTime()
    
    static func applyShimmer(to views: [UIView], gradientLayers: inout [CAGradientLayer]) {
        guard gradientLayers.isEmpty else { return }
        
        for view in views {
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = shimmerColors()
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.locations = [0, 0.5, 1]
            layer.opacity = 1.0
            
            view.layer.addSublayer(layer)
            gradientLayers.append(layer)
            
            let animation = shimmerAnimation()
            layer.add(animation, forKey: "shimmer")
        }
    }
    
    static func shimmerAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        animation.timingFunction = .init(name: .easeInEaseOut)
        animation.beginTime = sharedBeginTime
        return animation
    }
    
    static func shimmerColors() -> [CGColor] {
        return [
            LayoutConstants.Cell.backgroundLightGrayColor.cgColor,
            LayoutConstants.Cell.backgroundWhiteColor.cgColor,
            LayoutConstants.Cell.backgroundLightGrayColor.cgColor
        ]
    }
    
    static func updateShimmerFrames(for views: [UIView], gradientLayers: [CAGradientLayer]) {
        for (i, view) in views.enumerated() {
            gradientLayers[safe: i]?.frame = view.bounds
        }
    }
}
