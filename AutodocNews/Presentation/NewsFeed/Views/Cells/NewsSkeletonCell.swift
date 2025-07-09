import UIKit

final class NewsSkeletonCell: BaseSkeletonCollectionCell {
    private let imagePlaceholder = UIView()
    private let titlePlaceholder = UIView()
    
    override var shimmerViews: [UIView] {
        [imagePlaceholder, titlePlaceholder]
    }
    
    override func setupViews() {
        configureAppearance()
        setupLayout()
    }
}

private extension NewsSkeletonCell {
    func configureAppearance() {
        [imagePlaceholder, titlePlaceholder].forEach {
            $0.backgroundColor = LayoutConstants.Cell.backgroundLightGrayColor
            $0.clipsToBounds = true
        }
        
        imagePlaceholder.layer.cornerRadius = LayoutConstants.Cell.cornerRadius
        titlePlaceholder.layer.cornerRadius = LayoutConstants.Cell.cornerRadius / 2
    }
    
    func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [imagePlaceholder, titlePlaceholder])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = LayoutConstants.Cell.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            imagePlaceholder.heightAnchor.constraint(equalToConstant: LayoutConstants.Cell.imageHeight),
            titlePlaceholder.heightAnchor.constraint(equalToConstant: LayoutConstants.Cell.titleMinHeight),
            
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
