
import Foundation

final class NewsViewModel {
    
    private let newsApi: NewsApiProtocol
    
    init(newsApi: NewsApiProtocol) {
        self.newsApi = newsApi
    }
    
    var articles: [Article] = []
    
    func load(completion: @escaping ((_ result: Result<[Article], Error>) -> Void)) {
        
        articles.removeAll(keepingCapacity: true)
        
        newsApi.performNewsRequest { result in
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let newsSource):
                    self.articles = newsSource.articles
                    completion(.success(newsSource.articles))
                }
            }
        }
    }
}
