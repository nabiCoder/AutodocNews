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
        case "Автомобильные новости": self = .automotiveNews
        case "Новости компании": self = .companyNews
        default: self = .unknown
        }
    }
}
