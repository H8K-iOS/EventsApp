import UIKit

final class EditEventViewModel {
    
    let title = "Edit"
    var onUpdate: () -> Void = {}
    
    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    
    weak var coordinator: EditEventCordinator?
    private(set) var cells: [EditEventViewModel.Cell] = []
    private var cellBuiler: EventsCellBuilder
    
    private var nameCellViewModel: TitleSubtitleCellViewModel?
    private var dateCellViewvModel: TitleSubtitleCellViewModel?
    private var backgrondImageCellViewModel: TitleSubtitleCellViewModel?
    private let coreDateManager: CoreDataManager
    private let event: Event
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    init(event: Event,
         cellBuilder: EventsCellBuilder,
         coreDateManager: CoreDataManager = CoreDataManager.shared
    ) {
        self.cellBuiler = cellBuilder
        self.coreDateManager = coreDateManager
        self.event = event
    }
    
    func viewDidLoad() {
        setupCells()
        onUpdate()
    }
    
    func addEventViewDidDisappear() {
        coordinator?.didFinish()
    }
    
    func numberOfRows() -> Int {
        return cells.count
    }
    
    func cell(for indexPath: IndexPath) -> Cell{
        return cells[indexPath.row]
    }
    
    
    func tappedDone() {
        //extract info frm cell viewmodels + save in core data
        //+ tell coordinatopr to dismiss
       
        guard let name = nameCellViewModel?.subtitle,
              let dateString = dateCellViewvModel?.subtitle,
              let image = backgrondImageCellViewModel?.image,
              let date = dateFormatter.date(from: dateString)
        else { return }
        
        coreDateManager.updateEvent(event: event, name: name, image: image, date: date)
        coordinator?.didFinishUpdateEvent()
        
    }
    
    func updateCell(indexPath: IndexPath, subtitel: String) {
        switch cells[indexPath.row] {
        case.titleSubtitle(let titleSubtitleCellViewModel):
            titleSubtitleCellViewModel.update(subtitel)
        }
    }
    
    func didSelectRow(at indexPatch: IndexPath) {
        switch cells[indexPatch.row] {
        case .titleSubtitle(let titleSubtitleViewModel):
            guard titleSubtitleViewModel.type == .image else {
                return
            }
            coordinator?.showImgPicker { image in
                titleSubtitleViewModel.update(image)
            }
        }
    }
}


private extension EditEventViewModel {
    func setupCells() {
        nameCellViewModel = cellBuiler.makeTitleSubtitleCellViewModel(.text)
        
        dateCellViewvModel = cellBuiler.makeTitleSubtitleCellViewModel(.date) {[weak self] in
            self?.onUpdate()
        }

        backgrondImageCellViewModel = cellBuiler.makeTitleSubtitleCellViewModel(.image) {[weak self] in
            self?.onUpdate()
        }
        
        guard let nameCellViewModel = nameCellViewModel, let dateCellViewvModel = dateCellViewvModel, let backgrondImageCellViewModel = backgrondImageCellViewModel else { return }
        
        cells = [
            .titleSubtitle(
                nameCellViewModel
            ),
            .titleSubtitle(
                dateCellViewvModel
            ),
            
            .titleSubtitle(
                backgrondImageCellViewModel
            ),
        ]
        guard let name = event.name,
              let date = event.date,
              let imageData = event.image,
              let image = UIImage(data: imageData)
        else { return }
        
        nameCellViewModel.update(name)
        dateCellViewvModel.update(date)
        backgrondImageCellViewModel.update(image)
    }
}
