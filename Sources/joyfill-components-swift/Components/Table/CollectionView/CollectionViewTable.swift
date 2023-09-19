import Foundation
import UIKit

public class CollectionViewTable: UIView, UIImagePickerControllerDelegate, TextViewCellDelegate, UINavigationControllerDelegate, DropDownSelectText {
    
    var indexPathRow = Int()
    var indexPathItem = Int()
    var indexPathSection = Int()
    var dropDownSelectedValue = String()
    
    let layout = TwoWayScrollingCollectionViewLayout()
    public lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .clear
        layout.stickyRowsCount = 1
        return cv
    }()
    
    // Sets border of the collectionView
    @IBInspectable
    open var borderWidth: CGFloat = 1 {
        didSet {
            collectionView.layer.borderWidth = borderWidth
        }
    }
    
    // Sets border color of the collectionView
    @IBInspectable
    open var borderColor: UIColor = UIColor.black {
        didSet {
            collectionView.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    open var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    // Function to update numberOfRows when insert or delete tapped
    func updateRowNumber() {
        numberingData.removeAll()
        numberOfRows = tableRowOrder.count
        for i in 0...numberOfRows {
            numberingData.append("\(i)")
        }
    }
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateRowNumber()
        registerCollectionViewCell()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateRowNumber()
        registerCollectionViewCell()
    }
    
    public init() {
        super.init(frame: .zero)
        updateRowNumber()
        registerCollectionViewCell()
    }
    
    func registerCollectionViewCell() {
        addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        //Add constraint
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        numberOfColumns = tableColumnType.count
        tableHeading = tableColumnTitle
        
        // To show fake rows with empty data
        if tableFieldValue.count == 1 {
            tableFieldValue.append(emptyValueElement)
            tableFieldValue.append(emptyValueElement)
        } else if tableFieldValue.count == 2 {
            tableFieldValue.append(emptyValueElement)
        } else {}
    }
}

// Table class extension to add collectionView delegate and dataSource methods
extension CollectionViewTable: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: CollectionView delegate method for number of sections
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    // MARK: CollectionView delegate method for number of items in section
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    // MARK: CollectionView delegate method for cell for item at
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = .clear
        cell.textViewDelegate = self
        
        viewTableDispalyMode(at: cell)
        viewTablePopUpModal(cell: cell, indexPath: indexPath)
        viewTableCollectionViewHeader(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: CollectionView delegate method for cell selection at indexPath
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tableDisplayMode != "readonly" {
            if tableColumnType[indexPath.row] == "dropdown" {
                let dropdownOptionArray: NSArray = ["Yes","No","N/A"]
                let vc = CustomModalViewController()
                vc.modalPresentationStyle = .overCurrentContext
                vc.hideDoneButtonOnSingleSelect = "singleSelect"
                vc.delegate = self
                vc.dropdownOptionArray = dropdownOptionArray
                
                var parentResponder: UIResponder? = self
                while parentResponder != nil {
                    parentResponder = parentResponder?.next
                    if let viewController = parentResponder as? UIViewController {
                        let newViewController = vc
                        viewController.present(newViewController, animated: false)
                        break
                    }
                }
                
                indexPathRow = indexPath.row
                indexPathItem = indexPath.item
                indexPathSection = indexPath.section
            }
        }
    }
    
    // MARK: CollectionView delegate method to adjust cell height and width
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = Double()
        let cellHeight = 50.0
        
        if tableColumnOrderId.count == 1 {
            cellWidth = self.frame.width
        } else if tableColumnOrderId.count == 2 {
            cellWidth = self.frame.width / 2
        } else {
            cellWidth = 133.0
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: TextView delegate method for textView selection
    func textViewCellDidSelect(_ cell: UICollectionViewCell) {
        if let previousCell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            previousCell.cellTextView.borderWidth = 0
        }
        let indexPath = collectionView.indexPath(for: cell)
        if let cell = collectionView.cellForItem(at: indexPath ?? IndexPath(row: 0, section: 0)) as? CollectionViewCell {
            cell.cellTextView.layer.borderWidth = 1.0
            cell.cellTextView.layer.cornerRadius = 1.0
            cell.cellTextView.layer.borderColor = UIColor(hexString: "#1F6BFF")?.cgColor
            cell.cellTextView.selectedRange = NSRange(location: cell.cellTextView.text.count, length: 0)
            cell.cellTextView.becomeFirstResponder()
        }
        
        selectedTextFieldIndexPath = indexPath ?? IndexPath(row: 0, section: 0)
    }
    
    // Function to handle table popup modal
    func viewTablePopUpModal(cell: CollectionViewCell, indexPath: IndexPath) {
        if tableColumnType[indexPath.row] == "dropdown" {
            if indexPath.section > 0 {
                setCellDropdownValue(cell: cell, indexPath: indexPath)
            }
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setDropdownInTableColumn()
        } else {
            if indexPath.section > 0 {
                setCellTextValue(cell: cell, indexPath: indexPath)
            }
            cell.cellTextView.textContainer.maximumNumberOfLines = 2
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setTextViewInTableColumn()
        }
    }
    
    // Function to set dropdown value after matching column id
    func setCellDropdownValue(cell: CollectionViewCell, indexPath: IndexPath) {
        let cellData = tableFieldValue[indexPath.section-1].cells ?? [:]
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[indexPath.row]}) {
            for i in 0..<(optionsData.count) {
                let tableColumnsData = optionsData[i].options
                if let dropDownId = tableColumnsData?.first(where: {$0.id == matchData.value}) {
                    cell.dropdownTextField.text = dropDownId.value
                }
            }
        } else {
            cell.dropdownTextField.text = ""
        }
    }
    
    // Function to set text value after matching column id
    func setCellTextValue(cell: CollectionViewCell, indexPath: IndexPath) {
        let cellData = tableFieldValue[indexPath.section-1].cells ?? [:]
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[indexPath.row]}) {
            cell.cellTextView.text = matchData.value
        } else {
            cell.cellTextView.text = ""
        }
    }
    
    // Function to handle cells according to displayMode
    func viewTableDispalyMode(at cell: CollectionViewCell) {
        switch tableDisplayMode {
        case "readonly":
            cell.cellTextView.isUserInteractionEnabled = false
        default:
            cell.cellTextView.isUserInteractionEnabled = true
        }
    }
    
    // Function to handle collectionView header
    func viewTableCollectionViewHeader(cell: CollectionViewCell, indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cellLabel = Label()
            cellLabel.borderWidth = 1
            cellLabel.borderCornerRadius = 0
            cellLabel.textAlignment = .center
            cellLabel.numberOfLines = 1
            cellLabel.labelText = tableColumnTitle[indexPath.row]
            cellLabel.backgroundColor = UIColor(hexString: "#F3F4F8")
            cellLabel.borderColor = UIColor(hexString: "#E6E7EA") ?? .lightGray
            
            // Set the width of cells based on numberOfColumns
            if tableColumnOrderId.count == 1 {
                cellLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50.0)
            } else if tableColumnOrderId.count == 2 {
                cellLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width / 2, height: 50.0)
            } else {
                cellLabel.frame = CGRect(x: 0, y: 0, width: 133.0, height: 50.0)
            }
            
            cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
            cell.contentView.addSubview(cellLabel)
        default:
            break
        }
    }
    
    func setDropdownSelectedValue(text: String) {
        dropDownSelectedValue = text
        let cell = collectionView.cellForItem(at: IndexPath(row: indexPathRow, section: indexPathSection)) as? CollectionViewCell
        cell?.dropdownTextField.text = text
    }
}
