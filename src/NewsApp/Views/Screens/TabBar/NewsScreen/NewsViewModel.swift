
import Foundation

final class NewsViewModel {
    
    private let newsApi: NewsApiProtocol
    private let storage: NewsAppStorageProtocol
    
    init(newsApi: NewsApiProtocol, storage: NewsAppStorageProtocol) {
        self.newsApi = newsApi
        self.storage = storage
    }
    
    var articles: [ArticleViewModel] = []
    
    func load(completion: @escaping ((_ result: Result<[Article], Error>) -> Void)) {
        
        articles.removeAll(keepingCapacity: true)
        
        newsApi.performNewsRequest { result in
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                    
                case .success(let newsSource):
                    self.articles = newsSource.articles.map({ article in
                        return ArticleViewModel(article: article, storage: self.storage)
                    })
                    completion(.success(newsSource.articles))
                }
            }
        }
    }
}
