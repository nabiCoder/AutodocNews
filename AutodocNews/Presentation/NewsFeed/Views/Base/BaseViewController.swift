import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    // MARK: - Loader
    private var loader: UIActivityIndicatorView?
    
    func setupViews() {
        view.backgroundColor = AppColor.primaryBackground.color
    }
    
    func showError(_ error: AppError, retryHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        if let retryHandler = retryHandler {
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in retryHandler() }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
