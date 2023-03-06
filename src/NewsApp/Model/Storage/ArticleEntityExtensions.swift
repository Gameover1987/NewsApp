
import Foundation

extension ArticleEntity {
    func toArticle() -> Article {
        return Article(author: "",
                       title: self.title,
                       description: self.contents,
                       url: nil,
                       urlToImage: URL(string: self.urlToImage ?? ""),
                       publishedAt: self.publishedAt!)
    }
}
