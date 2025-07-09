import UIKit

class BaseSkeletonCollectionCell: BaseCollectionCell {
    var shimmerViews: [UIView] { [] }
    
    private var gradientLayers: [CAGradientLayer] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.async {
            ShimmerEffect.applyShimmer(to: self.shimmerViews, gradientLayers: &self.gradientLayers)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        ShimmerEffect.updateShimmerFrames(for: shimmerViews, gradientLayers: gradientLayers)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ShimmerEffect.updateShimmerFrames(for: shimmerViews, gradientLayers: gradientLayers)
    }
}

