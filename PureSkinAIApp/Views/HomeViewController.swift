import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var customTabBarController: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
        tabBar.tabBar.unselectedItemTintColor = .gray
        return tabBar
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup
    private func setupTabBar() {
        let productsVC = ProductsViewController()
        let productsNav = UINavigationController(rootViewController: productsVC)
        productsNav.tabBarItem = UITabBarItem(title: "Ürünler", image: UIImage(systemName: "sparkles"), tag: 0)
        
        let routinesVC = RoutinesViewController()
        let routinesNav = UINavigationController(rootViewController: routinesVC)
        routinesNav.tabBarItem = UITabBarItem(title: "Rutinler", image: UIImage(systemName: "calendar"), tag: 1)
        
        let chatVC = ChatViewController()
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatNav.tabBarItem = UITabBarItem(title: "Sohbet", image: UIImage(systemName: "message.fill"), tag: 2)
        
        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.fill"), tag: 3)
        
        customTabBarController.viewControllers = [productsNav, routinesNav, chatNav, profileNav]
        addChild(customTabBarController)
        view.addSubview(customTabBarController.view)
        customTabBarController.view.frame = view.bounds
        customTabBarController.didMove(toParent: self)
    }
} 