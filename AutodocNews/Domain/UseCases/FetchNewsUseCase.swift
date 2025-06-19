import Foundation

protocol FetchNewsUseCaseProtocol {
    func execute(page: Int, pageSize: Int) async throws -> [NewsItem]
}

final class FetchNewsUseCase: FetchNewsUseCaseProtocol {
    private let newsService: NewsAPIServiceProtocol

    init(newsService: NewsAPIServiceProtocol) {
        self.newsService = newsService
    }

    func execute(page: Int, pageSize: Int) async throws -> [NewsItem] {
        let items = try await newsService.fetchNews(page: page, pageSize: pageSize)
        
        // Можно добавить сортировку, фильтрацию и тд
        
        return items
    }
}
