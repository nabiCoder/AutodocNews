import Foundation

protocol HTTPClientProtocol {
    func send<T: APIRequest>(_ request: T) async throws -> T.Response
}

final class HTTPClient: HTTPClientProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func send<T: APIRequest>(_ request: T) async throws -> T.Response {
        let urlRequest = try request.urlRequest 

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.network(.invalidResponse)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw AppError.network(.serverError(httpResponse.statusCode))
        }

        do {
            let decoded = try decoder.decode(T.Response.self, from: data)
            return decoded
        } catch {
            throw AppError.network(.decoding(error))
        }
    }
}
