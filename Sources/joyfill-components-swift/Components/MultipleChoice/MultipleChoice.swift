import Foundation
import UIKit
import Photos

public class MultipleChoice: UIView {

    public var titleLabel = Label()
    public var tableView = UITableView()
    
    public var selectArray : Int?
    public var multiSelect = Bool()
    public var choiceOptionsArray = [String]()
    public var multipleChoiceDspMode = String()
    public var selectedIndexPath = NSMutableArray()
    
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
    open var cellbackgroundColor: UIColor? {
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
    
    func setupUI () {
        // SubViews
        addSubview(titleLabel)
        addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to ShortTextView
        NSLayoutConstraint.activate([
            // TitleLabel Constraints
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -8),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
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
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}

// MARK: Setup tableView
extension MultipleChoice: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choiceOptionsArray.count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiChoiceTableViewCell", for: indexPath as IndexPath) as! MultiChoiceTableViewCell
        if multiSelect == true {
            if selectedIndexPath.contains(indexPath.row) {
                cell.myCheckbox.isChecked = true
                cell.myCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
            } else {
                cell.myCheckbox.isChecked = false
                cell.myCheckbox.checkboxFillColor = .white
            }
        } else {
            if selectArray == indexPath.row {
                cell.myCheckbox.isChecked = true
                cell.myCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
            } else {
                cell.myCheckbox.isChecked = false
                cell.myCheckbox.checkboxFillColor = .white
            }
        }
        cell.selectionStyle = .none
        cell.myCheckbox.isUserInteractionEnabled = false
        cell.cellLabel.text = choiceOptionsArray[indexPath.row]
        return cell
    }
    
    // MARK: TableView delegate function called when cell is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if multipleChoiceDspMode == "readonly" {
            
        } else {
            checkForMultiSelectOrSingleSelect(at: indexPath)
        }
    }
    
    // MARK: TableView delegate method to adjust cell height
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Calculate the required height for the text in the cell
        let text = choiceOptionsArray[indexPath.row]
        let font = UIFont.systemFont(ofSize: 16) // Replace with your desired font and size
        let width = tableView.frame.width - 10 // Adjust the left and right margins
        let height = heightForText(text , font: font, width: width)
        return height + 30
    }
    
    // Helper method to calculate the height of the text
    func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let nsText = text as NSString
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = nsText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes, context: nil)
        return ceil(boundingRect.height)
    }
    
    // Function to check multiSelect or singleSelect
    func checkForMultiSelectOrSingleSelect(at indexPath: IndexPath) {
        if multiSelect == true {
            if selectedIndexPath.contains(indexPath.row) {
                selectedIndexPath.remove(indexPath.row)
                tableView.reloadData()
            } else {
                selectedIndexPath.add(indexPath.row)
                tableView.reloadData()
            }
        } else {
            selectArray = indexPath.row
            tableView.reloadData()
        }
    }
}
