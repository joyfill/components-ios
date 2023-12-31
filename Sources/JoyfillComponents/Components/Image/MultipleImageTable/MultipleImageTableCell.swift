import Foundation
import UIKit

public class MultipleImageTableCell: UITableViewCell {
    let cellImageField = ImageView()
    let checkboxButton = Checkbox()
    
    public var imageIndexPath = Int()
    
    public var index = Int()
    public var multipleImages = [[String]]()
    
    var isSelectedCell: Bool = false {
        didSet {
            checkboxButton.isSelected = isSelectedCell
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImageField)
        contentView.addSubview(checkboxButton)
        
        cellImageField.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for the image view
        NSLayoutConstraint.activate([
            cellImageField.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            checkboxButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            checkboxButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11),
            checkboxButton.widthAnchor.constraint(equalToConstant: 23),
            checkboxButton.heightAnchor.constraint(equalToConstant: 23)
        ])
        setGlobalUserInterfaceStyle()
        cellImageField.contentModeValue = 0
        cellImageField.cornerRadius = 6
        
        checkboxButton.checkmarkStyle = .tick
        checkboxButton.borderStyle = .circle
        checkboxButton.center.y = contentView.center.y
        checkboxButton.borderLineWidth = 3
        checkboxButton.checkmarkColor = .white
        checkboxButton.borderCornerRadius = 10
        checkboxButton.uncheckedBorderColor = .white
        checkboxButton.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
