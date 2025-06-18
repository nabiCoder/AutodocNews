import Foundation

struct NewsItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: Date
    let url: String
    let fullUrl: URL
    let titleImageUrl: URL
    let categoryType: CategoryType
}

enum CategoryType {
    case automotiveNews
    case companyNews
    case unknown
    
    init(from raw: String) {
        switch raw {
        case NewsCategoryRaw.automotiveNews: self = .automotiveNews
        case NewsCategoryRaw.companyNews: self = .companyNews
        default: self = .unknown
        }
    }
    
    var stringValue: String {
        switch self {
        case .automotiveNews: return NewsCategoryRaw.automotiveNews
        case .companyNews: return NewsCategoryRaw.companyNews
        case .unknown: return NewsCategoryRaw.unknown
        }
    }
}
