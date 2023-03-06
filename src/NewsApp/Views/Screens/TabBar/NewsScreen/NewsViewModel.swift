
import Foundation

final class NewsViewModel {
    
    private let newsApi: NewsApiProtocol
    private let storage: NewsAppStorageProtocol
    
    init(newsApi: NewsApiProtocol, storage: NewsAppStorageProtocol) {
        self.newsApi = newsApi
        self.storage = storage
        
        storage.addObserver(self)
    }
    
    var articles: [ArticleViewModel] = []
    
    var articleRemovedFromFavoritesAction: ((IndexPath) -> Void)?
    
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

extension NewsViewModel : NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {
        if let removedIndex = articles.firstIndex(where: { article in
            return article.title == title
        }) {
            articleRemovedFromFavoritesAction?(IndexPath(row: removedIndex, section: 0))
        }
    }
    
    func didAddToFavorites(article: ArticleEntity) {
        
    }
}
