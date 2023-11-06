import Foundation
import UIKit

public var selectedDropdownOptionIndexPath: [Int?] = []
protocol DropDownSelectText {
    func setDropdownSelectedValue(text: String)
    func updateFieldBorder(borderColor: UIColor, borderWidth: CGFloat)
}

class CustomModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index = Int()
    var delegate: DropDownSelectText?
    public var dropdownOptionArray = [String]()
    public var dropDownSelectValur = String()
    var select = NSMutableArray()
    public var hideDoneButtonOnSingleSelect = ""
    var multipleSelectedDropdownOptionsIndexPath = NSMutableArray()
    
    // define lazy views
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(hexString: "#0066FF"), for: .normal)
        button.addTarget(self, action: #selector(closeDropdownMenu), for: .touchUpInside)
        return button
    }()
    
    lazy var dropdowntableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(Tablecell.self, forCellReuseIdentifier: "Tablecell")
        return tableView
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [titleButton, dropdowntableView, spacer])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        return stackView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 500
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = .light
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeDropdownMenu))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeDropdownMenu() {
        dismissBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBackgroundView()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        if hideDoneButtonOnSingleSelect == "singleSelect" {
            containerView.addSubview(dropdowntableView)
            dropdowntableView.translatesAutoresizingMaskIntoConstraints = false
            
            // Set static constraints
            NSLayoutConstraint.activate([
                // set dimmedView edges to superview
                backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                dropdowntableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                dropdowntableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
                dropdowntableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
                dropdowntableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            ])
            
        } else {
            containerView.addSubview(titleButton)
            titleButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(dropdowntableView)
            dropdowntableView.translatesAutoresizingMaskIntoConstraints = false
            
            // Set static constraints
            NSLayoutConstraint.activate([
                // set dimmedView edges to superview
                backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                titleButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                titleButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                titleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -23),
                
                dropdowntableView.topAnchor.constraint(equalTo: titleButton.topAnchor, constant: 40),
                dropdowntableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
                dropdowntableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
                dropdowntableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            ])
        }
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    // MARK: Present and dismiss view animation
    func showBackgroundView() {
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0.6
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissBackgroundView() {
        self.delegate?.updateFieldBorder(borderColor: UIColor(hexString: "#D1D1D6") ?? .lightGray, borderWidth: 1)
        backgroundView.alpha = 0.6
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    //Table class extension to add tableview delegate and dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath as IndexPath) as! Tablecell
        
        if hideDoneButtonOnSingleSelect == "singleSelect" {
            if selectedDropdownOptionIndexPath[index] == indexPath.row {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.cellView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellView.backgroundColor = .white
                cell.cellCheckbox.checkboxFillColor = .white
            }
        } else {
            if multipleSelectedDropdownOptionsIndexPath.contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.cellView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellView.backgroundColor = .white
                cell.cellCheckbox.checkboxFillColor = .white
            }
        }
        
        cell.cellLabel.text = dropdownOptionArray[indexPath.row]
        cell.cellCheckbox.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if hideDoneButtonOnSingleSelect == "singleSelect" {
            selectedDropdownOptionIndexPath[index] = indexPath.row
            let text = dropdownOptionArray[indexPath.row]
            self.delegate?.setDropdownSelectedValue(text: text)
            dismissBackgroundView()
            dropdowntableView.reloadData()
        } else {
            if multipleSelectedDropdownOptionsIndexPath.contains(indexPath.row) {
                multipleSelectedDropdownOptionsIndexPath.remove(indexPath.row)
                let selectCount = multipleSelectedDropdownOptionsIndexPath.count
                self.delegate?.setDropdownSelectedValue(text: String(selectCount))
                dropdowntableView.reloadData()
            } else {
                multipleSelectedDropdownOptionsIndexPath.add(indexPath.row)
                let selectCount = multipleSelectedDropdownOptionsIndexPath.count
                self.delegate?.setDropdownSelectedValue(text: String(selectCount))
                dropdowntableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the required height for the text in the cell
        let text = dropdownOptionArray[indexPath.row]
        let font = UIFont.systemFont(ofSize: 18)
        let width = tableView.frame.width - 10
        let height = heightForText(text, font: font, width: width)
        return height + 35
    }
}

class Tablecell: UITableViewCell {
    
    var cellCheckbox = Checkbox()
    var cellLabel = UILabel()
    var cellView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell() {
        // SubView
        contentView.addSubview(cellView)
        cellView.addSubview(cellCheckbox)
        cellView.addSubview(cellLabel)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellCheckbox.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellCheckbox.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20),
            cellCheckbox.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 27),
            cellCheckbox.widthAnchor.constraint(equalToConstant: 18),
            cellCheckbox.heightAnchor.constraint(equalToConstant: 18),
            
            cellLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 2),
            cellLabel.leadingAnchor.constraint(equalTo: cellCheckbox.trailingAnchor, constant: 17),
            cellLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 5),
            cellLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 2)
        ])
        
        cellCheckbox.checkmarkStyle = .tick
        cellCheckbox.borderStyle = .circle
        cellCheckbox.borderLineWidth = 1
        cellCheckbox.checkmarkColor = .white
        cellCheckbox.borderCornerRadius = 10
        cellCheckbox.uncheckedBorderColor = .gray
        cellCheckbox.borderLineWidth = 1
        cellLabel.numberOfLines = 0
        cellLabel.font = UIFont(name: "Helvetica Neue", size: 18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
