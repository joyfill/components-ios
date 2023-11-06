import Foundation
import UIKit

class PageNavigationTableViewCell: UITableViewCell {
    
    var cellView = UIView()
    var cellLabel = UILabel()
    var cellCheckbox = Checkbox()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func setupCell() {
        // SubView
        contentView.addSubview(cellView)
        cellView.addSubview(cellCheckbox)
        cellView.addSubview(cellLabel)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellCheckbox.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellCheckbox.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            cellCheckbox.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 27),
            cellCheckbox.widthAnchor.constraint(equalToConstant: 18),
            cellCheckbox.heightAnchor.constraint(equalToConstant: 18),
            
            cellLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0),
            cellLabel.leadingAnchor.constraint(equalTo: cellCheckbox.trailingAnchor, constant: 17),
            cellLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 5),
            cellLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 0)
        ])
        
        cellCheckbox.borderLineWidth = 1
        cellCheckbox.borderStyle = .circle
        cellCheckbox.borderCornerRadius = 10
        cellCheckbox.checkmarkStyle = .circle
        cellCheckbox.uncheckedBorderColor = .gray
        cellCheckbox.checkmarkColor = UIColor(hexString: "#3767ED") ?? .lightGray
        
        cellLabel.numberOfLines = 0
        cellLabel.font = UIFont.boldSystemFont(ofSize: 12)
        cellView.backgroundColor = UIColor(hexString: "#F5F5F5")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
