
import Foundation

final class LoginViewModel {
    
    private let authorizer: AuthorizerProtocol
    
    init(authorizer: AuthorizerProtocol) {
        self.authorizer = authorizer
    }
    
    var login: String = ""
    var password: String = ""
    
    var okAction: (() -> Void)?
    var errorAction: ((_ error: String) -> Void)?
    
    func authorize() {
        if login.isEmpty || password.isEmpty {
            errorAction?("Заполните пустые поля")
            return
        }
        
        if !login.isValidEmail {
            errorAction?("Проверьте корректность ввода почты")
            return
        }
        
        if !authorizer.auth(login: login, password: password) {
            errorAction?("Указан неправильный логин или пароль")
            return
        }
        
        okAction?()
    }
}
