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
        let request = NewsRequest(page: page, pageSize: pageSize)
        
        do {
            let responseDTO = try await client.send(request)
            return try responseDTO.news.map(NewsItemMapper.map)
        } catch let error as AppError {
            #if DEBUG
            print("AppError: \(error)")
            #endif
            throw error
        } catch {
            #if DEBUG
            print("Unexpected Error: \(error)")
            #endif
            throw AppError.unknown
        }
    }
}
