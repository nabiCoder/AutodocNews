import UIKit
import Combine

protocol NewsItemViewModelProtocol: AnyObject, Hashable {
    var title: String { get }
    var imageURL: URL? { get }
    var fullUrl: URL { get }
    var hasImage: Bool { get }
    
    var image: UIImage? { get }
    var isLoadingImage: Bool { get }
    
    func loadImage() async
    func cancelImageLoad()
}

final class NewsItemViewModel: NewsItemViewModelProtocol {
    // MARK: - Properties
    private let newsItem: NewsItem
    private let imageLoader: ImageLoadingProtocol
    
    private var loadTask: Task<Void, Never>?
    private(set) var image: UIImage?
    
    @Published private(set) var isLoadingImage: Bool = false
    
    // MARK: - Initialization
    init(newsItem: NewsItem, imageLoader: ImageLoadingProtocol) {
        self.newsItem = newsItem
        self.imageLoader = imageLoader
    }
    
    deinit {
        cancelImageLoad()
    }
    
    // MARK: - Protocol Properties
    var title: String {
        newsItem.title
    }
    
    var imageURL: URL? {
        newsItem.titleImageUrl
    }
    
    var fullUrl: URL {
        newsItem.fullUrl
    }
    
    var hasImage: Bool {
        return newsItem.titleImageUrl != nil
    }
    
    // MARK: - Image Loading
    func loadImage() async {
        guard let url = imageURL else { return }
        guard !isLoadingImage, image == nil else { return }
        
        isLoadingImage = true
        
        do {
            let loadedImage = try await imageLoader.loadImage(from: url)
            image = loadedImage
        } catch {
            image = nil
        }
        
        isLoadingImage = false
    }
    
    // MARK: - Cancellation
    func cancelImageLoad() {
        loadTask?.cancel()
        loadTask = nil
        if let url = imageURL {
            imageLoader.cancelLoad(for: url)
        }
    }
    
    // MARK: - Hashable (для diffable data source)
    static func == (lhs: NewsItemViewModel, rhs: NewsItemViewModel) -> Bool {
        lhs.newsItem.id == rhs.newsItem.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(newsItem.id)
    }
}
