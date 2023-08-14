import Foundation
import UIKit

public class ComponentsViewController: UIView {
    
    public var componentView = UIView()
    public var componentTableView = UITableView()
    
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
    
    func setupUI() {
        // Deinitialize arrays to protect memory leakage
        yCoordinates = []
        xCoordinates = []
        graphLabelData = []
        pickedImg.removeAll()
        _ = JoyfillApi2.loadFromJSON()
        
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
        componentTableView.dataSource = self
        componentTableView.delegate = self
        componentTableView.bounces = false
        componentTableView.separatorStyle = .none
        componentTableView.allowsSelection = false
        componentTableView.showsVerticalScrollIndicator = false
        componentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

// MARK: Setup tableView
extension ComponentsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentType2.count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell
        for i in 0..<componentType2.count {
            if componentType2[i] == "image" {
                
                // MARK: Image Function Call From Package
                let image = Image()
                tableView.rowHeight = 410
                image.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(image)
                
            } else if componentType2[i] == "text" {
                
                // MARK: TextField Function Call From Package
                let shortText = ShortText()
                tableView.rowHeight = 80
                shortText.topLabel.labelText = componentHeaderText2[i]
                shortText.textField.fieldText = textFieldString2 ?? ""
                shortText.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(shortText)
                
            } else if componentType2[i] == "multiSelect" {
                
                // MARK: MultiChoice Function Call From Package
                let multipleChoice = MultipleChoice()
                tableView.rowHeight = 200
                multipleChoice.multiSelect = true
                multipleChoice.titleLabel.labelText = componentHeaderText2[i]
                multipleChoice.frame = CGRect(x: 20, y: 0, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(multipleChoice)
                
            } else if componentType2[i] == "dropdown" {
                
                // MARK: MultiSelect DropDown Function Call From Package
                let dropDownText = Dropdown()
                tableView.rowHeight = 100
                dropDownText.titleText = componentHeaderText2[i]
                dropDownText.dropdownPlaceholder = "Option 1"
                dropDownText.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(dropDownText)
                
            } else if componentType2[i] == "textarea" {
                
                // MARK: TextField Function Call From Package
                let longText = LongText()
                tableView.rowHeight = 200
                longText.topLabel.labelText = componentHeaderText2[i]
                longText.textField.text = (textAreaString2 ?? "") + "\n \n \n \n \n"
                longText.frame = CGRect(x: 20, y: 15, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(longText)
                
            } else if componentType2[i] == "date" {
                
                // MARK: DateTime Function Call From Package
                let datetime = DateTime()
                tableView.rowHeight = 100
                datetime.titleText = componentHeaderText2[i]
                datetime.dateTimePlacholder = "MM-dd-YYYY"
                datetime.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(datetime)
                
            } else if componentType2[i] == "signature" {
                
                // MARK: Signature Function Call From Package
                var sign = UIView()
                if #available(iOS 13.0, *) {
                    sign = Signature()
                } else {
                    // Fallback on earlier versions
                }
                tableView.rowHeight = 270
//                sign.topLabel.labelText = labelTitle[i]
                sign.frame = CGRect(x: 20, y: 0, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(sign)
                
            } else if componentType2[i] == "block" {
                
                // MARK: Label Function Call From Package
                let displayText = Label()
                tableView.rowHeight = 50
                displayText.fontSize = CGFloat(blockTextSize2)
                displayText.labelText = blockFieldString2 ?? "Demo Text"
                displayText.textColor = UIColor(hexString: blockTextColor2)
                displayText.isTextBold = blockTextWeight2 == "bold" ? true : false
                displayText.isTextItalic = blockTextStyle2 == "italic" ? true : false
                displayText.textAlignment = blockTextAlignment2.textAlignmentFromStringValue()
                displayText.frame = CGRect(x: 20, y: 10, width: tableView.bounds.width - 40, height: tableView.rowHeight)
                cellView.append(displayText)
                
            } else if componentType2[i] == "number" {
                
                // MARK: Number Function Call From Package
                let number = NumberField()
                tableView.rowHeight = 100
                number.numberFieldPlacholder = "0"
                number.titleText = componentHeaderText2[i]
                number.currentPage = Int(numberFieldString2 ?? 0)
                number.numberField.text = "\(numberFieldString2 ?? 0)"
                number.frame = CGRect(x: 10, y: 10, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(number)
                
            } else if componentType2[i] == "chart" {
                
                // MARK: Chart Function Call From Package
                let chart = Chart()
                tableView.rowHeight = 380
                chart.performanceGraphLabel.labelText = componentHeaderText2[i]
                chart.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: tableView.rowHeight)
                cellView.append(chart)
                
            } else if componentType2[i] == "table" {
                
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
        for i in 0..<componentType2.count {
            if componentType2[i] == "image" {
                cellHeight.append(430)
            }
            if componentType2[i] == "text" {
                cellHeight.append(90)
            }
            if componentType2[i] == "multiSelect" {
                cellHeight.append(200)
            }
            if componentType2[i] == "dropdown" {
                cellHeight.append(100)
            }
            if componentType2[i] == "textarea" {
                cellHeight.append(190)
            }
            if componentType2[i] == "date" {
                cellHeight.append(100)
            }
            if componentType2[i] == "signature" {
                cellHeight.append(260)
            }
            if componentType2[i] == "block" {
                cellHeight.append(50)
            }
            if componentType2[i] == "number" {
                cellHeight.append(100)
            }
            if componentType2[i] == "chart" {
                cellHeight.append(380)
            }
            if componentType2[i] == "table" {
                cellHeight.append(200)
            }
        }
        return cellHeight[indexPath.row]
    }
}
