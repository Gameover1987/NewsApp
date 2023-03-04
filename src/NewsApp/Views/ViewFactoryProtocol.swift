
import UIKit

protocol ViewFactoryProtocol {
    func createMainTabBar() -> UITabBarController 
}

final class ViewFactory : ViewFactoryProtocol {
    
    static let shared = ViewFactory()
    
    private init() {}
    
    func createMainTabBar() -> UITabBarController {
        let newsController = UINavigationController(rootViewController: NewsViewController())
        newsController.navigationBar.prefersLargeTitles = true
        newsController.tabBarItem.title = Strings.News.title
        newsController.tabBarItem.image = UIImage(named: "NewsIcon")
        
        let mapController = MapViewController()
        mapController.tabBarItem.title = Strings.Map.title
        mapController.tabBarItem.image = UIImage(named: "MapIcon")
        
        let favoritesController = UINavigationController(rootViewController: FavoritesViewController())
        favoritesController.navigationBar.prefersLargeTitles = true
        favoritesController.tabBarItem.title = Strings.Favorites.title
        favoritesController.tabBarItem.image = UIImage(named: "FavoritesIcon")
        
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.navigationBar.prefersLargeTitles = true
        profileController.tabBarItem.title = Strings.Profile.title
        profileController.tabBarItem.image = UIImage(named: "ProfileIcon")

        let controllers = [newsController, mapController, favoritesController, profileController]

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(controllers, animated: false)
        tabBarController.tabBar.backgroundColor = Colors.TabBar.background
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:tabBarController.tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = Colors.TabBar.borderColor
        tabBarController.tabBar.addSubview(lineView)
        
        return tabBarController
    }
}


