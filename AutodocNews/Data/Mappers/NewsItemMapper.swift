
import Foundation

struct NewsItemMapper {
    static func map(_ dto: NewsItemDTO) throws -> NewsItem {
        guard let fullUrl = URL(string: dto.fullUrl) else {
            throw AppError.mapping(.invalidURL)
        }
        
        let titleImageUrl = dto.titleImageUrl.flatMap { URL(string: $0) }
        
        guard let date = DateFormatters.isoDateTime.date(from: dto.publishedDate) else {
            throw AppError.mapping(.invalidDate)
        }
        
        return NewsItem(id: dto.id,
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

