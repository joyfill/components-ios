import Foundation
import UIKit

open class Table: UIView, UIViewControllerTransitioningDelegate, tableUpdate {
    
    public var countLabel = Label()
    public var countView = UIView()
    public var titleLabel = Label()
    public var viewButton = Button()
    public var collectionView = CollectionViewTable()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
    var index = Int()
    var saveDelegate: SaveTableFieldValue? = nil
    var fieldDelegate: SaveTextFieldValue? = nil
    
    var numberOfRows = Int()
    var numberOfColumns = Int()
    var numberingData = [String]()
    public var tableIndexNo = Int()
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateRowNumber()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        updateRowNumber()
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
        updateRowNumber()
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    // To get indexPath of tableField
    public func tableIndexNo(indexPath: Int) {
        tableIndexNo = indexPath
        collectionView.tableIndexNo = indexPath
    }
    
    // Update rows count
    func tableCountNumberUpdate(no: Int, tableIndexNo: Int) {
        countLabel.labelText = "+\(no)"
    }
    
    // Update numberOfRows
    public func numberRows(number:Int){
        numberOfRows = number
        collectionView.numberOfRows = number
        setupView()
        updateRowNumber()
    }
    
    // Update numberOfColumns
    public func numberColumns(number:Int) {
        numberOfColumns = number
        collectionView.numberOfColumns = number
        setupView()
        updateRowNumber()
    }
    
    func setupView() {
        // SubViews
        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(toolTipIconButton)
        collectionView.addSubview(countView)
        countView.addSubview(viewButton)
        countView.addSubview(countLabel)
        
        // Constraint to arrange subviews acc. to imageView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        countView.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // CountView Constraint
            countView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -9),
            countView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -9),
            countView.widthAnchor.constraint(equalToConstant: 120),
            countView.heightAnchor.constraint(equalToConstant: 30),
            
            // ViewButton Constraint
            viewButton.topAnchor.constraint(equalTo: countView.topAnchor, constant: 0),
            viewButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor, constant: 2),
            viewButton.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: 0),
            viewButton.widthAnchor.constraint(equalToConstant: 60),
            
            // CountLabel Constraint
            countLabel.topAnchor.constraint(equalTo: countView.topAnchor, constant: 0),
            countLabel.leadingAnchor.constraint(equalTo: viewButton.trailingAnchor, constant: 0),
            countLabel.trailingAnchor.constraint(equalTo: countView.trailingAnchor, constant: -5),
            countLabel.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: 0),
            
            // TableView Constraint
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        setGlobalUserInterfaceStyle()
        countView.layer.cornerRadius = 6
        countView.backgroundColor = .white
        
        viewButton.titleLabel?.textColor = UIColor(hexString: "#1464FF")
        viewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let moreButtonAttributedString = NSMutableAttributedString(string: "View")
        let moreButtonImageAttachment = NSTextAttachment()
        moreButtonImageAttachment.image = UIImage(named: "arrowRight")
        let moreButtonImageAttributedString = NSAttributedString(attachment: moreButtonImageAttachment)
        moreButtonAttributedString.append(NSAttributedString(string: "  "))
        moreButtonAttributedString.append(moreButtonImageAttributedString)
        viewButton.setAttributedTitle(moreButtonAttributedString, for: .normal)
        viewButton.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        
        titleLabel.fontSize = 14
        titleLabel.isTextBold = true
        titleLabel.numberOfLines = 0
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        collectionView.collectionView.layer.borderWidth = 1
        collectionView.collectionView.layer.cornerRadius = 14
        collectionView.collectionView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        countLabel.labelText = "+\(numberOfRows)"
        countLabel.textAlignment = .center
        countLabel.fontSize = 12
    }
    
    // Function to update numberOfRows when insert or delete tapped
    func updateRowNumber() {
        numberingData.removeAll()
        for i in 0...numberOfRows {
            numberingData.append("\(i)")
        }
    }
    
    // Action function for viewButton
    @objc func viewButtonTapped() {
        var parentResponder: UIResponder? = self
        tableColumnTitle[tableIndexNo].insert("", at: 0)
        tableColumnTitle[tableIndexNo].insert("#", at: 1)
        tableColumnType[tableIndexNo].insert("", at: 0)
        tableColumnType[tableIndexNo].insert("#", at: 1)
        
        if tableRowOrder[tableIndexNo].count == 1 {
            tableFieldValue[tableIndexNo].removeLast(2)
        } else if tableRowOrder[tableIndexNo].count == 2 {
            tableFieldValue[tableIndexNo].removeLast(1)
        } else {}
        
        viewType = "modal"
        fieldDelegate?.handleFocus(index: index)
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                viewController.modalPresentationStyle = .fullScreen
                let newViewController = ViewTable()
                newViewController.saveDelegate = self.saveDelegate
                newViewController.fieldDelegate = self.fieldDelegate
                newViewController.index = index
                newViewController.numberOfRows = tableFieldValue[tableIndexNo].count
                newViewController.numberOfColumns = numberOfColumns
                newViewController.transitioningDelegate = self
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.updateTitle(text: titleLabel.text ?? "")
                newViewController.tableIndexNo = tableIndexNo
                newViewController.deleage = self
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
