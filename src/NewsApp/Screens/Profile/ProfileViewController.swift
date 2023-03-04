
import UIKit

final class ProfileViewController : UIViewController {
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.Profile.background
        
        self.title = Strings.Profile.title
    }
}
