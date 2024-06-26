import Foundation
import UIKit

final class AddEventCordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    private var completion: (UIImage) -> Void = {_ in }
    
    var parentCordiator: EventListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.modalNavigationController = UINavigationController()
        let addEventViewController: AddEventViewController = .instantiate()
        modalNavigationController?.setViewControllers([addEventViewController], animated: false)
        let addEventViewModel = AddEventViewModel(cellBuilder: EventsCellBuilder())
        addEventViewModel.coordinator = self
        addEventViewController.viewModel = addEventViewModel
        if let modalNavigationController = modalNavigationController{
            navigationController.present(modalNavigationController, animated: true, completion: nil)
        }
        
     
    }
    
    
    func didFinish() {
        parentCordiator?.childDidFinish(self)
    }
    
    func didFinishSaveEvent() {
        parentCordiator?.onUpdateEvent()
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func showImgPicker(complition: @escaping(UIImage) -> Void) {
        guard let modalNavigationController = modalNavigationController else {
            return
        }
        self.completion = complition
        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: modalNavigationController)
        imagePickerCoordinator.onFinishPicking = { image in
            self.completion(image)
            self.modalNavigationController?.dismiss(animated: true)
        }
        imagePickerCoordinator.parentCoordinator = self
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
