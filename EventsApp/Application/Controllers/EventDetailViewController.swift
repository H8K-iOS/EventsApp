import UIKit

final class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeRemainigStackView: TimeRemainingStackView! {
        didSet {
            timeRemainigStackView.setup()
        }
    }
    var viewModel: EventDetailViewModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        viewModel.onUpdate = {[weak self] in
            guard let self = self, let timeRemainigViewModel = self.viewModel.timeRemainigViewModel else { return }
            self.backgroundImageView.image = self.viewModel.image
            self.timeRemainigStackView.update(with: timeRemainigViewModel)
        }
        
        navigationItem.rightBarButtonItem = .init(image: UIImage(systemName: "pencil"), style: .plain, target: viewModel, action: #selector(viewModel.editButtonTapped))
        viewModel.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.viewDidDisappear()
    }
}


extension EventDetailViewController {
    func setupViews() {
        timeRemainigStackView.layer.cornerRadius = 10
        
        navigationController?.navigationBar.tintColor = .white
    }
}


