import UIKit

final class AppDIContainer {
    lazy var httpClient: HTTPClientProtocol = HTTPClient()
    lazy var imageLoader: ImageLoadingProtocol = ImageLoader()
    lazy var apiService: NewsAPIServiceProtocol = NewsAPIService(client: httpClient)

    func makeNewsFeedModule() -> UIViewController {
        let repository = NewsRepository(apiService: apiService)
        let useCase = FetchNewsUseCase(repository: repository)
        let viewModel = NewsFeedViewModel(fetchNewsUseCase: useCase, imageLoader: imageLoader)
        let viewController = NewsFeedViewController(viewModel: viewModel)
        return viewController
    }
}
