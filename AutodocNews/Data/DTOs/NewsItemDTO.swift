import Foundation

struct NewsResponseDTO: Codable {
    let news: [NewsItemDTO]
    let totalCount: Int
}

struct NewsItemDTO: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String 
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
