import UIKit

final class NewsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let client = HTTPClient() // твоя реализация APIClientProtocol
        let newsService = NewsAPIService(client: client)

        Task {
            do {
                let news = try await newsService.fetchNews(page: 1, pageSize: 15)
                print("Новости: \(news)")
            } catch {
                print("Ошибка: \(error)")
            }
        }
    }
    
    
}

