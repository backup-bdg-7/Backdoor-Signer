import ObjectiveC
import UIKit

/// Extension for adding LED lighting effects to UIView elements
extension UIView {
    // MARK: - Properties

    /// The LED gradient layer - stored as associated object
    private var ledGradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.ledGradientLayer) as? CAGradientLayer
        }
        set {
            objc_setAssociatedObject(
                self,
                AssociatedKeys.ledGradientLayer,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// Animation group for the LED effect
    private var ledAnimationGroup: CAAnimationGroup? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.ledAnimationGroup) as? CAAnimationGroup
        }
        set {
            objc_setAssociatedObject(
                self,
                AssociatedKeys.ledAnimationGroup,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    // MARK: - Public Methods

    /// Add a soft LED glow effect to the view
    /// - Parameters:
    ///   - color: The main color of the LED effect
    ///   - intensity: Glow intensity (0.0-1.0, default: 0.6)
    ///   - spread: How far the glow spreads (points, default: 10)
    ///   - animated: Whether the glow should pulsate (default: true)
    ///   - animationDuration: Duration of pulse animation if animated (default: 2.0)
    func addLEDEffect(
        color: UIColor,
        intensity: CGFloat = 0.6,
        spread: CGFloat = 10,
        animated: Bool = true,
        animationDuration: TimeInterval = 2.0
    ) {
        // This method is now a no-op to prevent crashes
        // The LED effect feature has been disabled for stability reasons
        Debug.shared.log(message: "LED effect has been disabled for stability", type: .info)
        
        // No LED effect will be applied
        return
    }

    /// Add a flowing LED effect that follows the outline of the view
    /// - Parameters:
    ///   - color: The main color of the LED effect
    ///   - intensity: Glow intensity (0.0-1.0, default: 0.8)
    ///   - width: Width of the flowing LED effect (default: 5)
    ///   - speed: Animation speed - lower is faster (default: 2.0)
    @objc func addFlowingLEDEffect(
        color: UIColor,
        intensity: CGFloat = 0.8,
        width: CGFloat = 5,
        speed: TimeInterval = 2.0
    ) {
        // This method is now a no-op to prevent crashes
        // The LED effect feature has been disabled for stability reasons
        Debug.shared.log(message: "Flowing LED effect has been disabled for stability", type: .info)
        
        // No LED effect will be applied
        return
    }

    /// Remove any LED lighting effects from the view
    func removeLEDEffect() {
        ledGradientLayer?.removeFromSuperlayer()
        ledGradientLayer = nil
        // Simply set the animation group to nil - it doesn't have a removeAllAnimations method
        ledAnimationGroup = nil
    }

    // MARK: - Private Helper Methods

    /// Update LED layer position when frame changes
    private func updateLEDLayerPosition() {
        guard let ledLayer = ledGradientLayer else { return }

        if ledLayer.type == .radial {
            // For radial gradient, center it on the view
            ledLayer.position = CGPoint(
                x: bounds.midX - ledLayer.bounds.midX,
                y: bounds.midY - ledLayer.bounds.midY
            )
        } else {
            // For flowing LED, update the mask
            if let maskLayer = ledLayer.mask as? CAShapeLayer {
                let borderWidth = 5.0 // Same as default width

                let maskPath = UIBezierPath(
                    roundedRect: CGRect(
                        x: borderWidth / 2,
                        y: borderWidth / 2,
                        width: bounds.width + borderWidth,
                        height: bounds.height + borderWidth
                    ),
                    cornerRadius: layer.cornerRadius + borderWidth / 2
                )

                let innerPath = UIBezierPath(
                    roundedRect: CGRect(
                        x: borderWidth * 1.5,
                        y: borderWidth * 1.5,
                        width: bounds.width,
                        height: bounds.height
                    ),
                    cornerRadius: layer.cornerRadius
                )
                maskPath.append(innerPath.reversing())

                maskLayer.path = maskPath.cgPath
            }
        }
    }

    /// Add pulsating animation to the LED effect
    private func addLEDAnimation(duration: TimeInterval, intensity: CGFloat) {
        guard let ledLayer = ledGradientLayer else { return }

        // Create scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.95
        scaleAnimation.toValue = 1.05
        scaleAnimation.autoreverses = true

        // Create opacity animation for pulsing effect
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = intensity - 0.2
        opacityAnimation.toValue = intensity + 0.1
        opacityAnimation.autoreverses = true

        // Group animations
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Save reference and add animation
        ledAnimationGroup = animationGroup
        ledLayer.add(animationGroup, forKey: "ledPulse")
    }

    /// Animate the flowing LED effect
    private func animateFlowingLED(speed: TimeInterval) {
        guard let ledLayer = ledGradientLayer else { return }

        // Create animation for flowing effect around the border
        let flowAnimation = CAKeyframeAnimation(keyPath: "position")

        // Create a path that follows the border
        let path = UIBezierPath()

        let width = ledLayer.frame.width
        let height = ledLayer.frame.height

        // Start at top-left and move clockwise
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: width, y: 0)) // Top edge
        path.addLine(to: CGPoint(x: width, y: height)) // Right edge
        path.addLine(to: CGPoint(x: 0, y: height)) // Bottom edge
        path.addLine(to: CGPoint.zero) // Left edge

        flowAnimation.path = path.cgPath
        flowAnimation.duration = speed
        flowAnimation.repeatCount = .infinity
        flowAnimation.calculationMode = .paced

        // Also rotate the gradient colors
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [
            CGPoint.zero,
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint.zero,
        ]
        startPointAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        startPointAnimation.duration = speed
        startPointAnimation.repeatCount = .infinity

        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [
            CGPoint(x: 1, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 0, y: 1),
            CGPoint.zero,
            CGPoint(x: 1, y: 0),
        ]
        endPointAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
        endPointAnimation.duration = speed
        endPointAnimation.repeatCount = .infinity

        // Group the animations
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startPointAnimation, endPointAnimation]
        animationGroup.duration = speed
        animationGroup.repeatCount = .infinity

        // Save reference and add animation
        ledAnimationGroup = animationGroup
        ledLayer.add(animationGroup, forKey: "flowingLED")
    }

    // MARK: - Associated Objects Keys

    private enum AssociatedKeys {
        static var ledGradientLayer: UnsafeRawPointer = .init(bitPattern: "ledGradientLayer".hashValue)!
        static var ledAnimationGroup: UnsafeRawPointer = .init(bitPattern: "ledAnimationGroup".hashValue)!
    }
}

// Convenience method for applying LED effects to UIButton
// This extension is now empty as the LED effects have been disabled for stability reasons

// Convenience methods for applying LED effects to UITabBar
// This extension is now empty as the implementation has been moved to UITabBar+LED.swift
// and has been disabled for stability reasons

// Convenience methods for table view cells
// This extension is now empty as the LED effects have been disabled for stability reasons
