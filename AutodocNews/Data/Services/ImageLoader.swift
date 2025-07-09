import UIKit
import os.log

protocol ImageLoadingProtocol {
    func loadImage(from url: URL) async throws -> UIImage
    func cancelLoad(for url: URL)
}

final class ImageLoader: ImageLoadingProtocol {
    private let cache: ImageCaching
    private let session: URLSession
    private var tasks: [URL: URLSessionDataTask] = [:]
    private let lock = NSLock()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "ImageLoader", category: "ImageLoading")
    
    init(cache: ImageCaching = ImageCache.shared, session: URLSession = .shared) {
        self.cache = cache
        self.session = session
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
        if let cached = cache.image(forKey: url.absoluteString) {
            logger.debug("Returning cached image for URL: \(url.absoluteString)")
            return cached
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { [weak self] data, response, error in
                self?.removeTask(for: url)
                
                if let error = error {
                    self?.logger.error("Failed to load image from \(url.absoluteString): \(error.localizedDescription)")
                    continuation.resume(throwing: AppError.imageLoader(.networkError(error)))
                    return
                }
                
                guard let httpResp = response as? HTTPURLResponse, 200..<300 ~= httpResp.statusCode else {
                    self?.logger.error("Invalid HTTP response when loading image from \(url.absoluteString)")
                    continuation.resume(throwing: AppError.imageLoader(.invalidResponse))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self?.logger.error("Failed to decode image from data at \(url.absoluteString)")
                    continuation.resume(throwing: AppError.imageLoader(.failedToDecodeImage))
                    return
                }
                
                self?.cache.insertImage(image, forKey: url.absoluteString)
                continuation.resume(returning: image)
            }
            
            storeTask(task, for: url)
            task.resume()
        }
    }
    
    func cancelLoad(for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        
        tasks[url]?.cancel()
        tasks.removeValue(forKey: url)
        logger.debug("Cancelled loading image for URL: \(url.absoluteString)")
    }
    
    private func storeTask(_ task: URLSessionDataTask, for url: URL) {
        lock.lock()
        tasks[url] = task
        lock.unlock()
    }
    
    private func removeTask(for url: URL) {
        lock.lock()
        tasks.removeValue(forKey: url)
        lock.unlock()
    }
}
