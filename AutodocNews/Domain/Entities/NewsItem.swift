import Foundation

struct NewsItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: Date
    let url: String
    let fullUrl: URL
    let titleImageUrl: URL?
    let categoryType: CategoryType
}

enum CategoryType {
    case automotiveNews
    case companyNews
    case unknown
    
    init(from raw: String) {
        switch raw {
        case AppConstants.NewsCategoryRaw.automotiveNews: self = .automotiveNews
        case AppConstants.NewsCategoryRaw.companyNews: self = .companyNews
        default: self = .unknown
        }
    }
    
    var stringValue: String {
        switch self {
        case .automotiveNews: return AppConstants.NewsCategoryRaw.automotiveNews
        case .companyNews: return AppConstants.NewsCategoryRaw.companyNews
        case .unknown: return AppConstants.NewsCategoryRaw.unknown
        }
    }
}
