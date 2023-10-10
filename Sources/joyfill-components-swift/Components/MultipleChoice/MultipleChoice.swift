import Foundation
import UIKit
import Photos

public var multiSelect = [Bool]()
public var multiSelectOptions = [[String]]()
public var singleChoiseSelectedIndexPath = [Int]()
public var multiChoiseSelectedIndexPath = [NSMutableArray]()

public class MultipleChoice: UIView {

    public var titleLabel = Label()
    public var toolTipTitle = String()
    public var tableView = UITableView()
    public var toolTipDescription = String()
    public var toolTipIconButton = UIButton()
    public var multiSelectOptionsIndex = Int()
    public var multipleChoiceDspMode = String()
    
    var index = Int()
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
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
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
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        if #available(iOS 13.0, *) {
         self.overrideUserInterfaceStyle = .light
        }
        
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
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
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
        return multiSelectOptions[multiSelectOptionsIndex].count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiChoiceTableViewCell", for: indexPath as IndexPath) as! MultiChoiceTableViewCell
        if multiSelect[multiSelectOptionsIndex] == true {
            if multiChoiseSelectedIndexPath[multiSelectOptionsIndex].contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellCheckbox.checkboxFillColor = .white
            }
        } else {
            if singleChoiseSelectedIndexPath[multiSelectOptionsIndex] == indexPath.row {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkmarkStyle = .circle
                cell.cellCheckbox.borderStyle = .circle
                cell.cellCheckbox.checkmarkSize = 0.4
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#256FFF") ?? .blue
                cell.cellCheckbox.checkmarkColor = .white
                
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
        cell.cellLabel.text = multiSelectOptions[multiSelectOptionsIndex][indexPath.row]
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
        let text = multiSelectOptions[multiSelectOptionsIndex][indexPath.row]
        let font = UIFont.systemFont(ofSize: 16)
        let width = tableView.frame.width - 10
        let height = heightForText(text , font: font, width: width)
        return height + 30
    }
    
    // Function to check multiSelect or singleSelect
    func checkForMultiSelectOrSingleSelect(at indexPath: IndexPath) {
        if multiSelect[multiSelectOptionsIndex] == true {
            workAsMultipleSelection(at: indexPath)
        } else {
            singleChoiseSelectedIndexPath[multiSelectOptionsIndex] = indexPath.row
            saveDelegate?.handleFieldChange(text: [multiSelectOptionId[multiSelectOptionsIndex][indexPath.row]], isEditingEnd: true, index: index)
            tableView.reloadData()
        }
    }
    
    // Function called when multiSelect == true
    func workAsMultipleSelection(at indexPath: IndexPath) {
        var selectedId = [String]()
        if multiChoiseSelectedIndexPath[multiSelectOptionsIndex].contains(indexPath.row) {
            multiChoiseSelectedIndexPath[multiSelectOptionsIndex].remove(indexPath.row)
            tableView.reloadData()
        } else {
            multiChoiseSelectedIndexPath[multiSelectOptionsIndex].add(indexPath.row)
            for i in 0..<multiSelectOptionId[multiSelectOptionsIndex].count {
                if multiChoiseSelectedIndexPath[multiSelectOptionsIndex].contains(i) {
                    selectedId.append(multiSelectOptionId[multiSelectOptionsIndex][i])
                    saveDelegate?.handleFieldChange(text: selectedId, isEditingEnd: true, index: index)
                }
            }
            tableView.reloadData()
        }
    }
}
