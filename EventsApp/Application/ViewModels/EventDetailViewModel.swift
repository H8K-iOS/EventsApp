import UIKit
import CoreData

final class EventDetailViewModel {
    private let eventID: NSManagedObjectID
    private let coreDataManager: CoreDataManager
    private var event: Event?
    var coordinator: EventDetailCoordinator?
    private let currentDate = Date()
    var onUpdate = {}
    
    var image: UIImage? {
        guard let imageData = event?.image else { return nil}
        return UIImage(data: imageData)
    }
    
    var timeRemainigViewModel: TimeRemainingViewModel? {
        guard let eventDate = event?.date, let timeRemainingParts = currentDate.timeRemaining(until: eventDate)?.components(separatedBy: ",") else { return nil }
        
        return TimeRemainingViewModel(
            timeRemainingParts: timeRemainingParts,
            mode: .detail
        )
    }
    
    init(eventID: NSManagedObjectID, coreDataManager: CoreDataManager = .shared) {
        self.eventID = eventID
        self.coreDataManager = coreDataManager
    }
    
    func viewDidLoad() {
        reload()
    }
    
    func viewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func reload() {
        event = coreDataManager.getEvent(eventID)
        onUpdate()
    }
    
    @objc func editButtonTapped() {
        guard let event = event else { return }
        coordinator?.onEditEvent(event: event)
    }
}
