import UIKit

final class TitleSubtitleCell: UITableViewCell {
    private let titleLabel = UILabel()
    let subtitleTF = UITextField()
    private let verticalStackView = UIStackView()
    private let padding: CGFloat = 15
    
    private let datePckerView = UIDatePicker()
    private let toolbar = UIToolbar()
    lazy var doneBarButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDone))
    }()
    
    private let photoIMgView = UIImageView()
    
    private var viewModel: TitleSubtitleCellViewModel?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViews()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with viewModel: TitleSubtitleCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        
        subtitleTF.text = viewModel.subtitle
        subtitleTF.placeholder = viewModel.placeholder
        
        subtitleTF.inputView = viewModel.type == .text ? nil : datePckerView
        subtitleTF.inputAccessoryView = viewModel.type == .text ? nil : toolbar
        
        photoIMgView.isHidden = viewModel.type != .image
        subtitleTF.isHidden = viewModel.type == .image
        
        photoIMgView.image = viewModel.image
        
        verticalStackView.spacing = viewModel.type == .image ? 15 : 1
    }
    
    private func setViews() {
        verticalStackView.axis = .vertical
        titleLabel.font = .systemFont(ofSize: 22, weight: .medium)
        subtitleTF.font = .systemFont(ofSize: 20)
        
        photoIMgView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        photoIMgView.layer.cornerRadius = 18
        photoIMgView.clipsToBounds = true
        photoIMgView.alpha = 1
        
        doneBarButton.tintColor = .black
        
        datePckerView.datePickerMode = .date
        datePckerView.preferredDatePickerStyle = .wheels
        
        [verticalStackView, titleLabel, subtitleTF, datePckerView, toolbar].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        toolbar.setItems([doneBarButton], animated: false)
    }
    
    private func setHierarchy() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(subtitleTF)
        verticalStackView.addArrangedSubview(photoIMgView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo:
                                                    contentView.topAnchor,
                                                    constant: padding),
            verticalStackView.leftAnchor.constraint(equalTo:
                                                    contentView.leftAnchor,
                                                    constant: padding),
            verticalStackView.bottomAnchor.constraint(equalTo:
                                                    contentView.bottomAnchor,
                                                    constant: -padding),
            verticalStackView.rightAnchor.constraint(equalTo:
                                                    contentView.rightAnchor,
                                                    constant: -padding),
        ])
        
        photoIMgView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    @objc private func tappedDone() {
        
        viewModel?.update(datePckerView.date)
    }
}

