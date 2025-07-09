import Foundation
import Combine

protocol NewsFeedViewModelProtocol: AnyObject {
    var statePublisher: Published<ViewState>.Publisher { get }
    var isPaginatingPublisher: Published<Bool>.Publisher { get }
    
    func loadInitial()
    func loadNext()
}

final class NewsFeedViewModel: BaseViewModel, NewsFeedViewModelProtocol {
    // MARK: - Publishers
    var isPaginatingPublisher: Published<Bool>.Publisher { $isPaginating }
    
    @Published private(set) var newsItems: [NewsItemViewModel] = []
    @Published private(set) var isPaginating: Bool = false
    
    // MARK: - Dependencies
    private let fetchNewsUseCase: FetchNewsUseCaseProtocol
    private let imageLoader: ImageLoadingProtocol
    
    // MARK: - Private properties
    private var currentTask: Task<Void, Never>?
    private var isLoading = false
    
    // MARK: - Initialization
    init(fetchNewsUseCase: FetchNewsUseCaseProtocol, imageLoader: ImageLoadingProtocol) {
        self.fetchNewsUseCase = fetchNewsUseCase
        self.imageLoader = imageLoader
        super.init()
    }
    
    deinit {
        cancelCurrentTask()
    }
    
    // MARK: - Public methods
    func loadInitial() {
        guard !isLoading else { return }
        cancelCurrentTask()
        loadNewsItems(isInitialLoad: true)
    }
    
    func loadNext() {
        guard !isLoading else { return }
        loadNewsItems(isInitialLoad: false)
    }
    
    // MARK: - Private methods
    private func loadNewsItems(isInitialLoad: Bool) {
        guard isConnected else {
            state = .noConnection(AppError.network(.noInternet))
            return
        }
        
        isLoading = true
        isPaginating = !isInitialLoad
        
        if isInitialLoad {
            state = .loading
        }
        
        currentTask = Task { [weak self] in
            guard let self = self else { return }
            
            defer {
                Task { @MainActor in
                    self.isLoading = false
                    self.isPaginating = false
                }
            }
            
            do {
                let items = try await self.fetchData(isInitialLoad: isInitialLoad)
                let viewModels = items.map { NewsItemViewModel(newsItem: $0, imageLoader: self.imageLoader) }
                
                await self.loadImages(for: viewModels)
                
                await MainActor.run {
                    if isInitialLoad {
                        self.newsItems = viewModels
                    } else {
                        self.newsItems += viewModels
                    }
                    self.state = .loaded(self.newsItems)
                }
                
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.state = .error(self.mapError(error))
                }
            }
        }
    }
    
    private func fetchData(isInitialLoad: Bool) async throws -> [NewsItem] {
        if isInitialLoad {
            return try await fetchNewsUseCase.fetchFirstPage()
        } else {
            return try await fetchNewsUseCase.fetchNextPage()
        }
    }
    
    private func loadImages(for viewModels: [NewsItemViewModel]) async {
        await withTaskGroup(of: Void.self) { group in
            for vm in viewModels where vm.hasImage {
                group.addTask {
                    await vm.loadImage()
                }
            }
        }
    }
    
    private func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
        isLoading = false
        isPaginating = false
    }
}
