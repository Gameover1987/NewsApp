
import Foundation

final class LoginViewModel {
    
    private let authorizer: AuthorizerProtocol
    
    init(authorizer: AuthorizerProtocol) {
        self.authorizer = authorizer
    }
    
    var email: String = ""
    var password: String = ""
    
    var okAction: (() -> Void)?
    var errorAction: ((_ error: String) -> Void)?
    
    func authorize() {
        if email.isEmpty || password.isEmpty {
            errorAction?("Заполните пустые поля")
            return
        }
        
        if !email.isValidEmail {
            errorAction?("Проверьте корректность ввода почты")
            return
        }
        
        if !authorizer.auth(email: email, password: password) {
            errorAction?("Указан неправильный логин или пароль")
            return
        }
        
        okAction?()
    }
}
