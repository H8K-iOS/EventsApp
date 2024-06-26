import UIKit
import CoreData

final class EventListCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    var onUpdateEvent = {}
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let eventListViewController: EventListViewController = .instantiate()
        let eventListViewModel = EventListViewModel()
        eventListViewModel.coordinator = self
        onUpdateEvent = eventListViewModel.reload
        eventListViewController.viewModel = eventListViewModel
        navigationController.setViewControllers([eventListViewController], animated: false)
    }
    
    func startAddEvent() {
        let addEventCordinator = AddEventCordinator(navigationController: navigationController)
        addEventCordinator.parentCordiator = self
        childCoordinators.append(addEventCordinator)
        addEventCordinator.start()
    }
    
    func onSelect(_ id: NSManagedObjectID) {
        //triger event detail coordinator
        let eventDetailCoordinator = EventDetailCoordinator(
            eventID: id,
            navigationController: navigationController
        )
        eventDetailCoordinator.parentCoordinator = self
        childCoordinators.append(eventDetailCoordinator)
        eventDetailCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
