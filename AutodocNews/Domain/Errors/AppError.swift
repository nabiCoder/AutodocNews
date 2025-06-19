import Foundation

enum AppError: Error {
    case network(NetworkError)
    case mapping(MappingError)
    case imageLoader(ImageLoaderError)
    case unknown
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decoding(Error)
    case noInternet
}

enum MappingError: Error {
    case invalidURL
    case invalidDate
}

enum ImageLoaderError: Error {
    case invalidData
    case invalidResponse
    case failedToDecodeImage
}

extension NetworkError {
    var isRetryable: Bool {
        switch self {
        case .noInternet, .serverError:
            return true
        default:
            return false
        }
    }
}
