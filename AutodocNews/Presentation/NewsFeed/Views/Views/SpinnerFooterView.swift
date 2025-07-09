import UIKit

final class SpinnerFooterView: UICollectionReusableView {
    static let reuseIdentifier = "SpinnerFooterView"
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isLoading: Bool) {
        isLoading ? spinner.startAnimating() : spinner.stopAnimating()
        isHidden = !isLoading
    }
}

private extension SpinnerFooterView {
    func setupView() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        spinner.startAnimating()
    }
}
