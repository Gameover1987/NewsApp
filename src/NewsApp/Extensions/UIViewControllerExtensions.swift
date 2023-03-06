
import UIKit

extension UIViewController {
    
    func showExitDialog(title: String, message: String, actionHandler: @escaping((_ isOk: Bool) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (action:UIAlertAction) in
            actionHandler(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Выход", style: .destructive, handler: { UIAlertAction in
            actionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage(title: String, message: String, after actionHandler: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (action:UIAlertAction) in
            actionHandler()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideBackButtonTitle() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
