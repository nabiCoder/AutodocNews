import Foundation

protocol NewsAPIServiceProtocol {
    func fetchNews(page: Int, pageSize: Int) async throws -> [NewsItem]
}

final class NewsAPIService: NewsAPIServiceProtocol {
    
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func fetchNews(page: Int, pageSize: Int) async throws -> [NewsItem] {
        do {
            let request = NewsRequest(page: page, pageSize: pageSize)
            let dto = try await client.send(request)
            return try dto.news.map { try NewsItemMapper.map($0) }
        } catch let error as AppError {
            print("App error: \(error)")
            throw error
        } catch {
            print("Unexpected error: \(error)")
            throw AppError.unknown
        }
    }
}
