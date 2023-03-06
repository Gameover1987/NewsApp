
import Foundation

final class ResetPasswordViewModel {
    
    init() {
        
    }
    
    var email: String = ""
    
    var okAction: (() -> Void)?
    var errorAction: ((_ error: String) -> Void)?
    
    func resetPassword() {
        if !email.isValidEmail {
            errorAction?("Проверьте корректность ввода почты")
            return
        }
        
        okAction?()
    }
}
