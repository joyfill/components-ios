import Foundation
import UIKit

public class CollectionViewTable: UIView, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let layout = CustomCollectionViewLayout()
    public lazy var collectionView : UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        cv.backgroundColor = .clear
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
    
    // Sets collectionViewCell height
    @IBInspectable
    open var cellHeight: Double = 50.0 {
        didSet {
            layout.CELL_HEIGHT = cellHeight
        }
    }
    
    // Sets collectionViewCell width
    @IBInspectable
    open var cellWidth: Double = 200.0 {
        didSet {
            layout.CELL_WIDTH = cellWidth
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
        numberOfRows = 20
        for i in 0...numberOfRows {
            numberingData.append("\(i)")
        }
    }
    
    func registerCollectionViewCell() {
        addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        //Add constraint
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
}

// Table class extension to add collectionView delegate and dataSource methods
extension CollectionViewTable: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: CollectionView delegate method for number of sections
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfRows
    }
    
    // MARK: CollectionView delegate method for number of items in section
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    // MARK: CollectionView delegate method for cell for item at
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.contentView.backgroundColor = .clear
        
        setUpCellTextField(at: cell)
        collectionViewHeader(cell: cell, indexPath: indexPath)
        return cell
    }
    
    // Function to set properties of textField
    func setUpCellTextField(at cell: CollectionViewCell) {
        switch tableDisplayMode {
        case "readonly":
            cell.cellTextField.isUserInteractionEnabled = false
        default:
            cell.cellTextField.isUserInteractionEnabled = true
        }
        
        cell.cellTextField.borderWidth = 0
        cell.cellTextField.containerRadius = 0
        cell.cellTextField.text = "Text 1 at 2"
        cell.cellTextField.textAlignment = .center
        cell.cellTextField.selectedBorderWidth = 1
        cell.cellTextField.selectedCornerRadius = 1
        cell.cellTextField.deselectedBorderWidth = 0
        cell.cellTextField.deselectedCornerRadius = 0
        cell.cellTextField.deselectedBorderColor = .clear
        cell.cellTextField.font = UIFont.systemFont(ofSize: 12)
        cell.cellTextField.setOutlineLineWidth(0, for: .normal)
        cell.cellTextField.setOutlineLineWidth(0, for: .editing)
        cell.cellTextField.selectedBorderColor = UIColor(hexString: "#1F6BFF") ?? .systemBlue
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.setupSeparator()
        cell.setupTextField()
    }
    
    // Function to handle collectionView header
    func collectionViewHeader(cell: CollectionViewCell, indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cellLabel = Label()
            cellLabel.borderWidth = 1
            cellLabel.borderCornerRadius = 0
            cellLabel.textAlignment = .center
            cellLabel.labelText = tableHeading[indexPath.row]
            cellLabel.backgroundColor = UIColor(hexString: "#F3F4F8")
            cellLabel.borderColor = UIColor(hexString: "#E6E7EA") ?? .lightGray
            cellLabel.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
            cellLabel.font = UIFont.boldSystemFont(ofSize: 10)
            cell.contentView.addSubview(cellLabel)
        default:
            break
        }
    }
}
