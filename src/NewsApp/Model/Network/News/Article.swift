
import Foundation

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date
    
    struct Source: Codable {
        let id: String?
        let name: String?
    }
}
