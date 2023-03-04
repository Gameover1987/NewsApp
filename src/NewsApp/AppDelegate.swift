
import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        
        let loginController = LoginViewController(
            loginViewModel: LoginViewModel(authorizer: Authorizer.shared),
            viewFactory: ViewFactory.shared)
        let navigationController = UINavigationController(rootViewController: loginController)
        
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .light
        window.makeKeyAndVisible()
        
        return true
    }
    
    
}
