import Foundation
import UIKit

protocol DropDownSelectText {
    func selectText(text:String)
}

class CustomModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sltArray : Int?
    public var dropdownOptionArray: NSArray = ["Yes","No","N/A"]
    var select = NSMutableArray()
    var delegate:DropDownSelectText?
    public var doneHide = ""
    
    // define lazy views
    lazy var titleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(hexString: "#0066FF"), for: .normal)
        button.addTarget(self, action: #selector(doneClickCloseAction), for: .touchUpInside)
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
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 300
    let dismissibleHeight: CGFloat = 200
    var currentContainerHeight: CGFloat = 300
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupPanGesture()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func doneClickCloseAction(_ sender: Any) {
        animateDismissView()
    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        if doneHide == "singleSelect" {
            containerView.addSubview(dropdowntableView)
            dropdowntableView.translatesAutoresizingMaskIntoConstraints = false
            
            // Set static constraints
            NSLayoutConstraint.activate([
                // set dimmedView edges to superview
                dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
                dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                // set container static constraint (trailing & leading)
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                // content stackView
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
                dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
                dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                // set container static constraint (trailing & leading)
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                // content stackView
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
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Pan gesture handler
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        
        // New height is based on value of dragging plus current container height
        let newHeight = currentContainerHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < maximumContainerHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // This happens when user stop drag,
            // so we will get the last height of container
            // Condition 1: If new height is below min, dismiss controller
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    //Table class extension to add tableview delegate and dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tablecell", for: indexPath as IndexPath) as! Tablecell
        if doneHide == "singleSelect" {
            if sltArray != nil && sltArray == indexPath.row {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.cellView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellView.backgroundColor = .white
                cell.cellCheckbox.checkboxFillColor = .white
            }
        } else {
            if select.contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.cellView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellView.backgroundColor = .white
                cell.cellCheckbox.checkboxFillColor = .white
            }
        }
        
        cell.cellLabel.text = dropdownOptionArray[indexPath.row] as? String ?? ""
        cell.cellCheckbox.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if doneHide == "singleSelect" {
            sltArray = indexPath.row
            let text = dropdownOptionArray[indexPath.row] as? String ?? ""
            self.delegate?.selectText(text: text)
            animateDismissView()
            dropdowntableView.reloadData()
        } else {
            if select.contains(indexPath.row) {
                select.remove(indexPath.row)
                let selectCount = select.count
                self.delegate?.selectText(text: String(selectCount))
                dropdowntableView.reloadData()
            } else {
                select.add(indexPath.row)
                let selectCount = select.count
                self.delegate?.selectText(text: String(selectCount))
                dropdowntableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the required height for the text in the cell
        let text = dropdownOptionArray[indexPath.row]
        let font = UIFont.systemFont(ofSize: 18) // Replace with your desired font and size
        let width = tableView.frame.width - 10 // Adjust the left and right margins
        let height = heightForText(text as! String, font: font, width: width)
        return height + 35
    }
    
    // Helper method to calculate the height of the text
    func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let nsText = text as NSString
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = nsText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes, context: nil)
        return ceil(boundingRect.height)
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
