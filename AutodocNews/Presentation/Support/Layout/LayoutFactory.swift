import UIKit

enum CollectionLayoutCategory {
    case news
}

enum LayoutFactory {
    static func buildLayout(for category: CollectionLayoutCategory) -> UICollectionViewCompositionalLayout {
        let section = createSection(for: category)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private static func createSection(for category: CollectionLayoutCategory) -> NSCollectionLayoutSection {
        let deviceType = UIDevice.current.userInterfaceIdiom
        let config = category.layoutConfiguration(for: deviceType)
        
        return makeSectionLayout(using: config)
    }
    
    private static func makeSectionLayout(using config: LayoutModel) -> NSCollectionLayoutSection {
        let itemHeight = config.columns == 1 ? config.itemHeight : config.itemHeight + config.verticalSpacing
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(config.itemWidth),
                                              heightDimension: .absolute(itemHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: config.verticalSpacing / 2,
                                                     leading: config.horizontalSpacing / 2,
                                                     bottom: config.verticalSpacing / 2,
                                                     trailing: config.horizontalSpacing / 2)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: config.columns)
        group.interItemSpacing = .fixed(config.horizontalSpacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: config.sectionInsets.top,
                                                        leading: config.sectionInsets.left,
                                                        bottom: config.sectionInsets.bottom,
                                                        trailing: config.sectionInsets.right)
        section.interGroupSpacing = config.verticalSpacing
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(LayoutConstants.LayoutNews.footerHeight))
        
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        
        section.boundarySupplementaryItems = [footer]
        
        return section
    }
}
