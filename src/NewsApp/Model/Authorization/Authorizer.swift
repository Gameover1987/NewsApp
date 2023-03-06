
import Foundation

final class Authorizer : AuthorizerProtocol {
    static let shared = Authorizer(storage: CoreDataNewsAppStorage.shared)
    
    private let storage: NewsAppStorageProtocol
    
    private var authorizedUser: UserEntity?
    
    private init(storage: NewsAppStorageProtocol) {
        self.storage = storage
    }
    
    var user: UserEntity? {
        return authorizedUser
    }
    
    func auth(email: String, password: String) -> Bool {
        authorizedUser = storage.getUserByEmailAndPassword(email: email, password: password)
     
        return authorizedUser != nil
    }
    
    func authWithNewUser(userName: String, email: String, password: String) -> Bool {
        if storage.isEmailRegistered(email) {
            return false
        }
        
        storage.addUser(userName: userName, email: email, password: password)
        return true
    }
}
