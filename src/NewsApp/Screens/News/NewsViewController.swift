
import UIKit

final class NewsViewController : UIViewController {
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.News.background
        
        self.title = Strings.News.title
    }
}
