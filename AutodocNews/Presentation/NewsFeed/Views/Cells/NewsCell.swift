import UIKit
import Combine

final class NewsCell: BaseCollectionCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: NewsItemViewModel?
    private var imageHeightConstraint: NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellState()
    }
    
    func configure(with viewModel: NewsItemViewModel) {
        self.viewModel = viewModel
        setupInitialState(with: viewModel)
        setupBindings(with: viewModel)
    }
    
    override func setupViews() {
        configureImageView()
        configureTitleLabel()
        configureActivityIndicator()
        setupLayout()
    }
}

private extension NewsCell {
    func resetCellState() {
        cancellables.removeAll()
        imageView.image = nil
        imageView.alpha = 0
        activityIndicator.stopAnimating()
    }
    
    func setupInitialState(with viewModel: NewsItemViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        imageView.isHidden = (viewModel.image == nil)
        
        if viewModel.image != nil {
            imageView.fadeIn()
        }
    }
    
    func setupBindings(with viewModel: NewsItemViewModel) {
        viewModel.$isLoadingImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.handleLoadingState(isLoading)
            }
            .store(in: &cancellables)
    }
    
    func handleLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            if imageView.image != nil {
                imageView.fadeIn()
            }
        }
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: LayoutConstants.Cell.titleFontSize, weight: .medium)
        titleLabel.textColor = AppColor.primaryText.color
    }
    
    func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = AppColor.activityIndicator.color
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.axis = .vertical
        stack.spacing = LayoutConstants.Cell.stackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        imageView.addSubview(activityIndicator)
        
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.Cell.imageHeight)
        imageHeightConstraint?.priority = .defaultLow
        imageHeightConstraint?.isActive = true
        
        let titleHeight = titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.Cell.titleMinHeight)
        titleHeight.priority = .defaultHigh
        titleHeight.isActive = true
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
}
