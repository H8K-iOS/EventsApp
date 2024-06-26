import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func start()
    func childDidFinish(_ childCoordinators: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ childCoordinator: Coordinator) {}
}

final class ApplicationCordinator: Coordinator {
    
    private var window = UIWindow()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    private(set) var childCoordinators: [Coordinator] = []
    
    
    func start() {
        let navigationController = UINavigationController()
        
        let eventListCordinator = EventListCoordinator(navigationController:
                                                        navigationController)
        
        childCoordinators.append(eventListCordinator)
        eventListCordinator.start()
    
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}
