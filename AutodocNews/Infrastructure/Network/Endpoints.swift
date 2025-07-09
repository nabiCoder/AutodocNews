import Foundation

enum NewsEndpoint {
    static let baseURL = APIConstants.baseURL
    
    case news(page: Int, pageSize: Int)
    
    var url: URL? {
        switch self {
        case .news(let page, let pageSize):
            return URL(string: "\(Self.baseURL)/api/news/\(page)/\(pageSize)")
        }
    }
}

struct NewsRequest: APIRequest {
    typealias Response = NewsResponseDTO
    
    let page: Int
    let pageSize: Int
    
    var urlRequest: URLRequest {
        get throws {
            guard let url = NewsEndpoint.news(page: page, pageSize: pageSize).url else {
                throw AppError.network(.invalidURL)
            }
            return URLRequest(url: url)
        }
    }
}
