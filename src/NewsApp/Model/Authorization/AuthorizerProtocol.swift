
import Foundation

protocol AuthorizerProtocol {
    
    var user: UserEntity? {get}
    
    func auth(email: String, password: String) -> Bool
    
    func authWithNewUser(userName: String, email: String, password: String) -> Bool
}
