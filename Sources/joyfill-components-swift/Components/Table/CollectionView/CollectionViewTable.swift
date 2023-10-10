import Foundation
import UIKit

public class CollectionViewTable: UIView {

    var tableIndexNo = Int()
    var indexPathRow = Int()
    var numberOfRows = Int()
    var indexPathItem = Int()
    var numberOfColumns = Int()
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
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        collectionView.reloadData()
    }
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        registerCollectionViewCell()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
        registerCollectionViewCell()
    }
    
    public init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
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
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        numberOfColumns = tableColumnType[tableIndexNo].count
        tableHeading = tableColumnTitle[tableIndexNo]
        
        // To show fake rows with empty data
        if tableFieldValue[tableIndexPath].count == 1 {
            tableFieldValue[tableIndexPath].append(emptyValueElement)
            tableFieldValue[tableIndexPath].append(emptyValueElement)
        } else if tableFieldValue[tableIndexPath].count == 2 {
            tableFieldValue[tableIndexPath].append(emptyValueElement)
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
        
        viewTableDispalyMode(at: cell)
        viewTablePopUpModal(cell: cell, indexPath: indexPath)
        viewTableCollectionViewHeader(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: CollectionView delegate method to adjust cell height and width
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = Double()
        let cellHeight = 50.0
        
        if tableColumnOrderId[tableIndexNo].count == 1 {
            cellWidth = self.frame.width
        } else if tableColumnOrderId[tableIndexNo].count == 2 {
            cellWidth = self.frame.width / 2
        } else {
            cellWidth = 133.0
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // Function to handle table popup modal
    func viewTablePopUpModal(cell: CollectionViewCell, indexPath: IndexPath) {
        if tableColumnType[tableIndexNo][indexPath.row] == "dropdown" {
            if indexPath.section > 0 {
                setCellDropdownValue(cell: cell, indexPath: indexPath)
            }
            cell.dropdownView.isUserInteractionEnabled = false
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setDropdownInTableColumn()
        } else {
            if indexPath.section > 0 {
                setCellTextValue(cell: cell, indexPath: indexPath)
            }
            cell.cellTextView.isUserInteractionEnabled = false
            cell.cellTextView.textContainer.maximumNumberOfLines = 2
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setTextViewInTableColumn()
        }
    }
    
    // Function to set dropdown value after matching column id
    func setCellDropdownValue(cell: CollectionViewCell, indexPath: IndexPath) {
        let cellData = tableFieldValue[tableIndexNo][indexPath.section-1].cells ?? [:]
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[tableIndexNo][indexPath.row]}) {
            let tableColumnsData = optionsData[tableIndexNo][indexPath.row].options
            if let dropDownId = tableColumnsData?.first(where: {$0.id == matchData.value}) {
                cell.dropdownTextField.text = dropDownId.value
            }
        } else {
            cell.dropdownTextField.text = ""
        }
    }
    
    // Function to set text value after matching column id
    func setCellTextValue(cell: CollectionViewCell, indexPath: IndexPath) {
        let cellData = tableFieldValue[tableIndexNo][indexPath.section-1].cells ?? [:]
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[tableIndexNo][indexPath.row]}) {
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
            cellLabel.labelText = tableColumnTitle[tableIndexNo][indexPath.row]
            cellLabel.backgroundColor = UIColor(hexString: "#F3F4F8")
            cellLabel.borderColor = UIColor(hexString: "#E6E7EA") ?? .lightGray
            
            // Set the width of cells based on numberOfColumns
            if tableColumnOrderId[tableIndexNo].count == 1 {
                cellLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50.0)
            } else if tableColumnOrderId[tableIndexNo].count == 2 {
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
}
