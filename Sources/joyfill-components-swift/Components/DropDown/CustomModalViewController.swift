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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(UIColor(hexString: "#4776EE"), for: .normal)
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
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        // tap gesture on dimmed view to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        setupPanGesture()
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
                dropdowntableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
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
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
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
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")
        
        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
        
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
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
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
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
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
                cell.myCheckbox.isChecked = true
                cell.myCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.myView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.myCheckbox.isChecked = false
                cell.myView.backgroundColor = .white
                cell.myCheckbox.checkboxFillColor = .white
            }
        } else {
            if select.contains(indexPath.row) {
                print(select)
                cell.myCheckbox.isChecked = true
                cell.myCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
                cell.myView.backgroundColor = UIColor(hexString: "#E3E3E3")
            } else {
                cell.myCheckbox.isChecked = false
                cell.myView.backgroundColor = .white
                cell.myCheckbox.checkboxFillColor = .white
            }
        }
        
        cell.cellLabel.text = dropdownOptionArray[indexPath.row] as? String ?? ""
        cell.myCheckbox.isUserInteractionEnabled = false
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
}

class Tablecell: UITableViewCell {
    
    var myCheckbox = Checkbox()
    var cellLabel = UILabel()
    var myView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        myView.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(bounds.size.height))
        contentView.addSubview(myView)
        myCheckbox.frame = CGRect(x: 27, y: 0, width: 18, height: 18)
        myCheckbox.checkmarkStyle = .tick
        myCheckbox.borderStyle = .circle
        myCheckbox.center.y = contentView.center.y
        myCheckbox.borderLineWidth = 1
        myCheckbox.checkmarkColor = .white
        myCheckbox.borderCornerRadius = 10
        myCheckbox.uncheckedBorderColor = .gray
        myCheckbox.borderLineWidth = 1
        myView.addSubview(myCheckbox)
        
        cellLabel.frame = CGRect(x: myCheckbox.frame.maxX + 17, y: 0, width: 200, height: 25)
        cellLabel.center.y = contentView.center.y
        myView.addSubview(cellLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override class func awakeFromNib() {}
}
