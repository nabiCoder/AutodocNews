import Foundation

protocol FetchNewsUseCaseProtocol {
    func fetchFirstPage() async throws -> [NewsItem]
    func fetchNextPage() async throws -> [NewsItem]
}

final class FetchNewsUseCase: FetchNewsUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchFirstPage() async throws -> [NewsItem] {
        await repository.resetPagination()
        return try await repository.fetchNextPage()
    }
    
    func fetchNextPage() async throws -> [NewsItem] {
        return try await repository.fetchNextPage()
    }
}
