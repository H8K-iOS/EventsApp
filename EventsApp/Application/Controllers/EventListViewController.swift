import UIKit
import CoreData

class EventListViewController: UIViewController {
    var viewModel: EventListViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    private let coreDataManager = CoreDataManager()
    let plusImage = UIImage(systemName: "plus.circle.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        
        viewModel.viewDidLoad()
    }

    
}

//MARK: - View Settings
extension EventListViewController {
    func setViews() {
        let barButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(tappdeEventButton))
        barButton.tintColor = .black
        navigationItem.rightBarButtonItem = barButton
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .primaryClr
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EventCell.self, forCellReuseIdentifier: "EventCell")
    }
    
    @objc func tappdeEventButton() {
        viewModel.tappdeAddEventButton()
    }
}

extension EventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cell(at: indexPath) {
        case .event(let eventCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            cell.update(with: eventCellViewModel)
            return cell
        }
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        260
    }
    
}
