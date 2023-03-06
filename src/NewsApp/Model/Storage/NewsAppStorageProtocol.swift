
import Foundation

protocol NewsAppStorageProtocol {
    
    var articles: [ArticleEntity] {get}
    
    func isArticleInFavorites(title: String) -> Bool
    
    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?)
    
    func removeFromFavorites(title: String)
    
    func addObserver(_ observer: any NewsAppStorageObserver)
    
    func removeObserver(_ observer: any NewsAppStorageObserver)
}

protocol NewsAppStorageObserver : AnyObject {
    func didRemoveFromFavorites(title: String)
    
    func didAddToFavorites(article: ArticleEntity)
}
