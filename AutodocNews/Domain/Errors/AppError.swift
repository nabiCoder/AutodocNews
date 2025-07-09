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
    case networkError(Error)
    case invalidData
    case invalidResponse
    case failedToDecodeImage
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return error.localizedDescription
        case .mapping:
            return "Ошибка при обработке данных."
        case .imageLoader:
            return "Ошибка загрузки изображения."
        case .unknown:
            return "Произошла неизвестная ошибка."
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL."
        case .invalidResponse:
            return "Некорректный ответ от сервера."
        case .serverError(let code):
            return "Ошибка сервера. Код: \(code)"
        case .decoding:
            return "Ошибка декодирования данных."
        case .noInternet:
            return "Нет подключения к интернету."
        }
    }
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
