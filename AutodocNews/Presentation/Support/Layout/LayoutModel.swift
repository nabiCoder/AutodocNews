import UIKit

struct LayoutModel {
    let itemWidth: CGFloat
    let itemHeight: CGFloat
    let columns: Int
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let sectionInsets: UIEdgeInsets
    
    static func calculateItemWidth(
        columns: Int,
        horizontalSpacing: CGFloat,
        sectionInsets: UIEdgeInsets,
        containerWidth: CGFloat = UIScreen.main.bounds.width
    ) -> CGFloat {
        guard columns > 0 else { return 0 }
        let totalHorizontalSpacing = CGFloat(columns - 1) * horizontalSpacing
        let totalSideInsets = sectionInsets.left + sectionInsets.right
        let totalSpacing = totalHorizontalSpacing + totalSideInsets
        let availableWidth = max(containerWidth - totalSpacing, 0)
        
        return availableWidth / CGFloat(columns)
    }
}

extension CollectionLayoutCategory {
    func layoutConfiguration(for device: UIUserInterfaceIdiom) -> LayoutModel {
        
        let isPhone = device == .phone
        let insets = isPhone ? LayoutConstants.Insets.phone : LayoutConstants.Insets.pad
        
        switch self {
        case .news:
            let itemHeight = isPhone ? LayoutConstants.LayoutNews.phoneItemHeight : LayoutConstants.LayoutNews.padItemHeight
            let spacing = isPhone ? LayoutConstants.LayoutNews.phoneVerticalSpacing : LayoutConstants.LayoutNews.padVerticalSpacing
            let columns = isPhone ? LayoutConstants.LayoutNews.phoneColumns : LayoutConstants.LayoutNews.padColumns
            let horizontalSpacing = isPhone ? LayoutConstants.LayoutNews.phoneHorizontalSpacing : LayoutConstants.LayoutNews.padHorizontalSpacing
            let itemWidth = LayoutModel.calculateItemWidth(columns: columns,
                                                           horizontalSpacing: horizontalSpacing,
                                                           sectionInsets: insets)
            
            return LayoutModel(itemWidth: itemWidth,
                               itemHeight: itemHeight,
                               columns: columns,
                               horizontalSpacing: horizontalSpacing,
                               verticalSpacing: spacing,
                               sectionInsets: insets)
        }
    }
}
