import Foundation
import UIKit

public class MultiChoiceTableViewCell: UITableViewCell {
    
    var underLine = UIView()
    var cellLabel = UILabel()
    var cellCheckbox = Checkbox()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // SubViews
        contentView.addSubview(cellCheckbox)
        contentView.addSubview(cellLabel)
        contentView.addSubview(underLine)
        
        cellCheckbox.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        underLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //myCheckbox Constraints
            cellCheckbox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            cellCheckbox.widthAnchor.constraint(equalToConstant: 18),
            cellCheckbox.heightAnchor.constraint(equalToConstant: 18),
            cellCheckbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //cellLabel Constraints
            cellLabel.leadingAnchor.constraint(equalTo: cellCheckbox.trailingAnchor, constant: 15),
            cellLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //underLine Constraints
            underLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        setGlobalUserInterfaceStyle()
        cellCheckbox.checkmarkStyle = .tick
        cellCheckbox.borderStyle = .square
        cellCheckbox.borderCornerRadius = 5
        cellCheckbox.borderLineWidth = 0.5
        cellCheckbox.checkmarkColor = .white
        cellCheckbox.uncheckedBorderColor = .gray
        cellCheckbox.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        cellLabel.numberOfLines = 0
        cellLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        underLine.backgroundColor = UIColor(hexString: "#E2E3E7")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
