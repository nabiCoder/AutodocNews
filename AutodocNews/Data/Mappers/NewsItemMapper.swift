
import Foundation

enum MappingError: Error {
    case invalidURL
    case invalidDate
}

struct NewsItemMapper {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    static func map(_ dto: NewsItemDTO) throws -> NewsItem {
        guard
            let fullUrl = URL(string: dto.fullUrl),
            let titleImageUrl = URL(string: dto.titleImageUrl)
        else {
            throw MappingError.invalidURL
        }

        guard let date = dateFormatter.date(from: dto.publishedDate) else {
            throw MappingError.invalidDate
        }

        return NewsItem(
            id: dto.id,
            title: dto.title,
            description: dto.description,
            publishedDate: date,
            url: dto.url,
            fullUrl: fullUrl,
            titleImageUrl: titleImageUrl,
            categoryType: CategoryType(from: dto.categoryType)
        )
    }
}

