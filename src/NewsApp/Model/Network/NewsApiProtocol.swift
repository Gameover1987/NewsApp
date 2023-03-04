
import Foundation

protocol NewsApiProtocol {
    
    func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void)
    
}
