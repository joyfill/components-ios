import Foundation
import UIKit

// TextField protocol to get the selected indexPath
protocol ChartViewTextFieldCellDelegate: AnyObject {
    func textFieldCellDidSelect(_ cell: UITableViewCell)
}

public class ChartLineTableViewCell: UITableViewCell, ChartViewTextFieldCellDelegate {
    
    public var view = UIView()
    public var label = Label()
    public var image = ImageView()
    public var pointsLabel = Label()
    public var removeView = UIView()
    public var removeLabel = Button()
    public var removeImage = ImageView()
    public var addPointButton = Button()
    public var pointsTableView = UITableView()
    public var typeTitleTextField = ShortText()
    public var typeDescriptionTextField = TextField()
    
    var cellTapGestureRecognizer: UITapGestureRecognizer?
    weak var textFieldDelegate: ChartViewTextFieldCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Function to get the YCoordinates value
    func configureY(with data: [CGFloat], at indexPath: IndexPath) {
        if indexPath.row < yCoordinates.count {
            yCoordinates[indexPath.row] = data
        } else {
            yCoordinates.append(data)
        }
        yPointsData = data
        pointsTableView.reloadData()
    }
    
    // Function to get the XCoordinates value
    func configureX(with data: [CGFloat], at indexPath: IndexPath) {
        if indexPath.row < xCoordinates.count {
            xCoordinates[indexPath.row] = data
        } else {
            xCoordinates.append(data)
        }
        xPointsData = data
        pointsTableView.reloadData()
    }
    
    func setupCell() {
        // SubViews
        contentView.addSubview(view)
        contentView.addSubview(removeView)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(addPointButton)
        contentView.addSubview(pointsTableView)
        contentView.addSubview(typeTitleTextField)
        contentView.addSubview(typeDescriptionTextField)
        view.addSubview(image)
        view.addSubview(label)
        removeView.addSubview(removeLabel)
        removeView.addSubview(removeImage)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        removeView.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        removeLabel.translatesAutoresizingMaskIntoConstraints = false
        removeImage.translatesAutoresizingMaskIntoConstraints = false
        addPointButton.translatesAutoresizingMaskIntoConstraints = false
        pointsTableView.translatesAutoresizingMaskIntoConstraints = false
        typeTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        typeDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // View Constraints
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.widthAnchor.constraint(equalToConstant: 90),
            view.heightAnchor.constraint(equalToConstant: 30),
            
            // RemoveView Constraints
            removeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            removeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeView.widthAnchor.constraint(equalToConstant: 95),
            removeView.heightAnchor.constraint(equalToConstant: 30),
            
            // Image Constraints
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.5),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: 12),
            image.heightAnchor.constraint(equalToConstant: 12),
            
            // Label Constraints
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
            
            // RemoveLabel Constraints
            removeLabel.topAnchor.constraint(equalTo: removeView.topAnchor, constant: 5),
            removeLabel.leadingAnchor.constraint(equalTo: removeView.leadingAnchor, constant: 15),
            removeLabel.trailingAnchor.constraint(equalTo: removeView.trailingAnchor, constant: -28),
            removeLabel.bottomAnchor.constraint(equalTo: removeView.bottomAnchor, constant: -5),
            
            // RemoveImage Constraints
            removeImage.topAnchor.constraint(equalTo: removeView.topAnchor, constant: 8),
            removeImage.leadingAnchor.constraint(equalTo: removeLabel.trailingAnchor, constant: 5),
            removeImage.trailingAnchor.constraint(equalTo: removeView.trailingAnchor, constant: -10),
            removeImage.bottomAnchor.constraint(equalTo: removeView.bottomAnchor, constant: -7),
            
            // TypeTitleTextField Constraints
            typeTitleTextField.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 20),
            typeTitleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeTitleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeTitleTextField.heightAnchor.constraint(equalToConstant: 80),
            
            // TypedescriptionTextField Constraints
            typeDescriptionTextField.topAnchor.constraint(equalTo: typeTitleTextField.bottomAnchor, constant: 7),
            typeDescriptionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            typeDescriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeDescriptionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // PointsLabel Constraints
            pointsLabel.topAnchor.constraint(equalTo: typeDescriptionTextField.bottomAnchor, constant: 23),
            pointsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pointsLabel.widthAnchor.constraint(equalToConstant: 50),
            pointsLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // AddPointButton Constraints
            addPointButton.topAnchor.constraint(equalTo: typeDescriptionTextField.bottomAnchor, constant: 23),
            addPointButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addPointButton.widthAnchor.constraint(equalToConstant: 80),
            addPointButton.heightAnchor.constraint(equalToConstant: 20),
            
            // PointsTableView Constraints
            pointsTableView.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 2),
            pointsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            pointsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pointsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // View Properties
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 6
        
        // removeView Properties
        removeLabel.title = "Remove"
        removeImage.tintColor = .black
        removeView.layer.borderWidth = 1
        removeView.layer.cornerRadius = 6
        removeView.backgroundColor = .white
        if #available(iOS 13.0, *) {
            removeImage.image = UIImage(systemName: "minus.circle")
        } else {
            // Fallback on earlier versions
        }
        removeLabel.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        removeView.layer.borderColor = UIColor(hexString: "#E2E3E7")?.cgColor
        
        // Sets image border
        image.layer.cornerRadius = 6
        
        // Sets label border
        label.borderWidth = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        // textFields Properties
        typeDescriptionTextField.backgroundColor = .white
        typeTitleTextField.textField.backgroundColor = .white
        typeTitleTextField.textField.placeholder = "Type title"
        typeDescriptionTextField.placeholder = "Type description"
        typeTitleTextField.topLabel.labelText = "Title & Description"
        
        pointsLabel.labelText = "Points"
        pointsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        // Sets addPointButton border and target
        addPointButton.borderWidth = 0
        addPointButton.setTitle("Add Point +", for: .normal)
        addPointButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        addPointButton.setTitleColor(UIColor(hexString: "#256FFF"), for: .normal)
        
        // pointTableView Properties
        pointsTableView.delegate = self
        pointsTableView.dataSource = self
        pointsTableView.separatorStyle = .none
        pointsTableView.backgroundColor = .clear
        pointsTableView.showsVerticalScrollIndicator = false
        pointsTableView.register(PointsTableViewCell.self, forCellReuseIdentifier: "PointsTableViewCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap(_:)))
        typeTitleTextField.textField.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap1(_:)))
        typeDescriptionTextField.addGestureRecognizer(tapGesture2)
        
        // Set edit fields visiblity on the basis of its display mode
        if chartDisplayMode == "readonly" {
            removeView.isHidden = true
            addPointButton.isHidden = true
            typeDescriptionTextField.isUserInteractionEnabled = false
            typeTitleTextField.textField.isUserInteractionEnabled = false
        } else {
            removeView.isHidden = false
            addPointButton.isHidden = false
            typeDescriptionTextField.isUserInteractionEnabled = true
            typeTitleTextField.textField.isUserInteractionEnabled = true
        }
    }
    
    // Action function for cellTextField
    @objc private func textFieldDidTap(_ gesture: UITapGestureRecognizer) {
        activeTextField = typeTitleTextField.textField
        typeTitleTextField.textField.becomeFirstResponder()
        textFieldDelegate?.textFieldCellDidSelect(self)
        cellTapGestureRecognizer?.isEnabled = false
    }
    
    // Action function for cellTextField
    @objc private func textFieldDidTap1(_ gesture: UITapGestureRecognizer) {
        activeTextField = typeDescriptionTextField
        typeDescriptionTextField.becomeFirstResponder()
        textFieldDelegate?.textFieldCellDidSelect(self)
        cellTapGestureRecognizer?.isEnabled = false
    }
    
    // Re-enable the collectionView cell's gesture recognizer
    func textFieldDidEndEditing(_ textField: UITextField) {
        cellTapGestureRecognizer?.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: TableView extention with tableView delegate methods
extension ChartLineTableViewCell: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView delegate method to give tableView section
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: TableView delegate method to give tableView rows
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yPointsData.count
    }
    
    // MARK: TableView delegate function to set cell inside tableView
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableViewCell", for: indexPath) as! PointsTableViewCell
        tableView.rowHeight = 120
        cell.textFieldDelegate = self
        cell.contentView.backgroundColor = UIColor(hexString: "#F9F9FB")
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteTapped(_:)), for: .touchUpInside)
        
        if yCoordinates[addPointButtonIndexPath].count == 1 {
            cell.verticalValueTF.text = "\(Int(yCoordinates[addPointButtonIndexPath][0]))"
        } else {
            cell.verticalValueTF.text = "\(Int(yCoordinates[addPointButtonIndexPath][indexPath.row]))"
        }
        if xCoordinates[addPointButtonIndexPath].count == 1 {
            cell.horizontalValueTF.text = "\(Int(xCoordinates[addPointButtonIndexPath][0]))"
        } else {
            cell.horizontalValueTF.text = "\(Int(xCoordinates[addPointButtonIndexPath][indexPath.row]))"
        }
        if graphLabelData[addPointButtonIndexPath].count == 1 {
            cell.labelTF.text = graphLabelData[addPointButtonIndexPath][0]
        } else {
            cell.labelTF.text = graphLabelData[addPointButtonIndexPath][indexPath.row]
        }
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.setupCell()
        return cell
    }
    
    // MARK: TableView delegate function called when cell is selected
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PointsTableViewCell
        cell?.contentView.backgroundColor = UIColor(hexString: "#F9F9FB")
    }
    
    // MARK: TextField delegate method for textField selection
    func textFieldCellDidSelect(_ cell: UITableViewCell) {
        guard let indexPath = pointsTableView.indexPath(for: cell) else {
            return
        }
        
        let tableCell = pointsTableView.cellForRow(at: indexPath) as? PointsTableViewCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let addPointButtonIndexPath = addPointButtonIndexPath
            
            // Check if addPointButtonIndexPath is within the valid range of arrays
            if addPointButtonIndexPath >= 0 && addPointButtonIndexPath < yCoordinates.count {
                if let verticalTextFieldText = tableCell?.verticalValueTF.text,
                   let verticalValue = NumberFormatter().number(from: verticalTextFieldText)?.doubleValue {
                    var yPointsData = yCoordinates[addPointButtonIndexPath]
                    yPointsData[indexPath.row] = CGFloat(verticalValue)
                    yCoordinates[addPointButtonIndexPath] = yPointsData
                }
            }
            if addPointButtonIndexPath >= 0 && addPointButtonIndexPath < xCoordinates.count {
                if let horizontalTextFieldText = tableCell?.horizontalValueTF.text,
                   let horizontalValue = NumberFormatter().number(from: horizontalTextFieldText)?.doubleValue {
                    var xPointsData = xCoordinates[addPointButtonIndexPath]
                    xPointsData[indexPath.row] = CGFloat(horizontalValue)
                    xCoordinates[addPointButtonIndexPath] = xPointsData
                }
            }
            if addPointButtonIndexPath >= 0 && addPointButtonIndexPath < graphLabelData.count {
                if let labelTextFieldText = tableCell?.labelTF.text {
                    var graphTextData = graphLabelData[addPointButtonIndexPath]
                    graphTextData[indexPath.row] = labelTextFieldText
                    graphLabelData[addPointButtonIndexPath] = graphTextData
                }
            }
            lineGraph.setNeedsDisplay()
        }
    }
    
    // Action function for deleteButton inside tableView cell
    @objc func deleteTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        // Check if it's the last row, and if so, do nothing
        if pointsTableView.numberOfRows(inSection: 0) == 1 {
            
        } else {
            yCoordinates[addPointButtonIndexPath].remove(at: indexPath.row)
            xCoordinates[addPointButtonIndexPath].remove(at: indexPath.row)
            graphLabelData[addPointButtonIndexPath].remove(at: indexPath.row)
            let graphYPointData = yCoordinates[addPointButtonIndexPath]
            yPointsData = graphYPointData
            let graphXPointData = xCoordinates[addPointButtonIndexPath]
            xPointsData = graphXPointData
            pointsTableView.reloadData()
            lineGraph.setNeedsDisplay()
        }
    }
}
