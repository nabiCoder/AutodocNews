import UIKit

enum Section {
    case main
}

final class SkeletonViewManager {
    private weak var collectionView: UICollectionView?
    private var skeletonDataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        configureSkeletonDataSource()
    }
    
    func showSkeleton(count: Int) {
        guard let collectionView = collectionView else { return }

        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        let placeholders = (0..<count).map { _ in UUID() }
        snapshot.appendItems(placeholders)

        collectionView.dataSource = skeletonDataSource
        skeletonDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func hideSkeleton(dataSource: UICollectionViewDataSource) {
        collectionView?.dataSource = dataSource
    }
    
    private func configureSkeletonDataSource() {
        guard let collectionView = collectionView else { return }

        skeletonDataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, _ in
            collectionView.dequeueReusableCell(cellType: NewsSkeletonCell.self, for: indexPath)
        }
    }
}
