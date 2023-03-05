
import Foundation

protocol NewsAppStorageProtocol {
    
    var articles: [ArticleEntity] {get}
    
    func isArticleInFavorites(title: String) -> Bool
    
    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?) -> ArticleEntity
    
    func removeFromFavorites(title: String)
}
