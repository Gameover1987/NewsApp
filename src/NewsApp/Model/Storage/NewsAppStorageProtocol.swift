
import Foundation

protocol NewsAppStorageProtocol {
    
    var articles: [ArticleEntity] {get}
    
    func isArticleInFavorites(title: String) -> Bool
    
    func isEmailRegistered(_ email: String) -> Bool
    
    func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?)
    
    func removeFromFavorites(title: String)
    
    func addObserver(_ observer: any NewsAppStorageObserver)
    
    func removeObserver(_ observer: any NewsAppStorageObserver)
    
    func addUser(userName: String, email: String, password: String)
    
    func checkUser(email: String, password: String) -> Bool
}

protocol NewsAppStorageObserver : AnyObject {
    func didRemoveFromFavorites(title: String)
    
    func didAddToFavorites(article: ArticleEntity)
}
