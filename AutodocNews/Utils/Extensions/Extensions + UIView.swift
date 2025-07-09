import UIKit.UIView

extension UIView {
    func fadeIn(duration: TimeInterval = 0.25, delay: TimeInterval = 0.0) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut]) {
            self.alpha = 1
        }
    }
}
