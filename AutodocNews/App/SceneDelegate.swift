import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let appDIContainer = AppDIContainer()
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let newsFeedVC = appDIContainer.makeNewsFeedModule()
        window.rootViewController = newsFeedVC
        self.window = window
        window.makeKeyAndVisible()
    }
}

