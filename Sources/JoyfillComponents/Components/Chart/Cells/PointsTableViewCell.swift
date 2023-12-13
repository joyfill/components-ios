import Foundation
import UIKit

public class PointsTableViewCell: UITableViewCell {
    
    public var labelTF = TextField()
    public var deleteButton = Button()
    public var lineSeparator = UIView()
    public var verticalValueTF = TextField()
    public var horizontalValueTF = TextField()
    public var textFieldStackView = UIStackView()
    
    var cellTapGestureRecognizer: UITapGestureRecognizer?
    weak var textFieldDelegate: ChartViewTextFieldCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        // SubViews
        contentView.addSubview(labelTF)
        contentView.addSubview(textFieldStackView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(lineSeparator)
        textFieldStackView.addArrangedSubview(horizontalValueTF)
        textFieldStackView.addArrangedSubview(verticalValueTF)
        
        labelTF.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        verticalValueTF.translatesAutoresizingMaskIntoConstraints = false
        horizontalValueTF.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // LabelTF constraint
            labelTF.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            labelTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            labelTF.heightAnchor.constraint(equalToConstant: 45),
            
            // ValueStackView constraint
            textFieldStackView.topAnchor.constraint(equalTo: labelTF.bottomAnchor, constant: 7),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            textFieldStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            // StackView TextField constraint
            horizontalValueTF.heightAnchor.constraint(equalTo: verticalValueTF.heightAnchor),
            horizontalValueTF.widthAnchor.constraint(equalTo: verticalValueTF.widthAnchor),
            
            // DeleteButton constraint
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 55),
            deleteButton.leadingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 22),
            
            // LineSeparator constraint
            lineSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            lineSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55),
            lineSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            lineSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        setGlobalUserInterfaceStyle()
        
        // StackView properties
        textFieldStackView.spacing = 5
        textFieldStackView.alignment = .fill
        textFieldStackView.axis = .horizontal
        textFieldStackView.distribution = .fillEqually
        lineSeparator.backgroundColor = UIColor(hexString: "#DBDCE0")
        
        // Set textField properties
        labelTF.placeholder = "Label"
        labelTF.backgroundColor = .white
        verticalValueTF.backgroundColor = .white
        horizontalValueTF.backgroundColor = .white
        verticalValueTF.placeholder = "Vertical value"
        horizontalValueTF.placeholder = "Horizontal value"
        labelTF.font = UIFont(name: "Helvetica Neue", size: 14)
        verticalValueTF.font = UIFont(name: "Helvetica Neue", size: 14)
        horizontalValueTF.font = UIFont(name: "Helvetica Neue", size: 14)
        
        // Set deleteButton image
        if #available(iOS 13.0, *) {
            deleteButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        deleteButton.tintColor = UIColor(hexString: "#FB4534")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap(_:)))
        verticalValueTF.addGestureRecognizer(tapGesture)
        
        let tapGestureForHorizontalTF = UITapGestureRecognizer(target: self, action: #selector(horizontalTextFieldDidTap(_:)))
        horizontalValueTF.addGestureRecognizer(tapGestureForHorizontalTF)
        
        let tapGestureForLabel = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTapForLabel(_:)))
        labelTF.addGestureRecognizer(tapGestureForLabel)
        
        // Keyboard type on vertical and horizontal coordinates
        verticalValueTF.keyboardType = .numberPad
        horizontalValueTF.keyboardType = .numberPad
        
        // Set edit fields visiblity on the basis of its display mode
        if chartDisplayMode == "readonly" {
            deleteButton.isHidden = true
            labelTF.isUserInteractionEnabled = false
            verticalValueTF.isUserInteractionEnabled = false
            horizontalValueTF.isUserInteractionEnabled = false
            labelTF.backgroundColor = UIColor(hexString: "#F5F5F5")
            verticalValueTF.backgroundColor = UIColor(hexString: "#F5F5F5")
            horizontalValueTF.backgroundColor = UIColor(hexString: "#F5F5F5")
        } else {
            deleteButton.isHidden = false
            labelTF.backgroundColor = .white
            labelTF.isUserInteractionEnabled = true
            verticalValueTF.backgroundColor = .white
            horizontalValueTF.backgroundColor = .white
            verticalValueTF.isUserInteractionEnabled = true
            horizontalValueTF.isUserInteractionEnabled = true
        }
    }
    
    // Action function for verticalTextField
    @objc private func textFieldDidTap(_ gesture: UITapGestureRecognizer) {
        activeTextField = verticalValueTF
        verticalValueTF.becomeFirstResponder()
        textFieldDelegate?.textFieldCellDidSelect(self)
        cellTapGestureRecognizer?.isEnabled = false
        if verticalValueTF.text == "0" {
            verticalValueTF.text = ""
        }
    }
    
    // Action function for verticalTextField
    @objc private func horizontalTextFieldDidTap(_ gesture: UITapGestureRecognizer) {
        activeTextField = horizontalValueTF
        horizontalValueTF.becomeFirstResponder()
        textFieldDelegate?.textFieldCellDidSelect(self)
        cellTapGestureRecognizer?.isEnabled = false
        if horizontalValueTF.text == "0" {
            horizontalValueTF.text = ""
        }
    }
    
    // Action function for labelTextField
    @objc private func textFieldDidTapForLabel(_ gesture: UITapGestureRecognizer) {
        activeTextField = labelTF
        labelTF.becomeFirstResponder()
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
