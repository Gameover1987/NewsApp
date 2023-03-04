
import UIKit

final class FavoritesViewController : UIViewController {
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.Favoites.background
        
        self.title = Strings.Favorites.title
    }
}
