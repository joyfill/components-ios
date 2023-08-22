import Foundation
import UIKit
import Photos

public var multiSelect = Bool()
public var multiSelectOptions = [String]()

public class MultipleChoice: UIView {

    public var titleLabel = Label()
    public var tableView = UITableView()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
    public var selectArray : Int?
    public var multipleChoiceDspMode = String()
    public var selectedIndexPath = NSMutableArray()
    public var tooltipView: TooltipView?
    
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
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            //TooltipIconButton
            toolTipIconButton.topAnchor.constraint(equalTo: self.topAnchor),
            toolTipIconButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 20),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 20),
            
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
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
        
        toolTipIconButton.setImage(UIImage(named: "Info"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipIconButton.isSelected = !toolTipIconButton.isSelected
        let selected = toolTipIconButton.isSelected
        // Create the tooltip view
        if selected == true {
            tooltipView = TooltipView()
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(tooltipView!)
                
                tooltipView?.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    tooltipView!.bottomAnchor.constraint(equalTo: toolTipIconButton.topAnchor, constant: -5),
                    tooltipView!.centerXAnchor.constraint(equalTo: toolTipIconButton.centerXAnchor),
                    tooltipView!.widthAnchor.constraint(equalToConstant: 150),
                ])
                
                tooltipView?.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.tooltipView?.alpha = 1
                }
                tooltipView?.titleText.text = toolTipTitle
                tooltipView?.descriptionText.text = toolTipDescription
            }
        } else {
            tooltipView?.removeFromSuperview()
        }
    }
}

// MARK: Setup tableView
extension MultipleChoice: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multiSelectOptions.count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiChoiceTableViewCell", for: indexPath as IndexPath) as! MultiChoiceTableViewCell
        if multiSelect == true {
            if selectedIndexPath.contains(indexPath.row) {
                cell.cellCheckbox.isChecked = true
                cell.cellCheckbox.checkboxFillColor = UIColor(hexString: "#3767ED") ?? .lightGray
            } else {
                cell.cellCheckbox.isChecked = false
                cell.cellCheckbox.checkboxFillColor = .white
            }
        } else {
            if selectArray == indexPath.row {
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
        cell.cellLabel.text = multiSelectOptions[indexPath.row]
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
        let text = multiSelectOptions[indexPath.row]
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
            workAsMultipleSelection(at: indexPath)
        } else {
            selectArray = indexPath.row
            tableView.reloadData()
        }
    }
    
    // Function called when multiSelect == true
    func workAsMultipleSelection(at indexPath: IndexPath) {
        if selectedIndexPath.contains(indexPath.row) {
            selectedIndexPath.remove(indexPath.row)
            tableView.reloadData()
        } else {
            selectedIndexPath.add(indexPath.row)
            tableView.reloadData()
        }
    }
}
