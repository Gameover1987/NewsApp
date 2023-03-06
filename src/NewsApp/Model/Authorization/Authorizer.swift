
import Foundation

final class Authorizer : AuthorizerProtocol {
    static let shared = Authorizer(storage: CoreDataNewsAppStorage.shared)
    
    private let storage: NewsAppStorageProtocol
    
    private init(storage: NewsAppStorageProtocol) {
        self.storage = storage
    }
    
    func auth(email: String, password: String) -> Bool {
        return storage.checkUser(email: email, password: password)
    }
    
    func authWithNewUser(userName: String, email: String, password: String) -> Bool {
        if storage.isEmailRegistered(email) {
            return false
        }
        
        storage.addUser(userName: userName, email: email, password: password)
        return true
    }
}
