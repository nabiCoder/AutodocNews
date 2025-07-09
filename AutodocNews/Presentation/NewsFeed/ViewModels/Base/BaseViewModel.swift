import Combine
import Foundation

enum ViewState {
    case idle
    case loading
    case loaded([NewsItemViewModel])
    case error(AppError)
    case noConnection(AppError)
}

class BaseViewModel: ObservableObject {
    @Published var state: ViewState = .idle
    
    var statePublisher: Published<ViewState>.Publisher { $state }
    var cancellables = Set<AnyCancellable>()
    private(set) var isConnected: Bool = true
    
    init() {
        observeNetwork()
    }
    
    private func observeNetwork() {
        NetworkMonitor.shared.connectionPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                self.isConnected = isConnected
                if !isConnected {
                    self.state = .noConnection(AppError.network(.noInternet))
                }
            }
            .store(in: &cancellables)
    }
    
    func mapError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        if let netError = error as? NetworkError {
            return .network(netError)
        }
        return .unknown
    }
}
