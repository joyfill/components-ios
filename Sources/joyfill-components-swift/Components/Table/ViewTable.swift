import Foundation
import UIKit

// Global variables
public var selectedIndexPath: Int?
public var tableHeading = [String]()
public var tableDisplayMode = String()
public var cellSelectedIndexPath: IndexPath?
public var selectedTextFieldIndexPath = IndexPath()

// Empty values to append or insert when insertRow and insertBelow is tapped
var emptyValueElement = ValueElement(
    id: "",
    url: nil,
    fileName: nil,
    filePath: nil,
    deleted: false,
    title: nil,
    description: nil,
    points: nil,
    cells: [:]
)

protocol tableUpdate {
    func tableCountNumberUpdate(no: Int, tableIndexNo: Int)
}

protocol SaveTableFieldValue {
    func handleDeleteRow(rowId: String, rowIndex: Int, isEditingEnd: Bool, index: Int)
    func handleMoveRowUp(rowId: String, rowIndex: Int, isEditingEnd: Bool, index: Int)
    func handleMoveRowDown(rowId: String, rowIndex: Int, isEditigEnd: Bool, index: Int)
    func handleDuplicateRow(row: [String:Any], rowIndex: Int, isEditingEnd: Bool, index: Int)
    func handleAddBelowRow(row: [String:Any], rowIndex: Int, isEditingEnd: Bool, index: Int)
    func handleCreateRow(row: [String:Any], rowIndex: Int, isEditingEnd: Bool, index: Int)
    func handleTextCellChangeValue(row: [String:Any], rowId: String, isEditingEnd: Bool, index: Int)
    func handleTableOnFocus(rowId: String, columnId: String, columnIdentifier: String, index: Int)
    func handleTableOnBlur(rowId: String, columnId: String, columnIdentifier: String, index: Int)
}

public class ViewTable: UIViewController, TextViewCellDelegate, DropDownSelectText {
    
    public var mainView = UIView()
    public var moreButton = Button()
    public var moveUpButton = Label()
    public var deleteButton = Label()
    public var addRowButton = Button()
    public var dropdownView = UIView()
    public var closeButton = UIButton()
    public var moveDownButton = Label()
    public var titleBackgroundView = UIView()
    public var duplicateButton = Label()
    public var titleLabel = Label()
    public var insertBelowButton = Label()
    public var collectionView: UICollectionView!
    public var navigationUpMoveButton = Button()
    public var navigationDownMoveButton = Button()
    public var navigationLeftMoveButton = Button()
    public var navigationRightMoveButton = Button()
    
    var data = [String]()
    var tableIndexNo = Int()
    var cellWidth = Double()
    var indexPathRow = Int()
    var numberOfRows = Int()
    var indexPathItem = Int()
    var deleage: tableUpdate?
    var numberOfColumns = Int()
    var indexPathSection = Int()
    var numberingData = [String]()
    var dropDownSelectedValue = String()
    let topAndBottomSubviewborderWidth: CGFloat = 1.0
    let layout = TwoWayScrollingCollectionViewLayout()
    let topAndBottomSubviewborderColor: UIColor = UIColor(hexString: "#1F6BFF") ?? .blue
    var index = Int()
    var saveDelegate: SaveTableFieldValue? = nil
    var fieldDelegate: SaveTextFieldValue? = nil
    var dropDownId = String()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboardOnTapAnyView()
        moreButton.isHidden = true
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .clear
        layout.stickyRowsCount = 1
        setupUI()
    }
    
    func updateFieldBorder(borderColor: UIColor, borderWidth: CGFloat) {
        print("protocol called")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = .light
        }
        setupUI()
        view.endEditing(true)
        updateRowNumber()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        view.endEditing(false)
        selectedIndexPath = nil
    }
    
    public func updateTitle(text: String) {
        titleLabel.labelText = text
    }
    
    // Keyboard appear function
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let buttonWidth = 50.0
        let buttonSpacing: CGFloat = 6.0
        let buttonHeight: CGFloat = 40.0
        let viewHeight = mainView.frame.height
        let buttonY = keyboardFrame.origin.y - buttonHeight - buttonSpacing
        let constant = viewHeight - buttonY + buttonHeight + 10
        
        view.addSubview(navigationUpMoveButton)
        view.addSubview(navigationLeftMoveButton)
        view.addSubview(navigationDownMoveButton)
        view.addSubview(navigationRightMoveButton)
        
        [navigationUpMoveButton, navigationLeftMoveButton, navigationDownMoveButton, navigationRightMoveButton].forEach { Button in
            Button.isHidden = true
            Button.translatesAutoresizingMaskIntoConstraints = false
            Button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            Button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
        
        NSLayoutConstraint.activate([
            navigationRightMoveButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -6),
            navigationRightMoveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -constant),
            
            navigationDownMoveButton.trailingAnchor.constraint(equalTo: navigationRightMoveButton.leadingAnchor, constant: -6),
            navigationDownMoveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -constant),
            
            navigationUpMoveButton.trailingAnchor.constraint(equalTo: navigationDownMoveButton.leadingAnchor, constant: -6),
            navigationUpMoveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -constant),
            
            navigationLeftMoveButton.trailingAnchor.constraint(equalTo: navigationUpMoveButton.leadingAnchor, constant: -6),
            navigationLeftMoveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -constant)
        ])
    }
    
    // Keyboard dismiss function
    @objc func keyboardWillHide(_ notification: Notification) {
        [navigationUpMoveButton, navigationLeftMoveButton, navigationDownMoveButton, navigationRightMoveButton].forEach { Button in
            Button.isHidden = true
        }
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextView.layer.borderWidth = 0
        }
    }
    
    // Deinitializer to prevent memory leakage
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        // SubViews
        view.addSubview(mainView)
        view.addSubview(collectionView)
        view.addSubview(moreButton)
        view.addSubview(dropdownView)
        view.addSubview(addRowButton)
        view.addSubview(closeButton)
        mainView.addSubview(titleBackgroundView)
        dropdownView.addSubview(deleteButton)
        dropdownView.addSubview(moveUpButton)
        dropdownView.addSubview(moveDownButton)
        dropdownView.addSubview(duplicateButton)
        dropdownView.addSubview(insertBelowButton)
        titleBackgroundView.addSubview(titleLabel)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addRowButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        moveUpButton.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        moveDownButton.translatesAutoresizingMaskIntoConstraints = false
        titleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        duplicateButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        insertBelowButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to imageView
        NSLayoutConstraint.activate([
            // Top View
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            // PageView Constraint
            titleBackgroundView.topAnchor.constraint(equalTo: mainView.topAnchor),
            titleBackgroundView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            titleBackgroundView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            titleBackgroundView.heightAnchor.constraint(equalToConstant: 39),
            
            // PageLabel Constraint
            titleLabel.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor, constant: 0),
            titleLabel.widthAnchor.constraint(equalToConstant: 135),
            titleLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // TableView Constraint
            collectionView.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 170),
            collectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20),
            
            // DeleteRowButton Constraint
            addRowButton.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 0),
            addRowButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -6),
            addRowButton.widthAnchor.constraint(equalToConstant: 94),
            addRowButton.heightAnchor.constraint(equalToConstant: 27),
            
            // Close Button
            closeButton.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 0),
            closeButton.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor, constant: -6),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 27),
            
            // MoreButton Constraint
            moreButton.topAnchor.constraint(equalTo: titleBackgroundView.topAnchor, constant: 0),
            moreButton.trailingAnchor.constraint(equalTo: addRowButton.leadingAnchor, constant: -6),
            moreButton.widthAnchor.constraint(equalToConstant: 78),
            moreButton.heightAnchor.constraint(equalToConstant: 27),
            
            // DropdownView Constraint
            dropdownView.topAnchor.constraint(equalTo: moreButton.bottomAnchor, constant: 8),
            dropdownView.trailingAnchor.constraint(equalTo: moreButton.trailingAnchor, constant: 0),
            dropdownView.widthAnchor.constraint(equalToConstant: 230),
            dropdownView.heightAnchor.constraint(equalToConstant: 211),
            
            // InsertBelowButton Constraint
            insertBelowButton.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 0),
            insertBelowButton.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 15),
            insertBelowButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            insertBelowButton.heightAnchor.constraint(equalToConstant: 46),
            
            // DuplicateButton Constraint
            duplicateButton.topAnchor.constraint(equalTo: insertBelowButton.bottomAnchor, constant: 0),
            duplicateButton.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 15),
            duplicateButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            duplicateButton.heightAnchor.constraint(equalToConstant: 40),
            
            // MoveUpButton Constraint
            moveUpButton.topAnchor.constraint(equalTo: duplicateButton.bottomAnchor, constant: 0),
            moveUpButton.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 15),
            moveUpButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            moveUpButton.heightAnchor.constraint(equalToConstant: 40),
            
            // MoveDownButton Constraint
            moveDownButton.topAnchor.constraint(equalTo: moveUpButton.bottomAnchor, constant: 0),
            moveDownButton.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 15),
            moveDownButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            moveDownButton.heightAnchor.constraint(equalToConstant: 40),
            
            // DeleteButton Constraint
            deleteButton.topAnchor.constraint(equalTo: moveDownButton.bottomAnchor, constant: 0),
            deleteButton.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 15),
            deleteButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 0),
            deleteButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        // Sets cornerRadius and shadow to view.
        dropdownView.isHidden = true
        dropdownView.backgroundColor = .white
        dropdownView.layer.cornerRadius = 15
        dropdownView.layer.shadowRadius = 3.0
        dropdownView.layer.shadowOpacity = 0.3
        dropdownView.layer.shadowColor = UIColor.black.cgColor
        dropdownView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // TableView Properties
        numberOfColumns = tableColumnType[tableIndexNo].count
        tableHeading = tableColumnTitle[tableIndexNo]
        collectionView.layer.borderWidth = 1
        collectionView.layer.cornerRadius = 12
        collectionView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        [addRowButton, moreButton].forEach { button in
            button.borderWidth = 1
            button.cornerRadius = 6
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.borderColor = UIColor(hexString: "#E2E3E7") ?? .lightGray
        }
        
        // Set insertRowButton
        addRowButton.title = "Add Row +"
        addRowButton.addTarget(self, action: #selector(insertRowTapped), for: .touchUpInside)
        
        // Set moreButton
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let moreButtonAttributedString = NSMutableAttributedString(string: "More")
        let moreButtonImageAttachment = NSTextAttachment()
        moreButtonImageAttachment.image = UIImage(named: "arrowDown")
        let moreButtonImageAttributedString = NSAttributedString(attachment: moreButtonImageAttachment)
        moreButtonAttributedString.append(NSAttributedString(string: "  "))
        moreButtonAttributedString.append(moreButtonImageAttributedString)
        moreButton.setAttributedTitle(moreButtonAttributedString, for: .normal)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        
        // Set dropdownButtons
        [insertBelowButton, duplicateButton, moveUpButton, moveDownButton, deleteButton].forEach { label in
            label.textAlignment = .left
            label.isUserInteractionEnabled = true
            label.font = UIFont.boldSystemFont(ofSize: 14)
            
            let border = CALayer()
            border.backgroundColor = UIColor(hexString: "#E9EAEF")?.cgColor
            border.frame = CGRect(x: -15, y: border.frame.height - 1, width: 230, height: 1)
            label.layer.addSublayer(border)
        }
        
        insertBelowButton.labelText = "Insert Below"
        let insertTapGesture = UITapGestureRecognizer(target: self, action: #selector(insertBelowTapped))
        insertBelowButton.addGestureRecognizer(insertTapGesture)
        
        duplicateButton.labelText = "Duplicate"
        let duplicateTapGesture = UITapGestureRecognizer(target: self, action: #selector(duplicateTapped))
        duplicateButton.addGestureRecognizer(duplicateTapGesture)
        
        moveUpButton.labelText = "Move Up"
        let moveUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveUpTapped))
        moveUpButton.addGestureRecognizer(moveUpTapGesture)
        
        moveDownButton.labelText = "Move Down"
        let moveDownTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveDownTapped))
        moveDownButton.addGestureRecognizer(moveDownTapGesture)
        
        deleteButton.labelText = "Delete"
        deleteButton.textColor = UIColor(hexString: "#FB4534")
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        deleteButton.addGestureRecognizer(deleteTapGesture)
        
        // Set NavigationButtons
        [navigationLeftMoveButton, navigationUpMoveButton, navigationDownMoveButton, navigationRightMoveButton].forEach { button in
            button.isHidden = true
            button.borderWidth = 1
            button.cornerRadius = 6.0
            button.tintColor = .black
            button.backgroundColor = .white
            button.layer.shadowRadius = 3.0
            button.layer.shadowOpacity = 0.3
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            button.borderColor = UIColor(hexString: "#E2E3E7") ?? .lightGray
        }
        
        if tableDisplayMode == "readonly" {
            addRowButton.isHidden = true
        } else {
            addRowButton.isHidden = false
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        navigationUpMoveButton.setImage(UIImage(named: "upLineArrow"), for: .normal)
        navigationLeftMoveButton.setImage(UIImage(named: "leftLineArrow"), for: .normal)
        navigationDownMoveButton.setImage(UIImage(named: "downLineArrow"), for: .normal)
        navigationRightMoveButton.setImage(UIImage(named: "rightLineArrow"), for: .normal)
        
        navigationUpMoveButton.addTarget(self, action: #selector(navigationUpMoveTapped), for: .touchUpInside)
        navigationDownMoveButton.addTarget(self, action: #selector(navigationDownMoveTapped), for: .touchUpInside)
        navigationLeftMoveButton.addTarget(self, action: #selector(navigationLeftMoveTapped), for: .touchUpInside)
        navigationRightMoveButton.addTarget(self, action: #selector(navigationRightMoveTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mainViewTap))
        mainView.addGestureRecognizer(tap)
        
        // Sets table and action to pageButton
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "xmark.circle", withConfiguration: boldConfig)
            closeButton.setImage(boldSearch, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    // Hide dropdown menu on view click
    @objc func mainViewTap() {
        dropdownView.isHidden = true
    }
    
    // Action for more button to open dropdown
    @objc func moreTapped() {
        if dropdownView.isHidden {
            dropdownView.isHidden = false
        } else {
            dropdownView.isHidden = true
        }
    }
    
    // Action for close button
    @objc func closeTapped() {
        view.endEditing(false)
        tableColumnTitle[tableIndexNo].removeFirst(2)
        tableColumnType[tableIndexNo].removeFirst(2)
        viewType = "field"
        
        fieldDelegate?.handleBlur(index: index)
        if tableRowOrder[tableIndexNo].count == 1 {
            tableFieldValue[tableIndexNo].append(emptyValueElement)
            tableFieldValue[tableIndexNo].append(emptyValueElement)
        } else if tableRowOrder[tableIndexNo].count == 2 {
            tableFieldValue[tableIndexNo].append(emptyValueElement)
        } else {}
        emptyValueElement.cells?.removeAll()
        self.deleage?.tableCountNumberUpdate(no: numberOfRows, tableIndexNo: tableIndexNo)
        
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                viewController.dismiss(animated: true)
                break
            }
        }
    }
    
    // Function to update numberOfRows when insert or delete tapped
    func updateRowNumber() {
        numberingData.removeAll()
        for i in 0...numberOfRows {
            numberingData.append("\(i)")
        }
    }
    
    // Function to reload particular section of collectionView
    func reloadCollectionRowNumber() {
        for i in 0...collectionView.numberOfSections - 1 {
            let indexPath = IndexPath(row: 1, section: i)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    // Function to update topBorder and bottomBorder
    func updateCellSubviewBorder(at intValue: Int) {
        moreButton.isHidden = true
        dropdownView.isHidden = true
        reloadCollectionRowNumber()
        let numberOfItemsInSection = collectionView.numberOfItems(inSection: cellSelectedIndexPath?.section ?? 0)
        for item in 0..<numberOfItemsInSection {
            let indexPath = IndexPath(item: item, section: (cellSelectedIndexPath?.section ?? 0) + intValue)
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.topBorder.backgroundColor = UIColor(hexString: "#E6E7EA")
                cell.bottomBorder.backgroundColor = UIColor(hexString: "#E6E7EA")
            }
        }
    }
    
    // Function to update selection when any action from dropdown list is performed
    func updateSelectionButton() {
        if let cell = collectionView.cellForItem(at: cellSelectedIndexPath ?? IndexPath(row: 0, section: 0)) as? CollectionViewCell {
            cell.selectionButton.setImage(UIImage(named: "unSelectButton"), for: .normal)
        }
    }
    
    // Function to show default value when row is added or inserted
    func insertColumnDefaultValue(indexpath: IndexPath) {
        emptyValueElement.cells?.removeAll()
        var cellValue = [String:String]()
        for i in 0..<tableColumnOrderId[tableIndexNo].count {
            if let _ = optionsData[tableIndexNo].first(where: { $0.id == tableColumnOrderId[tableIndexNo][indexpath.row-2]}) {
                cellValue[optionsData[tableIndexNo][i].id ?? ""] = optionsData[tableIndexNo][i].value
            }
        }
        emptyValueElement = ValueElement(
            id: "",
            url: nil,
            fileName: nil,
            filePath: nil,
            deleted: false,
            title: nil,
            description: nil,
            points: nil,
            cells: cellValue
        )
    }
    
    // MARK: AddRow Tapped
    @objc func insertRowTapped() {
        dropdownView.isHidden = true
        numberOfRows += 1
        updateRowNumber()
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
        var cellValue = [String:String]()
        for i in 0..<tableColumnOrderId[tableIndexNo].count {
            if let _ = optionsData[tableIndexNo].first(where: { $0.id == tableColumnOrderId[tableIndexNo][lastIndexPath.row-2]}) {
                cellValue[optionsData[tableIndexNo][i].id ?? ""] = optionsData[tableIndexNo][i].value
            }
        }
        if var valueElement = tableFieldValue[tableIndexNo][lastIndexPath.section - 1] as? ValueElement {
            let objectId = generateObjectId()
            tableRowOrder[tableIndexNo].append(objectId)
            // Create a new ValueElement with the updated id value.
            valueElement = ValueElement(
                id: objectId,
                url: valueElement.url,
                fileName: valueElement.fileName,
                filePath: valueElement.filePath,
                deleted: valueElement.deleted,
                title: valueElement.title,
                description: valueElement.description,
                points: valueElement.points,
                cells: cellValue
            )
            tableFieldValue[tableIndexNo].append(valueElement)
            tableCellsData[tableIndexNo].append(data)
            collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
            collectionView.insertSections(IndexSet(integer: lastSection))
            
            joyDocFieldData[index].rowOrder?.append(tableFieldValue[tableIndexNo][lastIndexPath.section].id ?? "")
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.append(tableFieldValue[tableIndexNo][lastIndexPath.section].id ?? "")
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            
            
            let dict = tableFieldValue[tableIndexNo][lastIndexPath.section].cells
            var cells : [String:Any] = [:]
            for (key, value) in dict ?? [:] {
                cells[key] = value
            }
            let row = ["_id":  tableFieldValue[tableIndexNo][lastIndexPath.section].id ?? "",
                       "deleted": false,
                       "cells": cells
            ] as [String: Any]
            saveDelegate?.handleCreateRow(row: row, rowIndex: lastIndexPath.section, isEditingEnd: true, index: index)
            reloadCollectionRowNumber()
            let itemCount = collectionView.numberOfItems(inSection: lastSection)
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: lastSection + 1)
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    // MARK: InsertBelow Tapped
    @objc func insertBelowTapped() {
        numberOfRows += 1
        updateRowNumber()
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
        insertColumnDefaultValue(indexpath: lastIndexPath)
        
        if var valueElement = tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1] as? ValueElement {
            let objectId = generateObjectId()
            tableRowOrder[tableIndexNo].insert(objectId, at: (cellSelectedIndexPath?.section ?? 0))
            // Create a new ValueElement with the updated id value.
            valueElement = ValueElement(
                id: objectId,
                url: valueElement.url,
                fileName: valueElement.fileName,
                filePath: valueElement.filePath,
                deleted: valueElement.deleted,
                title: valueElement.title,
                description: valueElement.description,
                points: valueElement.points,
                cells: [:]
            )
            tableFieldValue[tableIndexNo].insert(valueElement, at: cellSelectedIndexPath?.section ?? 0)
            tableCellsData[tableIndexNo].insert(data, at: cellSelectedIndexPath?.section ?? 0)
            collectionView.insertSections(IndexSet(integer: cellSelectedIndexPath?.section ?? 0))
            
            joyDocFieldData[index].rowOrder?.insert(tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0)].id ?? "", at: cellSelectedIndexPath?.section ?? 0)
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.insert(tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0)].id ?? "", at: cellSelectedIndexPath?.section ?? 0)
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            
            let dict = tableFieldValue[tableIndexNo][lastSection - 2].cells
            var cells : [String:Any] = [:]
            for (key, _) in dict ?? [:] {
                cells[key] = ""
            }
            let row = ["_id":  tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0)].id ?? "",
                       "deleted": false,
                       "cells": cells
            ] as [String: Any]
            saveDelegate?.handleAddBelowRow(row: row, rowIndex: (cellSelectedIndexPath?.section ?? 0), isEditingEnd: true, index: index)
            selectedIndexPath = nil
            updateCellSubviewBorder(at: 0)
            updateSelectionButton()
            let itemCount = collectionView.numberOfItems(inSection: (cellSelectedIndexPath?.section ?? 0) + 1)
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: (cellSelectedIndexPath?.section ?? 0) + 1)
                collectionView.reloadItems(at: [indexPath])
                collectionView.reloadItems(at: [IndexPath(item: itemIndex, section: cellSelectedIndexPath?.section ?? 0)])
            }
        }
    }
    
    // MARK: Duplicate Tapped
    @objc func duplicateTapped() {
        numberOfRows += 1
        updateRowNumber()
        if var valueElement = tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1] as? ValueElement {
            let objectId = generateObjectId()
            tableRowOrder[tableIndexNo].insert(objectId, at: (cellSelectedIndexPath?.section ?? 0))
            // Create a new ValueElement with the updated id value.
            valueElement = ValueElement(
                id: objectId,
                url: valueElement.url,
                fileName: valueElement.fileName,
                filePath: valueElement.filePath,
                deleted: valueElement.deleted,
                title: valueElement.title,
                description: valueElement.description,
                points: valueElement.points,
                cells: valueElement.cells
            )
            let cellItemToDuplicate = tableCellsData[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1]
            tableFieldValue[tableIndexNo].insert(valueElement, at: cellSelectedIndexPath?.section ?? 0)
            tableCellsData[tableIndexNo].insert(cellItemToDuplicate, at: cellSelectedIndexPath?.section ?? 0)
            collectionView.insertSections(IndexSet(integer: cellSelectedIndexPath?.section ?? 0))
            
            joyDocFieldData[index].rowOrder?.insert(tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0)].id ?? "", at: cellSelectedIndexPath?.section ?? 0)
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.insert(tableFieldValue[tableIndexNo][(cellSelectedIndexPath?.section ?? 0)].id ?? "", at: cellSelectedIndexPath?.section ?? 0)
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            
            let dict = tableFieldValue[tableIndexNo][cellSelectedIndexPath?.section ?? 0].cells
            var cells: [String: Any] = [:]
            for (key, value) in dict ?? [:] {
                cells[key] = value
            }
            let row = ["_id":  tableFieldValue[tableIndexNo][cellSelectedIndexPath?.section ?? 0].id ?? "",
                       "deleted" : false,
                       "cells" : cells
            ] as [String: Any]
            docChangeLogs = ["row": row, "targetRowIndex": cellSelectedIndexPath?.section ?? 0]
            saveDelegate?.handleDuplicateRow(row: docChangeLogs, rowIndex: cellSelectedIndexPath?.section ?? 0, isEditingEnd: true, index: index)
            selectedIndexPath = nil
            updateCellSubviewBorder(at: 0)
            updateCellSubviewBorder(at: 1)
            updateSelectionButton()
            let itemCount = collectionView.numberOfItems(inSection: cellSelectedIndexPath?.section ?? 0)
            for itemIndex in 0..<itemCount {
                let indexPath = IndexPath(item: itemIndex, section: cellSelectedIndexPath?.section ?? 0)
                collectionView.reloadItems(at: [indexPath])
            }
            let newIndexPath = IndexPath(row: cellSelectedIndexPath?.row ?? 0, section: (cellSelectedIndexPath?.section ?? 0) + 1)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
                cell.selectionButton.setImage(UIImage(named: "unSelectButton"), for: .normal)
            }
        }
    }
    
    // MARK: MoveUp Tapped
    @objc func moveUpTapped() {
        updateRowNumber()
        if cellSelectedIndexPath?.section == 1 {
            updateSelectionButton()
            selectedIndexPath = nil
            updateCellSubviewBorder(at: 0)
        } else {
            updateSelectionButton()
            collectionView.moveSection(cellSelectedIndexPath?.section ?? 0, toSection: (cellSelectedIndexPath?.section ?? 0) - 1)
            tableFieldValue[tableIndexNo].swapAt((cellSelectedIndexPath?.section ?? 0) - 1, (cellSelectedIndexPath?.section ?? 0) - 2)
            tableCellsData[tableIndexNo].swapAt((cellSelectedIndexPath?.section ?? 0) - 1, (cellSelectedIndexPath?.section ?? 0) - 2)
            
            joyDocFieldData[index].rowOrder?.swapAt((cellSelectedIndexPath?.section ?? 0) - 1, (cellSelectedIndexPath?.section ?? 0) - 2)
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.swapAt((cellSelectedIndexPath?.section ?? 0) - 1, (cellSelectedIndexPath?.section ?? 0) - 2)
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            
            let rowMoveUpId = tableRowOrder[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1]
            saveDelegate?.handleMoveRowUp(rowId: rowMoveUpId, rowIndex: (cellSelectedIndexPath?.section ?? 0) - 2, isEditingEnd: true, index: index)
            selectedIndexPath = nil
            updateCellSubviewBorder(at: -1)
        }
    }
    
    // MARK: MoveDown Tapped
    @objc func moveDownTapped() {
        updateRowNumber()
        if cellSelectedIndexPath?.section == 0 || cellSelectedIndexPath?.section == numberOfRows {
            updateSelectionButton()
            selectedIndexPath = nil
            updateCellSubviewBorder(at: 0)
        } else {
            updateSelectionButton()
            collectionView.moveSection(cellSelectedIndexPath?.section ?? 0, toSection: (cellSelectedIndexPath?.section ?? 0) + 1)
            tableFieldValue[tableIndexNo].swapAt((cellSelectedIndexPath?.section ?? 0) - 1, cellSelectedIndexPath?.section ?? 0)
            tableCellsData[tableIndexNo].swapAt((cellSelectedIndexPath?.section ?? 0) - 1, cellSelectedIndexPath?.section ?? 0)
            
            joyDocFieldData[index].rowOrder?.swapAt((cellSelectedIndexPath?.section ?? 0) - 1, cellSelectedIndexPath?.section ?? 0)
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.swapAt((cellSelectedIndexPath?.section ?? 0) - 1, cellSelectedIndexPath?.section ?? 0)
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            
            let rowMoveDownId = tableRowOrder[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1]
            saveDelegate?.handleMoveRowDown(rowId: rowMoveDownId, rowIndex: (cellSelectedIndexPath?.section ?? 0), isEditigEnd: true, index: index)
            selectedIndexPath = nil
            updateCellSubviewBorder(at: 1)
        }
    }
    
    // MARK: DeleteRow Tapped
    @objc func deleteTapped() {
        moreButton.isHidden = true
        dropdownView.isHidden = true
        if numberOfRows != 1 {
            numberOfRows -= 1
            updateRowNumber()
            tableFieldValue[tableIndexNo].remove(at: (cellSelectedIndexPath?.section ?? 0) - 1)
            tableCellsData[tableIndexNo].remove(at: (cellSelectedIndexPath?.section ?? 0) - 1)
            collectionView.deleteSections(IndexSet(integer: cellSelectedIndexPath?.section ?? 0))
            joyDocFieldData[index].rowOrder?.remove(at: (cellSelectedIndexPath?.section ?? 0) - 1)
            let value = joyDocFieldData[index].value
            switch value {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
            
            if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
                joyDocStruct?.fields?[index].rowOrder?.remove(at: (cellSelectedIndexPath?.section ?? 0) - 1)
                let modelValue = joyDocStruct?.fields?[index].value
                switch modelValue {
                case .string: break
                case .integer: break
                case .valueElementArray:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .array(_): break
                case .none:
                    joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
                case .some(.null): break
                }
            }
            let deleteRowId = tableRowOrder[tableIndexNo][(cellSelectedIndexPath?.section ?? 0) - 1]
            tableRowOrder[tableIndexNo].remove(at: (cellSelectedIndexPath?.section ?? 0) - 1)
            saveDelegate?.handleDeleteRow(rowId: deleteRowId, rowIndex: (cellSelectedIndexPath?.section ?? 0) - 1, isEditingEnd: true, index: index)
        }
        selectedIndexPath = nil
        reloadCollectionRowNumber()
        updateSelectionButton()
        let numberOfItemsInSection = collectionView.numberOfItems(inSection: (cellSelectedIndexPath?.section ?? 0) - 1)
        for item in 0..<numberOfItemsInSection {
            let indexPath = IndexPath(item: item, section: (cellSelectedIndexPath?.section ?? 0))
            if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
                cell.topBorder.backgroundColor = UIColor(hexString: "#E6E7EA")
                cell.bottomBorder.backgroundColor = UIColor(hexString: "#E6E7EA")
            }
        }
    }
    
    // Function to update textField and border
    func setTextFieldBorder(cell: CollectionViewCell, newIndexPath: IndexPath) {
        cell.cellTextView.layer.borderWidth = 1.0
        cell.cellTextView.layer.cornerRadius = 1.0
        cell.cellTextView.layer.borderColor = UIColor(hexString: "#1F6BFF")?.cgColor
        cell.cellTextView.becomeFirstResponder()
        selectedTextFieldIndexPath = newIndexPath
    }
    
    // MARK: NavigationLeftMoveButton Tapped
    @objc func navigationLeftMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextView.layer.borderWidth = 0
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row - 1, section: selectedTextFieldIndexPath.section)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            setTextFieldBorder(cell: cell, newIndexPath: newIndexPath)
        }
    }
    
    // MARK: NavigationUpMoveButton Tapped
    @objc func navigationUpMoveTapped() {
        if selectedTextFieldIndexPath.section != 1 {
            if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
                cell.cellTextView.layer.borderWidth = 0
            }
            let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row, section: selectedTextFieldIndexPath.section - 1)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
                setTextFieldBorder(cell: cell, newIndexPath: newIndexPath)
            }
        }
    }
    
    // MARK: NavigationDownMoveButton Tapped
    @objc func navigationDownMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextView.layer.borderWidth = 0
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row, section: selectedTextFieldIndexPath.section + 1)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            setTextFieldBorder(cell: cell, newIndexPath: newIndexPath)
        }
    }
    
    // MARK: NavigationRightMoveButton Tapped
    @objc func navigationRightMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextView.layer.borderWidth = 0
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row + 1, section: selectedTextFieldIndexPath.section)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            setTextFieldBorder(cell: cell, newIndexPath: newIndexPath)
        }
    }
}

// MARK: Setup collectionView
extension ViewTable: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    // MARK: CollectionView delegate method for number of sections
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfRows + 1
    }
    
    // MARK: CollectionView delegate method for number of items in section
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns
    }
    
    // MARK: CollectionView delegate method for cell for item at
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.textViewDelegate = self
        cell.contentView.backgroundColor = .clear
        
        tableViewDispalyMode(at: cell)
        viewTablePopUpModal(cell: cell, indexPath: indexPath)
        tableCollectionViewHeader(cell: cell, indexPath: indexPath)
        
        if indexPath.section == selectedIndexPath {
            cell.selectionButton.setImage(UIImage(named: "selectButton"), for: .normal)
            addTopandBottomBorderToCell(at: cell)
        } else {
            cell.selectionButton.setImage(UIImage(named: "unSelectButton"), for: .normal)
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
    // MARK: CollectionView delegate method for cell selection at indexPath
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tableDisplayMode != "readonly" {
            if indexPath.item == 0 {
                changeSelectionButtonState(indexPath: indexPath)
            }
            if indexPath.section != 0 {
                dropdownCellValue(indexPath: indexPath)
            }
        }
    }
    
    func changeSelectionButtonState(indexPath: IndexPath) {
        if indexPath.section == selectedIndexPath {
            let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
            cell?.selectionButton.setImage(UIImage(named: "unSelectButton"), for: .normal)
            selectedIndexPath = nil
            moreButton.isHidden = true
            collectionView.reloadData()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
            cell?.selectionButton.setImage(UIImage(named: "selectButton"), for: .normal)
            selectedIndexPath = indexPath.section
            cellSelectedIndexPath = indexPath
            moreButton.isHidden = false
            collectionView.reloadData()
        }
    }
    
    // Function to fetch and set dropdown value from JoyDoc
    func dropdownCellValue(indexPath: IndexPath) {
        if tableColumnType[tableIndexNo][indexPath.row] == FieldTypes.dropdown {
            var dropdownOptionArray = [String]()
            for k in 0..<(optionsData[tableIndexNo][indexPath.row-2].options?.count ?? 0) {
                dropDownId = optionsData[tableIndexNo][k].id ?? ""
                dropdownOptionArray.append(optionsData[tableIndexNo][indexPath.row-2].options?[k].value ?? "")
            }
            
            let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.hideDoneButtonOnSingleSelect = "singleSelect"
            vc.index = tableIndexNo
            vc.delegate = self
            vc.dropdownOptionArray = dropdownOptionArray
            
            let rowId = tableRowOrder[tableIndexNo][indexPath.section-1]
            let columnId = optionsData[tableIndexNo][indexPath.row-2].id ?? ""
            let columnIdentifier = optionsData[tableIndexNo][indexPath.row-2].identifier ?? ""
            saveDelegate?.handleTableOnFocus(rowId: rowId, columnId: columnId, columnIdentifier: columnIdentifier, index: index)
            
            // To find and highlight the selected option in the dropdown
            for i in 0..<(optionsData[tableIndexNo][indexPath.row-2].options?.count ?? 0) {
                let cellData = tableFieldValue[tableIndexNo][indexPath.section-1].cells ?? [:]
                if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[tableIndexNo][indexPath.row-2]}) {
                    let tableColumnsData = optionsData[tableIndexNo][indexPath.row-2].options
                    if tableColumnsData?[i].id == matchData.value {
                        selectedDropdownOptionIndexPath[tableIndexNo] = i
                    }
                } else {
                    selectedDropdownOptionIndexPath[tableIndexNo] = nil
                }
            }
            
            self.present(vc, animated: false)
            indexPathRow = indexPath.row
            indexPathItem = indexPath.item
            indexPathSection = indexPath.section
        }
    }
    
    // MARK: CollectionView delegate method to adjust cell height and width
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        setCellWidth()
        let maxTextHeight = calculateMaxTextHeight(forTextArray: tableColumnTitle[tableIndexNo], font: UIFont.boldSystemFont(ofSize: 12), width: CGFloat(cellWidth))
        let cellHeight = maxTextHeight + 20
        
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                return CGSize(width: 50, height: cellHeight)
            } else if indexPath.item == 1 {
                return CGSize(width: 50, height: cellHeight)
            } else {
                return CGSize(width: cellWidth, height: cellHeight)
            }
        }
        
        var textHeight = calculateMaxTextHeight(forTextArray: tableCellsData[tableIndexNo][indexPath.section-1], font: UIFont.boldSystemFont(ofSize: 17), width: CGFloat(cellWidth))
        
        if textHeight < 20 {
            textHeight += 40
        } else if textHeight < 37 {
            textHeight += 20
        } else {
            textHeight += 5
        }
        
        if indexPath.item == 0  {
            return CGSize(width: 50, height: textHeight)
        } else if indexPath.item == 1 {
            return CGSize(width: 50, height: textHeight)
        } else {
            return CGSize(width: cellWidth, height: textHeight)
        }
    }
    
    func setCellWidth() {
        if tableColumnOrderId[tableIndexNo].count == 1 {
            cellWidth = self.collectionView.frame.width - 100
        } else if tableColumnOrderId[tableIndexNo].count == 2 {
            let collectionViewWidth = self.collectionView.frame.width
            cellWidth = (collectionViewWidth - 100) / 2
        } else {
            cellWidth = 133.0
        }
    }
    
    // MARK: CollectionView delegate method to display cells on collectionView appear
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == selectedIndexPath {
            addTopandBottomBorderToCell(at: cell as! CollectionViewCell)
        } else {
            cell.contentView.layer.borderWidth = 0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: TextView delegate method for textView selection
    func textViewCellDidSelect(_ cell: UICollectionViewCell) {
        let indexPath = collectionView.indexPath(for: cell)
        if indexPath?.section != 0 {
            if let previousCell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
                previousCell.cellTextView.layer.borderWidth = 0
            }
            if let cell = collectionView.cellForItem(at: indexPath ?? IndexPath(row: 0, section: 0)) as? CollectionViewCell {
                cell.cellTextView.layer.borderWidth = 1.0
                cell.cellTextView.layer.cornerRadius = 1.0
                cell.cellTextView.layer.borderColor = UIColor(hexString: "#1F6BFF")?.cgColor
                cell.cellTextView.selectedRange = NSRange(location: cell.cellTextView.text.count, length: 0)
                cell.indexRow = indexPath?.row ?? 0
                cell.indexSection = indexPath?.section ?? 0
                cell.tableIndexNo = tableIndexNo
                selectedTextFieldIndexPath = indexPath ?? IndexPath(row: 0, section: 0)
            }
            
            let rowId = tableRowOrder[tableIndexNo][(indexPath?.section ?? 0)-1]
            let columnId = optionsData[tableIndexNo][(indexPath?.row ?? 0)-2].id ?? ""
            let columnIdentifier = optionsData[tableIndexNo][(indexPath?.row ?? 0)-2].identifier ?? ""
            saveDelegate?.handleTableOnFocus(rowId: rowId, columnId: columnId, columnIdentifier: columnIdentifier, index: index)
        }
    }
    
    // Function to add top & bottom border only to collectionView cell
    func addTopandBottomBorderToCell(at cell: CollectionViewCell) {
        cell.topBorder.backgroundColor = topAndBottomSubviewborderColor
        cell.bottomBorder.backgroundColor = topAndBottomSubviewborderColor
        cell.topBorder = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: topAndBottomSubviewborderWidth))
        cell.bottomBorder = UIView(frame: CGRect(x: 0, y: cell.bounds.height - topAndBottomSubviewborderWidth, width: cell.bounds.width, height: topAndBottomSubviewborderWidth))
        
        cell.contentView.addSubview(cell.topBorder)
        cell.contentView.addSubview(cell.bottomBorder)
    }
    
    // Function to handle table popup modal
    func viewTablePopUpModal(cell: CollectionViewCell, indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.item == 0 {
            cell.selectionButton.isUserInteractionEnabled = false
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setSelectionButtonInTableColumn()
        } else if indexPath.row == 1 && indexPath.item == 1 {
            cell.numberLabel.labelText = numberingData[indexPath.section]
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setNumberLabelInTableColumn()
        } else {
            if tableColumnType[tableIndexNo][indexPath.row] == FieldTypes.dropdown {
                if indexPath.section > 0 {
                    setCellDropdownValue(cell: cell, indexPath: indexPath)
                }
                if indexPath.section == indexPathSection && indexPath.item == indexPathItem  {
                    cell.dropdownTextField.text = dropDownSelectedValue
                }
                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                cell.setupSeparator()
                cell.setDropdownInTableColumn()
            } else {
                if indexPath.section > 0 {
                    setCellTextValue(cell: cell, indexPath: indexPath)
                }
                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                cell.setupSeparator()
                cell.setTextViewInTableColumn()
            }
        }
    }
    
    // Function to set dropdown value after matching column id
    func setCellDropdownValue(cell: CollectionViewCell, indexPath: IndexPath) {
        let cellData = tableFieldValue[tableIndexNo][indexPath.section-1].cells ?? [:]
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[tableIndexNo][indexPath.row-2]}) {
            let tableColumnsData = optionsData[tableIndexNo][indexPath.row-2].options
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
        if let matchData = cellData.first(where: {$0.key == tableColumnOrderId[tableIndexNo][indexPath.row-2]}) {
            cell.cellTextView.text = matchData.value
        } else {
            cell.cellTextView.text = ""
        }
    }
    
    // Function to handle cells according to displayMode
    func tableViewDispalyMode(at cell: CollectionViewCell) {
        switch tableDisplayMode {
        case "readonly":
            cell.cellTextView.isUserInteractionEnabled = false
        default:
            cell.cellTextView.isUserInteractionEnabled = true
        }
    }
    
    // Function to handle collectionView header
    func tableCollectionViewHeader(cell: CollectionViewCell, indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cellLabel = Label()
            cellLabel.borderWidth = 1
            cellLabel.borderCornerRadius = 0
            cellLabel.textAlignment = .center
            cellLabel.numberOfLines = 0
            cellLabel.labelText = tableColumnTitle[tableIndexNo][indexPath.row]
            cellLabel.backgroundColor = UIColor(hexString: "#F3F4F8")
            cellLabel.borderColor = UIColor(hexString: "#E6E7EA") ?? .lightGray
            setTableHeaderHeightAccordingToText(cellLabel: cellLabel, indexPath: indexPath)
            cell.contentView.addSubview(cellLabel)
        default:
            break
        }
    }
    
    // Function to handle popup modal for collectionView header
    func setTableHeaderHeightAccordingToText(cellLabel: Label, indexPath: IndexPath) {
        setCellWidth()
        let maxTextHeight = calculateMaxTextHeight(forTextArray: tableColumnTitle[tableIndexNo], font: UIFont.boldSystemFont(ofSize: 12), width: CGFloat(cellWidth))
        let cellHeight = maxTextHeight + 20
        
        if indexPath.section == 0 && indexPath.item == 0 {
            cellLabel.frame = CGRect(x: 0, y: 0, width: 50, height: cellHeight)
            cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else if indexPath.section == 0 && indexPath.item == 1 {
            cellLabel.frame = CGRect(x: 0, y: 0, width: 50, height: cellHeight)
            cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
        } else {
            cellLabel.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight)
            cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    func setDropdownSelectedValue(text: String) {
        dropDownSelectedValue = text
        let cell = collectionView.cellForItem(at: IndexPath(row: indexPathRow, section: indexPathSection)) as? CollectionViewCell
        cell?.dropdownTextField.text = text
        
        if text != "" {
            var dropDownSelectId = String()
            var cells = [String:String]()
            
            if let option = optionsData[tableIndexNo][indexPathRow-2].options?.first(where: {$0.value == text}) {
                dropDownSelectId = option.id ?? ""
            }
            
            if let fieldTableColumn = tableColumnOrderId[tableIndexNo].first(where: {$0 == optionsData[tableIndexNo][indexPathRow-2].id}) {
                cells[fieldTableColumn] = dropDownSelectId
            }
            
            let rowId = tableRowOrder[tableIndexNo][indexPathSection-1]
            let columnId = optionsData[tableIndexNo][indexPathRow-2].id ?? ""
            let columnIdentifier = optionsData[tableIndexNo][indexPathRow-2].identifier ?? ""
            let dict = tableFieldValue[tableIndexNo][indexPathSection-1].cells
            for (key, value) in dict ?? [:] {
                if key == optionsData[tableIndexNo][indexPathRow-2].id {
                    cells[key] = dropDownSelectId
                } else {
                    cells[key] = value
                }
            }
            if var valueElement = tableFieldValue[tableIndexNo][indexPathSection - 1] as? ValueElement {
                valueElement = ValueElement(
                    id: valueElement.id,
                    url: valueElement.url,
                    fileName: valueElement.fileName,
                    filePath: valueElement.filePath,
                    deleted: valueElement.deleted,
                    title: valueElement.title,
                    description: valueElement.description,
                    points: valueElement.points,
                    cells: cells
                )
                if (tableFieldValue[tableIndexNo].first(where: {$0.id == valueElement.id}) != nil) {
                    tableFieldValue[tableIndexNo][indexPathSection - 1] = valueElement
                }
                
                tableValueUpdate()
                let row = ["_id":  tableFieldValue[tableIndexNo][indexPathSection - 1].id ?? "",
                           "deleted": false,
                           "cells": cells
                ] as [String: Any]
                saveDelegate?.handleTextCellChangeValue(row: row, rowId: rowId, isEditingEnd: true, index: index)
                saveDelegate?.handleTableOnBlur(rowId: rowId, columnId: columnId, columnIdentifier: columnIdentifier, index: index)
            }
        }
    }
    
    func handleTextCellUpdateValue(_id: String, cellKey: String, cellValue: String, indexRow: Int, indexSection: Int) {
        let rowId = tableRowOrder[tableIndexNo][indexSection-1]
        let columnId = optionsData[tableIndexNo][indexRow-2].id ?? ""
        let columnIdentifier = optionsData[tableIndexNo][indexRow-2].identifier ?? ""
        let dict = tableFieldValue[tableIndexNo][indexSection-1].cells
        var cells = [String:String]()
        for (key, value) in dict ?? [:] {
            if cellKey == key {
                cells[cellKey] = cellValue
            } else {
                cells[key] = value
            }
        }
        if var valueElement = tableFieldValue[tableIndexNo][indexSection - 1] as? ValueElement {
            valueElement = ValueElement(
                id: valueElement.id,
                url: valueElement.url,
                fileName: valueElement.fileName,
                filePath: valueElement.filePath,
                deleted: valueElement.deleted,
                title: valueElement.title,
                description: valueElement.description,
                points: valueElement.points,
                cells: cells
            )
            if (tableFieldValue[tableIndexNo].first(where: {$0.id == valueElement.id}) != nil) {
                tableFieldValue[tableIndexNo][indexSection - 1] = valueElement
            }
            
            tableValueUpdate()
            let row = ["_id":  tableFieldValue[tableIndexNo][indexSection - 1].id ?? "",
                       "deleted": false,
                       "cells": cells
            ] as [String: Any]
            saveDelegate?.handleTextCellChangeValue(row: row, rowId: rowId, isEditingEnd: true, index: index)
            saveDelegate?.handleTableOnBlur(rowId: rowId, columnId: columnId, columnIdentifier: columnIdentifier, index: index)
        }
    }
    
    func handleTextCellSetValue(cellValue: String, indexRow: Int, indexSection: Int) {
        let rowId = tableRowOrder[tableIndexNo][indexSection-1]
        let columnId = optionsData[tableIndexNo][indexRow-2].id ?? ""
        let columnIdentifier = optionsData[tableIndexNo][indexRow-2].identifier ?? ""
        let dict = tableFieldValue[tableIndexNo][indexSection-1].cells
        var cells = [String:String]()
        var textCellId = String()
        if let fieldTableColumn = tableColumnOrderId[tableIndexNo].first(where: {$0 == optionsData[tableIndexNo][indexRow-2].id}) {
            textCellId = fieldTableColumn
            cells[textCellId] = cellValue
        }
        for (key, value) in dict ?? [:] {
            cells[key] = value
        }
        if var valueElement = tableFieldValue[tableIndexNo][indexSection - 1] as? ValueElement {
            valueElement = ValueElement(
                id: valueElement.id,
                url: valueElement.url,
                fileName: valueElement.fileName,
                filePath: valueElement.filePath,
                deleted: valueElement.deleted,
                title: valueElement.title,
                description: valueElement.description,
                points: valueElement.points,
                cells: cells
            )
            if (tableFieldValue[tableIndexNo].first(where: {$0.id == valueElement.id}) != nil) {
                tableFieldValue[tableIndexNo][indexSection - 1] = valueElement
            }
            
            tableValueUpdate()
            let row = ["_id":  tableFieldValue[tableIndexNo][indexSection - 1].id ?? "",
                       "deleted": false,
                       "cells": cells
            ] as [String: Any]
            saveDelegate?.handleTextCellChangeValue(row: row, rowId: rowId, isEditingEnd: true, index: index)
            saveDelegate?.handleTableOnBlur(rowId: rowId, columnId: columnId, columnIdentifier: columnIdentifier, index: index)
        }
    }
    
    // Update updated value in the joyDoc
    func tableValueUpdate() {
        let value = joyDocFieldData[index].value
        switch value {
        case .string: break
        case .integer: break
        case .valueElementArray:
            joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
        case .array(_): break
        case .none:
            joyDocFieldData[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
        case .some(.null): break
        }
        
        if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
            let modelValue = joyDocStruct?.fields?[index].value
            switch modelValue {
            case .string: break
            case .integer: break
            case .valueElementArray:
                joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .array(_): break
            case .none:
                joyDocStruct?.fields?[index].value = ValueUnion.valueElementArray(tableFieldValue[tableIndexNo])
            case .some(.null): break
            }
        }
    }
}
