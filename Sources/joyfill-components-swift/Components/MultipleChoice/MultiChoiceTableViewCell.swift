import Foundation
import UIKit

public class MultiChoiceTableViewCell: UITableViewCell {
    
    var cellLabel = UILabel()
    var myCheckbox = Checkbox()
    var underLine = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // SubViews
        contentView.addSubview(myCheckbox)
        contentView.addSubview(cellLabel)
        contentView.addSubview(underLine)
        
        myCheckbox.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        underLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //myCheckbox Constraints
            myCheckbox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            myCheckbox.widthAnchor.constraint(equalToConstant: 18),
            myCheckbox.heightAnchor.constraint(equalToConstant: 18),
            myCheckbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //cellLabel Constraints
            cellLabel.leadingAnchor.constraint(equalTo: myCheckbox.trailingAnchor, constant: 15),
            cellLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            //underLine Constraints
            underLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            underLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        myCheckbox.checkmarkStyle = .tick
        myCheckbox.borderStyle = .square
        myCheckbox.borderCornerRadius = 5
        myCheckbox.borderLineWidth = 0.5
        myCheckbox.checkmarkColor = .white
        myCheckbox.uncheckedBorderColor = .gray
        myCheckbox.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
 
        cellLabel.numberOfLines = 0
        cellLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        underLine.backgroundColor = UIColor(hexString: "#E2E3E7")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
