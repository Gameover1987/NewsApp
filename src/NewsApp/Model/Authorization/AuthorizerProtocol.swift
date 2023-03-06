
import Foundation

protocol AuthorizerProtocol {
    func auth(email: String, password: String) -> Bool
    
    func authWithNewUser(userName: String, email: String, password: String) -> Bool
}
