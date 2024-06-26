import UIKit

final class AddEventViewModel {
    
    let title = "Add"
    var onUpdate: () -> Void = {}
    
    enum Cell {
        case titleSubtitle(TitleSubtitleCellViewModel)
    }
    
    weak var coordinator: AddEventCordinator?
    private(set) var cells: [AddEventViewModel.Cell] = []
    private var cellBuiler: EventsCellBuilder
    
    private var nameCellViewModel: TitleSubtitleCellViewModel?
    private var dateCellViewvModel: TitleSubtitleCellViewModel?
    private var backgrondImageCellViewModel: TitleSubtitleCellViewModel?
    private let coreDateManager: CoreDataManager
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter
    }()
    
    init(cellBuilder: EventsCellBuilder, coreDateManager: CoreDataManager = CoreDataManager.shared) {
        self.cellBuiler = cellBuilder
        self.coreDateManager = coreDateManager
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
        
        coreDateManager.saveEvent(name: name, image: image, date: date)
        coordinator?.didFinishSaveEvent()
        
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


private extension AddEventViewModel {
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
    }
}
