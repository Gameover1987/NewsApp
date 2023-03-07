
import Foundation

final class FavoritesViewModel {
    
    private let storage: NewsAppStorageProtocol
    
    init(storage: NewsAppStorageProtocol) {
        self.storage = storage
        
        self.articles = storage.articles.map({ articleEntity in
            return ArticleViewModel(article: articleEntity.toArticle(), storage: storage)
        })
        
        storage.addObserver(self)
    }
    
    var articles: [ArticleViewModel]
    
    var articleRemovedFromFavoritesAction: ((IndexPath) -> Void)?
    var articleAddedToFavoritesAction: ((ArticleViewModel) -> Void)?
}

extension FavoritesViewModel : NewsAppStorageObserver {
    func didRemoveFromFavorites(title: String) {        
        if let row = self.articles.firstIndex(where: { article in
            return article.title == title
        }) {
            self.articles.remove(at: row)
            articleRemovedFromFavoritesAction?(IndexPath(row: row, section: 0))
        }
    }
    
    func didAddToFavorites(article: ArticleEntity) {
        let articleViewModel = ArticleViewModel(article: article.toArticle(), storage: self.storage)
        self.articles.insert(articleViewModel, at: 0)
        
        articleAddedToFavoritesAction?(articleViewModel)
    }  
}
