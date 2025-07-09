import UIKit

protocol ImageCaching {
    func image(forKey key: String) -> UIImage?
    func insertImage(_ image: UIImage, forKey key: String)
    func removeImage(forKey key: String)
    func removeAll()
}

final class ImageCache: ImageCaching {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func insertImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func removeImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
