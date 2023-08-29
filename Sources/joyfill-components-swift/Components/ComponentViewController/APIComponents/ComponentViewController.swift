import Foundation
import UIKit

public var componentTableView = UITableView()
public var viewForDataSource = UIView()
public class ComponentViewController: UIView {
    
    public var componentView = UIView()
    public var image = Image()
    var cellView = [UIView]()
    var cellHeight = [CGFloat]()
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    override public func didMoveToSuperview() {
        
    }
    
    func setupUI() {
        // SubViews
        addSubview(componentView)
        componentView.addSubview(componentTableView)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to components
        NSLayoutConstraint.activate([
            // ComponentView Constraint
            componentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            componentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            componentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            componentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // TableView Constraint
            componentTableView.topAnchor.constraint(equalTo: componentView.topAnchor, constant: 9),
            componentTableView.leadingAnchor.constraint(equalTo: componentView.leadingAnchor, constant: 0),
            componentTableView.trailingAnchor.constraint(equalTo: componentView.trailingAnchor, constant: 0),
            componentTableView.bottomAnchor.constraint(equalTo: componentView.bottomAnchor, constant: -10)
        ])
        
        // Set cornerRadius and shadow to view.
        backgroundColor = .white
        componentView.backgroundColor = .white
        componentView.layer.cornerRadius = 15
        componentView.layer.shadowOpacity = 0.3
        componentView.layer.shadowRadius = 3.0
        componentView.layer.shadowColor = UIColor.black.cgColor
        componentView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        // Set tableView Properties
        componentTableView.bounces = false
        componentTableView.separatorStyle = .none
        componentTableView.allowsSelection = false
        componentTableView.tintColor = .white
        componentTableView.showsVerticalScrollIndicator = false
        componentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewForDataSource = self
    }
}

// MARK: Setup tableView
extension ComponentViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentType.count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        componentTableView.separatorStyle = .none
        // Configure the cell
        for i in 0..<componentType.count {
            if componentType[i] == "image" {
                // MARK: Image Function Call From Package
                if pickedImg.count == 0 {
                    tableView.rowHeight = 150
                } else {
                    tableView.rowHeight = 260
                }
                image.toolTipTitle = "Testing Image"
                image.titleButton.text = componentHeaderText[i]
                image.allowMultipleImages(value: imageMultiValue)
                image.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(image)
                
            } else if componentType[i] == "text" {
                
                // MARK: TextField Function Call From Package
                let shortText = ShortText()
                tableView.rowHeight = 80
                shortText.toolTipTitle = "Testing Text"
                shortText.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                shortText.topLabel.labelText = componentHeaderText[i]
                shortText.textField.fieldText = textFieldString ?? ""
                shortText.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(shortText)
                
            } else if componentType[i] == "multiSelect" {
                
                // MARK: MultiChoice Function Call From Package
                let multipleChoice = MultipleChoice()
                tableView.rowHeight = 190
                multipleChoice.toolTipTitle = "Testing MultiSelect"
                multipleChoice.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                multipleChoice.titleLabel.labelText = componentHeaderText[i]
                multipleChoice.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(multipleChoice)
                
            } else if componentType[i] == "dropdown" {
                
                // MARK: MultiSelect DropDown Function Call From Package
                let dropDownText = Dropdown()
                tableView.rowHeight = 100
                dropDownText.doneHide = "singleSelect"
                dropDownText.toolTipTitle = "Testing DropDown"
                dropDownText.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                dropDownText.titleText = componentHeaderText[i]
                dropDownText.dropdownPlaceholder = dropdownOptions.first ?? ""
                dropDownText.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(dropDownText)
                
            } else if componentType[i] == "textarea" {
                
                // MARK: TextField Function Call From Package
                let longText = LongText()
                tableView.rowHeight = 200
                longText.toolTipTitle = "Testing LongText"
                longText.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                longText.topLabel.labelText = componentHeaderText[i]
                longText.textField.text = (textAreaString ?? "") + "\n \n \n \n \n"
                longText.frame = CGRect(x: 20, y: 15, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(longText)
                
            } else if componentType[i] == "date" {
                
                // MARK: DateTime Function Call From Package
                let datetime = DateTime()
                tableView.rowHeight = 80
                datetime.titleText = componentHeaderText[i]
                datetime.toolTipTitle = "Testing DateTime"
                datetime.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                datetime.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(datetime)
                
            } else if componentType[i] == "signature" {
                
                // MARK: Signature Function Call From Package
                let sign = SignatureView()
                tableView.rowHeight = 270
                sign.toolTipTitle = "Testing Signature"
                sign.titleLabel.labelText = componentHeaderText[i]
                sign.frame = CGRect(x: 20, y: 0, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(sign)
                
            } else if componentType[i] == "block" {
                
                // MARK: Label Function Call From Package
                let displayText = Label()
                tableView.rowHeight = 50
                displayText.fontSize = CGFloat(blockTextSize)
                displayText.labelText = blockFieldString ?? "Demo Text"
                displayText.textColor = UIColor(hexString: blockTextColor)
                displayText.isTextBold = blockTextWeight == "bold" ? true : false
                displayText.isTextItalic = blockTextStyle == "italic" ? true : false
                displayText.textAlignment = blockTextAlignment.textAlignmentFromStringValue()
                displayText.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(displayText)
                
            } else if componentType[i] == "number" {
                
                // MARK: Number Function Call From Package
                let number = NumberField()
                tableView.rowHeight = 100
                number.titleText = componentHeaderText[i]
                number.currentPage = numberFieldString ?? 0
                number.numberField.text = "\(numberFieldString ?? 0)"
                number.toolTipTitle = "Testing Number"
                number.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                number.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(number)
                
            } else if componentType[i] == "chart" {
                
                // MARK: Chart Function Call From Package
                let chart = Chart()
                tableView.rowHeight = 380
                chart.performanceGraphLabel.labelText = componentHeaderText[i]
                chart.toolTipTitle = "Testing Chart"
                chart.toolTipDescription = "Should be same person that signs signature field. Don’t forget to capture."
                chart.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(chart)
                
            } else if componentType[i] == "table" {
                
                // MARK: Chart Function Call From Package
                let table = Table()
                tableView.rowHeight = 200
                table.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(table)
            }
        }
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(cellView[indexPath.row])
        return cell
    }
    
    // MARK: TableView delegate method to adjust cell height
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight.removeAll()
        for i in 0..<componentType.count {
            if componentType[i] == "image" {
                if pickedImg.count == 0 {
                    cellHeight.append(160)
                } else {
                    cellHeight.append(270)
                }
            }
            if componentType[i] == "text" {
                cellHeight.append(90)
            }
            if componentType[i] == "multiSelect" {
                cellHeight.append(190)
            }
            if componentType[i] == "dropdown" {
                cellHeight.append(100)
            }
            if componentType[i] == "textarea" {
                cellHeight.append(190)
            }
            if componentType[i] == "date" {
                cellHeight.append(100)
            }
            if componentType[i] == "signature" {
                cellHeight.append(260)
            }
            if componentType[i] == "block" {
                cellHeight.append(50)
            }
            if componentType[i] == "number" {
                cellHeight.append(100)
            }
            if componentType[i] == "chart" {
                cellHeight.append(380)
            }
            if componentType[i] == "table" {
                cellHeight.append(200)
            }
        }
        return cellHeight[indexPath.row]
    }
}
