import Foundation
import UIKit

// Global variables
public var numberOfRows = Int()
public var numberOfColumns = Int()
public var selectedIndexPath : Int?
public var tableHeading = [String]()
public var numberingData = [String]()
public var cellSelectedIndexPath: IndexPath?
public var tableDisplayMode = String()
public var selectedTextFieldIndexPath = IndexPath()

public class ViewTable: UIViewController, TextFieldCellDelegate, TextViewCellDelegate, DropDownSelectText, UITextViewDelegate {
    
    public var mainView = UIView()
    public var moreButton = Button()
    public var moveUpButton = Label()
    public var deleteButton = Label()
    public var addRowButton = Button()
    public var dropdownView = UIView()
    public var moveDownButton = Label()
    public var tableFloorsBar = UIView()
    public var duplicateButton = Label()
    public var tableFloorsLabel = Label()
    public var insertBelowButton = Label()
    public var collectionView: UICollectionView!
    public var navigationUpMoveButton = Button()
    public var navigationDownMoveButton = Button()
    public var navigationLeftMoveButton = Button()
    public var navigationRightMoveButton = Button()
    
    let layout = TwoWayScrollingCollectionViewLayout()
    let topAndBottomSubviewborderWidth: CGFloat = 1.0
    let topAndBottomSubviewborderColor: UIColor = UIColor(hexString: "#1F6BFF") ?? .blue
    var textViewTextArray: [String] = ["Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Lorem ipsum dolor sit amet, consectetur adipiscing. lit. Pellentesque vel rutrum nibh,", "Lorem dolor sit amet, consectetur adipiscing.", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1", "Text 1 at 1"]

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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupUI()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        selectedIndexPath = nil
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
            Button.isHidden = false
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
            cell.textView.layer.borderWidth = 0
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
        mainView.addSubview(tableFloorsBar)
        dropdownView.addSubview(deleteButton)
        dropdownView.addSubview(moveUpButton)
        dropdownView.addSubview(moveDownButton)
        dropdownView.addSubview(duplicateButton)
        dropdownView.addSubview(insertBelowButton)
        tableFloorsBar.addSubview(tableFloorsLabel)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        addRowButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        moveUpButton.translatesAutoresizingMaskIntoConstraints = false
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        moveDownButton.translatesAutoresizingMaskIntoConstraints = false
        tableFloorsBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        duplicateButton.translatesAutoresizingMaskIntoConstraints = false
        tableFloorsLabel.translatesAutoresizingMaskIntoConstraints = false
        insertBelowButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to imageView
        NSLayoutConstraint.activate([
            // Top View
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            // PageView Constraint
            tableFloorsBar.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableFloorsBar.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableFloorsBar.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            tableFloorsBar.heightAnchor.constraint(equalToConstant: 39),
            
            // PageLabel Constraint
            tableFloorsLabel.topAnchor.constraint(equalTo: tableFloorsBar.topAnchor, constant: 4),
            tableFloorsLabel.leadingAnchor.constraint(equalTo: tableFloorsBar.leadingAnchor, constant: 0),
            tableFloorsLabel.widthAnchor.constraint(equalToConstant: 135),
            tableFloorsLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // TableView Constraint
            collectionView.topAnchor.constraint(equalTo: tableFloorsBar.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 170),
            collectionView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -20),
            
            // DeleteRowButton Constraint
            addRowButton.topAnchor.constraint(equalTo: tableFloorsBar.topAnchor, constant: 0),
            addRowButton.trailingAnchor.constraint(equalTo: tableFloorsBar.trailingAnchor, constant: -6),
            addRowButton.widthAnchor.constraint(equalToConstant: 94),
            addRowButton.heightAnchor.constraint(equalToConstant: 27),
            
            // MoreButton Constraint
            moreButton.topAnchor.constraint(equalTo: tableFloorsBar.topAnchor, constant: 0),
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
        
        tableFloorsLabel.labelText = "Interior Table"
        tableFloorsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // TableView Properties
        numberOfColumns = 6
        numberOfRows = 20
        tableHeading = ["", "#", "First Floor", "Second Floor", "Third Floor", "Dropdown Cell"]
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
    @objc func clossTapped() {
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
    
    // MARK: AddRow Tapped
    @objc func insertRowTapped() {
        dropdownView.isHidden = true
        updateRowNumber()
        numberOfRows += 1
        let lastSection = collectionView.numberOfSections - 1
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
        collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        collectionView.insertSections(IndexSet(integer: lastSection))
        let newItem = "Text 1 at 1"
        textViewTextArray.append(newItem)
        reloadCollectionRowNumber()
    }
    
    // MARK: InsertBelow Tapped
    @objc func insertBelowTapped() {
        updateRowNumber()
        numberOfRows += 1
        collectionView.insertSections(IndexSet(integer: (cellSelectedIndexPath?.section ?? 0) + 1))
        let newItem = "Text 1 at 1"
        textViewTextArray.insert(newItem, at: (cellSelectedIndexPath?.section ?? 0) + 1)
        selectedIndexPath = nil
        updateCellSubviewBorder(at: 0)
        updateSelectionButton()
        let itemCount = collectionView.numberOfItems(inSection: (cellSelectedIndexPath?.section ?? 0) + 1)
        for itemIndex in 0..<itemCount {
            let indexPath = IndexPath(item: itemIndex, section: (cellSelectedIndexPath?.section ?? 0) + 1)
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    // MARK: Duplicate Tapped
    @objc func duplicateTapped() {
        updateRowNumber()
        numberOfRows += 1
        collectionView.insertSections(IndexSet(integer: (cellSelectedIndexPath?.section ?? 0)))
        let itemToDuplicate = textViewTextArray[cellSelectedIndexPath?.section ?? 0]
        let duplicatedItem = itemToDuplicate
        textViewTextArray.insert(duplicatedItem, at: (cellSelectedIndexPath?.section ?? 0) + 1)
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
    
    // MARK: MoveUp Tapped
    @objc func moveUpTapped() {
        updateRowNumber()
        if cellSelectedIndexPath?.section == 1 {
            
        } else {
            updateSelectionButton()
            collectionView.moveSection(cellSelectedIndexPath?.section ?? 0, toSection: (cellSelectedIndexPath?.section ?? 0) - 1)
            textViewTextArray.swapAt(cellSelectedIndexPath?.section ?? 0, (cellSelectedIndexPath?.section ?? 0) - 1)
        }
        selectedIndexPath = nil
        updateCellSubviewBorder(at: -1)
    }
    
    // MARK: MoveDown Tapped
    @objc func moveDownTapped() {
        updateRowNumber()
        if cellSelectedIndexPath?.section == 0 || cellSelectedIndexPath?.section == numberOfRows - 1 {
            
        } else {
            updateSelectionButton()
            collectionView.moveSection(cellSelectedIndexPath?.section ?? 0, toSection: (cellSelectedIndexPath?.section ?? 0) + 1)
            textViewTextArray.swapAt(cellSelectedIndexPath?.section ?? 0, (cellSelectedIndexPath?.section ?? 0) + 1)
        }
        selectedIndexPath = nil
        updateCellSubviewBorder(at: 1)
    }
    
    // MARK: DeleteRow Tapped
    @objc func deleteTapped() {
        moreButton.isHidden = true
        dropdownView.isHidden = true
        if numberOfRows == 1 {
            
        } else {
            updateRowNumber()
            numberOfRows -= 1
            collectionView.deleteSections(IndexSet(integer: cellSelectedIndexPath?.section ?? 0))
            textViewTextArray.remove(at: cellSelectedIndexPath?.section ?? 0)
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
    
    // Function to update textField and textView on left, up and down navigation button tapped
    func updateTextFieldandViewOnNavigationTapped(cell: CollectionViewCell, newIndexPath: IndexPath) {
        cell.cellTextField.selectedBorderColor = UIColor(hexString: "#1F6BFF") ?? .systemBlue
        cell.textView.layer.borderWidth = 1.0
        cell.textView.layer.cornerRadius = 1.0
        cell.textView.layer.borderColor = UIColor(hexString: "#1F6BFF")?.cgColor
        cell.cellTextField.becomeFirstResponder()
        cell.textView.becomeFirstResponder()
        selectedTextFieldIndexPath = newIndexPath
    }
    
    // MARK: NavigationLeftMoveButton Tapped
    @objc func navigationLeftMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextField.deselectedBorderColor = .clear
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row - 2, section: selectedTextFieldIndexPath.section)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            collectionView.scrollToItem(at: newIndexPath, at: .right, animated: true)
            updateTextFieldandViewOnNavigationTapped(cell: cell, newIndexPath: newIndexPath)
        }
    }
    
    // MARK: NavigationUpMoveButton Tapped
    @objc func navigationUpMoveTapped() {
        if selectedTextFieldIndexPath.section == 1 {
            
        } else {
            if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
                cell.cellTextField.deselectedBorderColor = .clear
                cell.textView.layer.borderWidth = 0
            }
            let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row, section: selectedTextFieldIndexPath.section - 1)
            if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
                updateTextFieldandViewOnNavigationTapped(cell: cell, newIndexPath: newIndexPath)
            }
        }
    }
    
    // MARK: NavigationDownMoveButton Tapped
    @objc func navigationDownMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextField.deselectedBorderColor = .clear
            cell.textView.layer.borderWidth = 0
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row, section: selectedTextFieldIndexPath.section + 1)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            updateTextFieldandViewOnNavigationTapped(cell: cell, newIndexPath: newIndexPath)
        }
    }
    
    // MARK: NavigationRightMoveButton Tapped
    @objc func navigationRightMoveTapped() {
        if let cell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            cell.cellTextField.deselectedBorderColor = .clear
            cell.textView.layer.borderWidth = 0
        }
        let newIndexPath = IndexPath(row: selectedTextFieldIndexPath.row + 2, section: selectedTextFieldIndexPath.section)
        if let cell = collectionView.cellForItem(at: newIndexPath) as? CollectionViewCell {
            collectionView.scrollToItem(at: newIndexPath, at: .left, animated: true)
            cell.cellTextField.selectedBorderColor = UIColor(hexString: "#1F6BFF") ?? .systemBlue
            cell.cellTextField.becomeFirstResponder()
            cell.textView.becomeFirstResponder()
            selectedTextFieldIndexPath = newIndexPath
        }
    }
}

// MARK: Setup collectionView
extension ViewTable: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        cell.textFieldDelegate = self
        cell.textViewDelegate = self
        
        viewTableSetUpCellTextField(at: cell)
        viewTableDispalyMode(at: cell)
        viewTablePopUpModal(cell: cell, indexPath: indexPath)
        viewTableCollectionViewHeader(cell: cell, indexPath: indexPath)
        
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
        if tableDisplayMode == "readonly" {
            
        } else {
            if indexPath.item == 0 {
                if indexPath.section == selectedIndexPath {
                    let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
                    cell?.selectionButton.setImage(UIImage(named: "selectButton"), for: .normal)
                    selectedIndexPath = nil
                } else {
                    let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
                    cell?.selectionButton.setImage(UIImage(named: "selectButton"), for: .normal)
                    collectionView.reloadData()
                }
                selectedIndexPath = indexPath.section
                cellSelectedIndexPath = indexPath
                moreButton.isHidden = false
            } else {

            }
        }
    }
    
    // MARK: CollectionView delegate method to adjust cell height and width
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Set cell height and width at 1st row
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                return CGSize(width: 50, height: 37.5)
            } else if indexPath.item == 1 {
                return CGSize(width: 50, height: 37.5)
            } else {
                return CGSize(width: 133, height: 37.5)
            }
        }
        
        let width = 133.0
        let textHeight = heightForText(textViewTextArray[indexPath.section], font: UIFont.systemFont(ofSize: 17), width: width) + 20
        
        if indexPath.item == 0 {
            return CGSize(width: 50, height: textHeight)
        } else if indexPath.item == 1 {
            return CGSize(width: 50, height: textHeight)
        } else {
            return CGSize(width: 133, height: textHeight)
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
   
    // MARK: TextField delegate method for textField selection
    func textFieldCellDidSelect(_ cell: UICollectionViewCell) {
        if let previousCell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            previousCell.textView.borderWidth = 0
        }
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }

        selectedTextFieldIndexPath = indexPath
    }
    
    // MARK: TextView delegate method for textView selection
    func textViewCellDidSelect(_ cell: UICollectionViewCell) {
        
        if let previousCell = collectionView.cellForItem(at: selectedTextFieldIndexPath) as? CollectionViewCell {
            previousCell.textView.borderWidth = 0
        }
        let indexPath = collectionView.indexPath(for: cell)
        if let cell = collectionView.cellForItem(at: indexPath ?? IndexPath(row: 0, section: 0)) as? CollectionViewCell {
            cell.textView.layer.borderWidth = 1.0
            cell.textView.layer.cornerRadius = 1.0
            cell.textView.layer.borderColor = UIColor(hexString: "#1F6BFF")?.cgColor
            cell.textView.becomeFirstResponder()
        }
        
        selectedTextFieldIndexPath = indexPath ?? IndexPath(row: 0, section: 0)
    }
    
    // Function to calculate text height
    private func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
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
    
    // Function to set properties of textField
    func viewTableSetUpCellTextField(at cell: CollectionViewCell) {
        cell.cellTextField.borderWidth = 0
        cell.cellTextField.containerRadius = 0
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
    }
    
    // Function to handle table popup modal
    func viewTablePopUpModal(cell: CollectionViewCell, indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.item == 0 {
            cell.selectionButton.isUserInteractionEnabled = false
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setupSelectionButton()
        } else if indexPath.row == 1 && indexPath.item == 1 {
            cell.numberLabel.labelText = numberingData[indexPath.section]
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setupNumberLabel()
        } else if indexPath.row == 2 && indexPath.item == 2 {
            cell.textView.text = textViewTextArray[indexPath.section]
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setupTextView()
        } else if indexPath.row == 3 && indexPath.item == 3 {
            cell.contentView.subviews.forEach { $0.removeFromSuperview()}
            cell.setupSeparator()
            cell.setupImageView()
            setImageOpacity(cell: cell, indexPath: indexPath)
        } else if indexPath.row == 5 && indexPath.item == 5 {
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setupDropdown()
        } else {
            cell.cellTextField.text = "Column = \(indexPath.section)"
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.setupSeparator()
            cell.setupTextField()
        }
    }
    
    // Function to set image opacity
    func setImageOpacity(cell: CollectionViewCell, indexPath: IndexPath) {
        if indexPath.section == 1 || indexPath.section == 2 {
            cell.image.layer.opacity = 1.0
            cell.countLabel.isHidden = false
        } else {
            cell.image.layer.opacity = 0.5
            cell.countLabel.isHidden = true
        }
    }
    
    // Function to handle cells according to displayMode
    func viewTableDispalyMode(at cell: CollectionViewCell) {
        switch tableDisplayMode {
        case "readonly":
            cell.textView.isUserInteractionEnabled = false
            cell.cellTextField.isUserInteractionEnabled = false
        default:
            cell.textView.isUserInteractionEnabled = true
            cell.cellTextField.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dropdownOpen))
            cell.dropdownView.addGestureRecognizer(tap)
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
            cellLabel.labelText = tableHeading[indexPath.row]
            cellLabel.backgroundColor = UIColor(hexString: "#F3F4F8")
            cellLabel.borderColor = UIColor(hexString: "#E6E7EA") ?? .lightGray
            viewTableHandlePopupModalForHeader(cellLabel: cellLabel, indexPath: indexPath)
            cell.contentView.addSubview(cellLabel)
        default:
            break
        }
    }
    
    // Function to handle popup modal for collectionView header
    func viewTableHandlePopupModalForHeader(cellLabel: Label, indexPath: IndexPath) {
        let cellWidth = 133.0
        let cellHeight = 37.5
        
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
    
    // Function to open dropdown
    @objc func dropdownOpen(_ sender: Any) {
        let dropdownOptionArray: NSArray = ["Yes","No"]
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.dropdownOptionArray = dropdownOptionArray
        self.present(vc, animated: false)
    }
    
    func selectText(text: String) {}
}
