import Foundation
import UIKit

final class EditEventCordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var event: Event
    private var completion: (UIImage) -> Void = {_ in }
    
    var parentCordiator: EventDetailCoordinator?
    
    init(event: Event,
         navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        self.event = event
    }
    
    func start() {
        let editEventViewController: EditEventViewController = .instantiate()
        let editEventViewModel = EditEventViewModel(event: event,
                                                    cellBuilder: EventsCellBuilder()
        )
        editEventViewModel.coordinator = self
        editEventViewController.viewModel = editEventViewModel
        navigationController.pushViewController(editEventViewController, animated: true)
        
    }
    
    
    func didFinish() {
        parentCordiator?.childDidFinish(self)
    }
    
    func didFinishUpdateEvent() {
        parentCordiator?.onUpdateEvent()
        navigationController.popViewController(animated: true)
    }
    
    func showImgPicker(complition: @escaping(UIImage) -> Void) {
        self.completion = complition
        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: navigationController)
        imagePickerCoordinator.parentCoordinator = self
        imagePickerCoordinator.onFinishPicking = { image in
            complition(image)
            self.navigationController.dismiss(animated: true, completion: nil)
        }
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }

    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
