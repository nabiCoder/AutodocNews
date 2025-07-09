import Foundation

struct NewsResponseDTO: Decodable {
    let news: [NewsItemDTO]
    let totalCount: Int
}

struct NewsItemDTO: Decodable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String
}
