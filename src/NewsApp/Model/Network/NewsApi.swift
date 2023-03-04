
import Foundation

struct NewsSource: Codable {
    let status: String?
    let totalResults: Int?
    struct Article: Codable {
        let source: Source
        let author: String?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let publishedAt: String
        
        struct Source: Codable {
            let id: String?
            let name: String?
        }
    }
    
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

enum ApiErrors : String, Error {
    case dataIsNil = "Data is nil!"
    case jsonParseError = "JSON parse error"
}

final class NewsApi : NewsApiProtocol {
  
    static let shared = NewsApi()
    
    private init() {}
    
    private var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    private let search = URLQueryItem(name: "q", value: "russia")
    private let fromDate = URLQueryItem(name: "from", value: "2023-02-04")
    private let language = URLQueryItem(name: "language", value: "ru")
    private let apiKey = URLQueryItem(name: "apiKey", value: "34f4c8a4cfe647f5acd1e7d709464b34")
    
    func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void) {
        
        let request = getNewsApiRequest()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiErrors.dataIsNil))
                return
            }
            
            do
            {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newsSource = try decoder.decode(NewsSource.self, from: data)
                completion(.success(newsSource))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func getNewsApiRequest() -> URLRequest {
        everythingUrl?.queryItems?.append(search)
        everythingUrl?.queryItems?.append(language)
        everythingUrl?.queryItems?.append(fromDate)
        everythingUrl?.queryItems?.append(apiKey)
        
        guard let url = everythingUrl?.url else {
            fatalError("Error creating newsapi.org url from components")
        }
        
        var urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
