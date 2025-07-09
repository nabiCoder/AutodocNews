import UIKit

enum LayoutConstants {
    enum Insets {
        static let phone = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let pad = UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100)
    }
    
    enum LayoutNews {
        static let phoneItemHeight: CGFloat = 300
        static let padItemHeight: CGFloat = 400
        
        static let phoneVerticalSpacing: CGFloat = 8
        static let padVerticalSpacing: CGFloat = 16
        
        static let phoneColumns: Int = 1
        static let phoneHorizontalSpacing: CGFloat = 0
        
        static let padColumns: Int = 2
        static let padHorizontalSpacing: CGFloat = 16
        
        static let footerHeight: CGFloat = 44
    }
    
    enum Cell {
        static let imageHeight: CGFloat = 160
        static let titleMinHeight: CGFloat = 16
        static let titleFontSize: CGFloat = 16
        static let stackSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let backgroundLightGrayColor = UIColor.lightGray.withAlphaComponent(0.3)
        static let backgroundWhiteColor = UIColor.white.withAlphaComponent(0.4)
    }
    
    enum NewsViewController {
        static let skeletonItemsCount: Int = 8
        static let preloadThreshold: CGFloat = 1.5
    }
}

