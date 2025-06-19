import UIKit

protocol ImageLoading {
    func loadImage(from url: URL) async throws -> UIImage
    mutating func cancelLoad(for url: URL)
}

struct ImageLoader: ImageLoading {
    
    private let cache: ImageCaching
    private let session: URLSession
    private var tasks: [URL: URLSessionDataTask] = [:]
    
    init(cache: ImageCaching = ImageCache.shared, session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        // Возвращаем из кэша если уже загружено
        if let cachedImage = cache.image(forKey: url.absoluteString) {
            return cachedImage
        }
        
        // Загружаем через URLSession
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw AppError.imageLoader(.invalidResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw AppError.imageLoader(.failedToDecodeImage)
        }
        
        // Кэшируем изображение
        cache.insertImage(image, forKey: url.absoluteString)
        return image
    }
    
    mutating func cancelLoad(for url: URL) {
        tasks[url]?.cancel()
        tasks.removeValue(forKey: url)
    }
}
