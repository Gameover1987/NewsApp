
import Foundation
import UIKit

final class ArticleViewModel {
    
    private let article: Article
    private let storage: NewsAppStorageProtocol
    
    init(article: Article, storage: NewsAppStorageProtocol) {
        self.article = article
        self.storage = storage
    }
    
    var title: String? {
        return article.title
    }
    
    var isFavorite: Bool {
        guard let articleTitle = article.title else { return false}
        return storage.isArticleInFavorites(title: articleTitle)
    }
    
    var contents: String? {
        return article.description
    }
    
    var publishedAt: String {
        return article.publishedAt.toString(format: "d MMMM")
    }
    
    var image: UIImage?
    
    func addOrRemoveFromFavorites() {
        guard let articleTitle = article.title else { return}
        
        if (isFavorite) {
            storage.removeFromFavorites(title: articleTitle)
        } else {
            storage.addToFavorites(title: articleTitle,
                                   contents: contents ?? "",
                                   publishedAt: article.publishedAt,
                                   urlToImage: article.urlToImage?.description)
        }
        
    }
    
    func loadImage(completion: @escaping(_ image: UIImage) -> Void) {
        
        if let image = image {
            completion(image)
            return
        }
        
        guard let urlToImage = article.urlToImage else {return}
        
        DispatchQueue.global().async {
            guard let dataFromUrl = try? Data(contentsOf: urlToImage) else {return}
            guard let imageFromWeb = UIImage(data: dataFromUrl) else {return}
            
            DispatchQueue.main.async { [weak self] in
                self?.image = imageFromWeb
                completion(imageFromWeb)
            }
        }
    }
}
