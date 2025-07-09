import UIKit.UICollectionViewCell

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
