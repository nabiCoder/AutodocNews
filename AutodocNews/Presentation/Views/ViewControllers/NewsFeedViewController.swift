import UIKit

final class NewsFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let client = HTTPClient() // твоя реализация APIClientProtocol
        let newsService = NewsAPIService(client: client)
        
//        Task {
//            do {
//                let news = try await newsService.fetchNews(page: 1, pageSize: 15)
//                print("Новости: \(news)")
//            } catch {
//                print("Ошибка: \(error)")
//            }
//        }
        
        Task {
            await testLoadImage()
        }
        
    }
    
    func testLoadImage() async {
        let loader = ImageLoader()
        let url = URL(string: "https://file.autodoc.ru/news/avto-novosti/3195810944_1.jpg")!  // замените на реальный URL
        
        do {
            let image1 = try await loader.loadImage(from: url)
            print("Загрузка успешна, размер изображения: \(image1.size)")
            
            let image2 = try await loader.loadImage(from: url)
            print("Повторная загрузка из кэша, размер изображения: \(image2.size)")
            
            assert(image1 === image2, "Изображения должны быть одним и тем же объектом из кэша")
        } catch {
            print("Ошибка загрузки изображения: \(error)")
        }
    }
}

