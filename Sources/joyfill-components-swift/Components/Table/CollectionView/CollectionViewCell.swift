import Foundation
import UIKit

// TextView protocol to get the selected indexPath
protocol TextViewCellDelegate: AnyObject {
    func textViewCellDidSelect(_ cell: UICollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    let image = ImageView()
    let countLabel = Label()
    var topBorder = UIView()
    let numberLabel = Label()
    var dropdownView = UIView()
    var bottomBorder = UIView()
    let selectionButton = Button()
    let dropdownImage = ImageView()
    let imageandCountView = UIView()
    let cellTextView = RichDisplayText()
    let verticalSeparatorView = UIView()
    let dropdownTextField = UITextField()
    let horizontalSeparatorView = UIView()
    weak var textViewDelegate: TextViewCellDelegate?
    var cellTapGestureRecognizer: UITapGestureRecognizer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSeparator()
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSeparator()
    }
    
    // Rows and Columns separator for table
    func setupSeparator() {
        contentView.addSubview(verticalSeparatorView)
        contentView.addSubview(horizontalSeparatorView)
        
        verticalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        horizontalSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            verticalSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalSeparatorView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        verticalSeparatorView.backgroundColor = UIColor(hexString: "#E6E7EA")
        horizontalSeparatorView.backgroundColor = UIColor(hexString: "#E6E7EA")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewDidTap(_:)))
        cellTextView.addGestureRecognizer(tapGesture)
        selectionButton.setImage(UIImage(named: "unSelectButton"), for: .normal)
    }
    
    // Function to add selectionButton in contentView
    func setupSelectionButton() {
        contentView.addSubview(selectionButton)
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectionButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionButton.heightAnchor.constraint(equalToConstant: 37.5)
        ])
    }
    
    // Function to add numberLabel in contentView
    func setupNumberLabel() {
        contentView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            numberLabel.heightAnchor.constraint(equalToConstant: 36.5)
        ])
        numberLabel.textAlignment = .center
        numberLabel.fontSize = 12
    }
    
    // Function to add textView in contentView
    func setupTextView() {
        contentView.addSubview(cellTextView)
        cellTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cellTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -1),
            cellTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
        cellTextView.layer.borderWidth = 0
        cellTextView.showsVerticalScrollIndicator = false
        cellTextView.font = UIFont.systemFont(ofSize: 12)
        cellTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 5, right: 8)
    }
    
    // Function to add dropdown in contentView
    func setupDropdown() {
        contentView.addSubview(dropdownView)
        dropdownView.addSubview(dropdownImage)
        dropdownView.addSubview(dropdownTextField)
        
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        dropdownImage.translatesAutoresizingMaskIntoConstraints = false
        dropdownTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropdownView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dropdownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dropdownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dropdownView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dropdownTextField.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 6),
            dropdownTextField.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 10),
            dropdownTextField.trailingAnchor.constraint(equalTo: dropdownImage.leadingAnchor, constant: -5),
            dropdownTextField.heightAnchor.constraint(equalToConstant: 25),
            
            dropdownImage.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 10),
            dropdownImage.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: -10),
            dropdownImage.heightAnchor.constraint(equalToConstant: 16),
            dropdownImage.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        dropdownTextField.layer.borderWidth = 0
        dropdownTextField.font = UIFont.systemFont(ofSize: 12)
        dropdownTextField.isUserInteractionEnabled = false
        
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "chevron.down", withConfiguration: boldConfig)
            dropdownImage.image = boldSearch
            dropdownImage.image = UIImage(systemName: "chevron.down")
        } else {
            // Fallback on earlier versions
        }
        dropdownImage.tintColor = .black
        dropdownView.isUserInteractionEnabled = false
    }
    
    // Action function for textView
    @objc private func textViewDidTap(_ gesture: UITapGestureRecognizer) {
        cellTextView.becomeFirstResponder()
        textViewDelegate?.textViewCellDidSelect(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        cellTapGestureRecognizer?.isEnabled = true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
