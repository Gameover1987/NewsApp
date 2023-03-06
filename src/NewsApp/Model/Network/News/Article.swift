
import Foundation

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date
}
