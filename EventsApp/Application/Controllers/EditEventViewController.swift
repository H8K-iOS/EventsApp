import UIKit

final class EditEventViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: EditEventViewModel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.viewDidLoad()
        setViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.addEventViewDidDisappear()
    }
    
    
    
    @objc func tappedDoneButtone() {
        viewModel.tappedDone()
    }
    
    
    private func setViews() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: "TitleSybtitleCell")
        //tableView.tableFooterView = UIView()
        
        navigationItem.title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButtone))
        navigationController?.navigationBar.tintColor = .black
        
        // to force large titles
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.setContentOffset(.init(x: 0, y: -1), animated: false)

    }
}

extension EditEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension EditEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.cell(for: indexPath)
        
        switch cellViewModel {
        case .titleSubtitle(let titleSubTititleCellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSybtitleCell", for: indexPath) as! TitleSubtitleCell
            cell.update(with: titleSubTititleCellViewModel)
            cell.subtitleTF.delegate = self
            return cell
        }
    }
    
}

extension EditEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        let text = currentText + string

        let point = textField.convert(textField.bounds.origin, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            viewModel.updateCell(indexPath: indexPath, subtitel: text)
        }
        return true
    }
}
