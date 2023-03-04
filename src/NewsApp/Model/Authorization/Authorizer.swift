
import Foundation

final class Authorizer : AuthorizerProtocol {
    static let shared = Authorizer()
    
    private init() {}
    
    func auth(login: String, password: String) -> Bool {
        return login.lowercased() == "test@mail.com" &&
        password == "12345"
    }
}
