
import Foundation

final class RegistrationViewModel {
    
    private let authorizer: AuthorizerProtocol
    
    init(authorizer: AuthorizerProtocol) {
        self.authorizer = authorizer
    }
    
    var userName: String = ""
    var email: String = ""
    var password: String = ""
    
    var okAction: (() -> Void)?
    var errorAction: ((_ error: String) -> Void)?
    
    func performRegistration() {
        if userName.isEmpty || email.isEmpty || password.isEmpty {
            errorAction?("Заполните пустые поля")
            return
        }
        
        if !email.isValidEmail {
            errorAction?("Проверьте корректность ввода почты")
            return
        }
        
        if !authorizer.authWithNewUser(userName: userName, email: email, password: password) {
            errorAction?("Пользователь с таким e-mail уже зарегистрирован")
            return
        }
        
        okAction?()
    }
}
