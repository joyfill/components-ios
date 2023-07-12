import Foundation
import UIKit

// TextField protocol to get the selected indexPath
protocol TextFieldCellDelegate: AnyObject {
    func textFieldCellDidSelect(_ cell: UICollectionViewCell)
}

// TextView protocol to get the selected indexPath
protocol TextViewCellDelegate: AnyObject {
    func textViewCellDidSelect(_ cell: UICollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    let image = ImageView()
    let countLabel = Label()
    var topBorder = UIView()
    let numberLabel = Label()
    let dropdownView = UIView()
    var bottomBorder = UIView()
    let selectionButton = Button()
    let dropdownImage = ImageView()
    let cellTextField = TextField()
    let imageandCountView = UIView()
    let textView = RichDisplayText()
    let verticalSeparatorView = UIView()
    let dropdownTextField = UITextField()
    let horizontalSeparatorView = UIView()
    weak var textFieldDelegate: TextFieldCellDelegate?
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidTap(_:)))
        cellTextField.addGestureRecognizer(tapGesture)
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(textViewDidTap(_:)))
        textView.addGestureRecognizer(tapGesture2)
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
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -1),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
        textView.layer.borderWidth = 0
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 12)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 22, bottom: 5, right: 20)
    }
    
    // Function to add textField in contentView
    func setupTextField() {
        contentView.addSubview(cellTextField)
        cellTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.5),
            cellTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0.5)
        ])
    }
    
    // Function to add imageView in contentView
    func setupImageView() {
        contentView.addSubview(imageandCountView)
        imageandCountView.addSubview(image)
        imageandCountView.addSubview(countLabel)

        image.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        imageandCountView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageandCountView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageandCountView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageandCountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageandCountView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            image.topAnchor.constraint(equalTo: imageandCountView.topAnchor, constant: 6),
            image.leadingAnchor.constraint(equalTo: imageandCountView.leadingAnchor, constant: 45),
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalToConstant: 24),
            
            countLabel.topAnchor.constraint(equalTo: imageandCountView.topAnchor, constant: 6),
            countLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 1),
            countLabel.trailingAnchor.constraint(equalTo: imageandCountView.trailingAnchor, constant: -2),
            countLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        countLabel.fontSize = 12
        countLabel.textColor = UIColor(hexString: "#6B6C7C")
        countLabel.labelText = "+4"
        image.image = UIImage(named: "Img_box_fill")
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
            dropdownTextField.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 35),
            dropdownTextField.heightAnchor.constraint(equalToConstant: 25),
            dropdownTextField.widthAnchor.constraint(equalToConstant: 65),
            
            dropdownImage.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 10),
            dropdownImage.leadingAnchor.constraint(equalTo: dropdownTextField.trailingAnchor, constant: 1),
            dropdownImage.heightAnchor.constraint(equalToConstant: 16),
            dropdownImage.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        dropdownTextField.layer.borderWidth = 0
        dropdownTextField.text = "Text 1 at 2"
        dropdownTextField.font = UIFont.boldSystemFont(ofSize: 12)
        dropdownTextField.isUserInteractionEnabled = false
        let attributedString = NSMutableAttributedString(string: dropdownTextField.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        dropdownTextField.attributedText = attributedString
        
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "chevron.down", withConfiguration: boldConfig)
            dropdownImage.image = boldSearch
            
            dropdownImage.image = UIImage(systemName: "chevron.down")
        } else {
            // Fallback on earlier versions
        }
        dropdownImage.tintColor = .black
        dropdownView.isUserInteractionEnabled = true
    }
    
    // Action function for cellTextField
    @objc private func textFieldDidTap(_ gesture: UITapGestureRecognizer) {
        cellTextField.becomeFirstResponder()
        textFieldDelegate?.textFieldCellDidSelect(self)
        cellTapGestureRecognizer?.isEnabled = false
    }
    
    // Action function for textView
    @objc private func textViewDidTap(_ gesture: UITapGestureRecognizer) {
        textViewDelegate?.textViewCellDidSelect(self)
    }
    
    // Re-enable the collectionView cell's gesture recognizer
    func textFieldDidEndEditing(_ textField: UITextField) {
        cellTapGestureRecognizer?.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        cellTapGestureRecognizer?.isEnabled = true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}
