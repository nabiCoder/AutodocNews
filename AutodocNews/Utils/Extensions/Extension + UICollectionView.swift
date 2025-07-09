import UIKit.UICollectionView

extension UICollectionView {
    func registerAllCells() {
        registerCell(for: NewsCell.self)
        registerCell(for: NewsSkeletonCell.self)
    }
    
    func registerCell(for cellType: UICollectionViewCell.Type?) {
        guard let cellClass = cellType else { return }
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            return UICollectionViewCell() as! T 
        }
        return cell
    }
}
