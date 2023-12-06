import Foundation
import UIKit
import Photos

public var multiSelect = [Bool]()
public var multiSelectOptions = [[String]]()
public var multiChoiseSelectedOptionIndexPath = [NSMutableArray]()

public class MultipleChoice: UIView {

    public var titleLabel = Label()
    public var toolTipTitle = String()
    public var tableView = UITableView()
    public var toolTipDescription = String()
    public var toolTipIconButton = UIButton()
    public var multipleChoiceDspMode = String()
    
    var index = Int()
    var selectedId = [String]()
    var saveDelegate: SaveTextFieldValue? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    //Multiple Choice Table View CornerRadius
    @IBInspectable
    open var cornerRadius: CGFloat = 5 {
        didSet {
            tableView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    open var borderWidth: CGFloat = 1 {
        didSet {
            tableView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor = UIColor.lightGray {
        didSet {
            tableView.layer.borderColor = borderColor.cgColor
        }
    }
    
    //Multiple Choice Table View backgroundColor
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            tableView.layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    //Cell View CornerRadius
    @IBInspectable
    open var cellCornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    open var cellBorderWidth: CGFloat = 0.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    open var cellBorderColor: UIColor = UIColor(hexString: "#C0C1C6") ?? .lightGray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    //Multiple Choice Table View backgroundColor
    @IBInspectable
    open var cellBackgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    //Title TextColor
    @IBInspectable
    public var titleBackgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = titleBackgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    public var titleFontSize : CGFloat = 17 {
        didSet {
            UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    public func multipleChoiseDisplayModes(mode : String) {
        multipleChoiceDspMode = mode
    }
    
    func setupUI () {
        // SubViews
        addSubview(titleLabel)
        addSubview(toolTipIconButton)
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to ShortTextView
        NSLayoutConstraint.activate([
            // TitleLabel Constraints
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        setGlobalUserInterfaceStyle()
        
        // tableView Properties
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        tableView.register(MultiChoiceTableViewCell.self, forCellReuseIdentifier: "MultiChoiceTableViewCell")
        
        titleLabel.borderWidth = 0
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon", in: .module, compatibleWith: nil), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}

// MARK: Setup tableView
extension MultipleChoice: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multiSelectOptions[index].count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiChoiceTableViewCell", for: indexPath as IndexPath) as! MultiChoiceTableViewCell
        if multipleChoiceDspMode == "readonly" {
            cell.contentView.backgroundColor = UIColor(hexString: "#F5F5F5")
        } else {
            cell.contentView.backgroundColor = .white
        }
        if multiSelect[index] == true {
            if multiChoiseSelectedOptionIndexPath[index].contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellCheckbox.checkboxFillColor = .white
            }
        } else {
            if multiChoiseSelectedOptionIndexPath[index].contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkmarkStyle = .circle
                cell.cellCheckbox.borderStyle = .circle
                cell.cellCheckbox.checkmarkSize = 0.4
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#256FFF") ?? .blue
                cell.cellCheckbox.checkmarkColor = .white
                multiChoiseSelectedOptionIndexPath[index].remove(indexPath.row)
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellCheckbox.checkboxFillColor = .white
                cell.cellCheckbox.borderStyle = .circle
                cell.cellCheckbox.uncheckedBorderColor = UIColor(hexString: "#D1D1D6")
                cell.cellCheckbox.borderLineWidth = 5
            }
        }
        cell.selectionStyle = .none
        cell.cellCheckbox.isUserInteractionEnabled = false
        cell.cellLabel.text = multiSelectOptions[index][indexPath.row]
        return cell
    }
    
    // MARK: TableView delegate function called when cell is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if multipleChoiceDspMode != "readonly" {
            checkForMultiSelectOrSingleSelect(at: indexPath)
        }
    }
    
    // MARK: TableView delegate method to adjust cell height
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the required height for the text in the cell
        let text = multiSelectOptions[index][indexPath.row]
        let font = UIFont.systemFont(ofSize: 16)
        let width = tableView.frame.width - 10
        let height = heightForText(text , font: font, width: width)
        return height + 30
    }
    
    // Function to check multiSelect or singleSelect
    func checkForMultiSelectOrSingleSelect(at indexPath: IndexPath) {
        if multiSelect[index] == true {
            workAsMultipleSelection(at: indexPath)
        } else {
            multiChoiseSelectedOptionIndexPath[index].add(indexPath.row)
            saveDelegate?.handleFocus(index: index)
            multiSelectOrSingleSelectValueUpadte(valueId: [multiSelectOptionId[index][indexPath.row]])
            saveDelegate?.handleFieldChange(text: [multiSelectOptionId[index][indexPath.row]], isEditingEnd: true, index: index)
            tableView.reloadData()
        }
    }
    
    // Update updated value in the joyDoc
    func multiSelectOrSingleSelectValueUpadte(valueId: [String]) {
        let value = joyDocFieldData[index].value
        switch value {
        case .string: break
        case .integer: break
        case .valueElementArray(_):
            joyDocFieldData[index].value = ValueUnion.array(valueId)
        case .array:
            joyDocFieldData[index].value = ValueUnion.array(valueId)
        case .none:
            joyDocFieldData[index].value = ValueUnion.array(valueId)
        case .some(.null): break
        }
        
        if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
            let modelValue = joyDocStruct?.fields?[index].value
            switch modelValue {
            case .string: break
            case .integer: break
            case .valueElementArray(_):
                joyDocStruct?.fields?[index].value = ValueUnion.array(valueId)
            case .array:
                joyDocStruct?.fields?[index].value = ValueUnion.array(valueId)
            case .none:
                joyDocStruct?.fields?[index].value = ValueUnion.array(valueId)
            case .some(.null): break
            }
        }
    }
    
    // Function called when multiSelect == true
    func workAsMultipleSelection(at indexPath: IndexPath) {
        if multiChoiseSelectedOptionIndexPath[index].contains(indexPath.row) {
            multiChoiseSelectedOptionIndexPath[index].remove(indexPath.row)
            updateSelectedValue()
            tableView.reloadData()
        } else {
            multiChoiseSelectedOptionIndexPath[index].add(indexPath.row)
            updateSelectedValue()
            tableView.reloadData()
        }
    }
    
    func updateSelectedValue() {
        for i in 0..<multiSelectOptionId[index].count {
            if multiChoiseSelectedOptionIndexPath[index].contains(i) {
                selectedId.append(multiSelectOptionId[index][i])
                saveDelegate?.handleFocus(index: index)
                multiSelectOrSingleSelectValueUpadte(valueId: selectedId)
                saveDelegate?.handleFieldChange(text: selectedId, isEditingEnd: true, index: index)
            }
        }
        selectedId.removeAll()
    }
}
