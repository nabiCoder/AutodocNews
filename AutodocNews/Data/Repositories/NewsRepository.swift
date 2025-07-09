import Foundation

protocol NewsRepositoryProtocol {
    func fetchNextPage() async throws -> [NewsItem]
    func resetPagination() async
    func getCachedNews() async -> [NewsItem]
}

actor NewsRepository: NewsRepositoryProtocol {
    private let apiService: NewsAPIServiceProtocol
    private var currentPage = 1
    private let pageSize: Int
    private var isLastPage = false
    private var isLoading = false

    private var cachedNews: [NewsItem] = []

    init(apiService: NewsAPIServiceProtocol, pageSize: Int = AppConstants.Pagination.newsPageSize) {
        self.apiService = apiService
        self.pageSize = pageSize
    }

    func fetchNextPage() async throws -> [NewsItem] {
        guard !isLoading, !isLastPage else {
            return []
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let news = try await apiService.fetchNews(page: currentPage, pageSize: pageSize)
        if news.count < pageSize {
            isLastPage = true
        }
        cachedNews.append(contentsOf: news)
        currentPage += 1
        return news
    }

    func resetPagination() async {
        currentPage = 1
        isLastPage = false
        cachedNews.removeAll()
    }
    
    func getCachedNews() async -> [NewsItem] {
        return cachedNews
    }
}
