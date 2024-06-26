import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EventsApp")
        persistentContainer.loadPersistentStores { _, err in
            print(err?.localizedDescription ?? "")
        }
        return persistentContainer
    }()
    
//MARK: = Manage obj contentext
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func getEvent(_ eventId: NSManagedObjectID) -> Event? {
        do {
            return try moc.existingObject(with: eventId) as? Event
        } catch {
            print(error)
        }
        return nil
    }
    
    func saveEvent(name: String, image: UIImage, date: Date) {
        let event = Event(context: moc)
        event.setValue(name, forKeyPath: "name")
        
        let resizedImage = image.sameAspectRatio(newHeigt: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(date, forKey: "date")
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func updateEvent(event: Event, name: String, image: UIImage, date: Date) {
        event.setValue(name, forKeyPath: "name")
        
        let resizedImage = image.sameAspectRatio(newHeigt: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(date, forKey: "date")
        
        do {
            try moc.save()
        } catch {
            print(error)
        }

    }
    
    func fetchEvent() -> [Event] {
        do {
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            let events = try moc.fetch(fetchRequest)
            return events
        } catch {
            print("error")
            return []
        }
    }
}
