import Foundation
import UIKit

public class DateTime : UIView {
    
    public var dateLabel = String()
    public var titleLabel = UILabel()
    public var dateTimeView = UIView()
    public var dateTimeField = UITextField()
    public var datePickerButton = UIButton()
    
    // Set cornerRadius
    @IBInspectable
    open var dateTimeCornerRadius: CGFloat = 10 {
        didSet {
            dateTimeView.layer.cornerRadius = dateTimeCornerRadius
        }
    }
    
    // Set borderWidth
    @IBInspectable
    open var dateTimeBorderWidth: CGFloat = 1 {
        didSet {
            dateTimeView.layer.borderWidth = dateTimeBorderWidth
        }
    }
    
    // Set borderColor
    @IBInspectable
    open var dateTimeBorderColor: UIColor = UIColor.lightGray {
        didSet {
            dateTimeView.layer.borderColor = dateTimeBorderColor.cgColor
        }
    }
    
    // Set backgroundColor
    @IBInspectable
    open var dateTimeBackgroundColor: UIColor? {
        didSet {
            dateTimeView.layer.backgroundColor = dateTimeBackgroundColor?.cgColor
        }
    }
    
    // Set placeholder
    @IBInspectable
    public var dateTimePlacholder = "MM-dd-YYYY" {
        didSet {
            dateTimeField.placeholder = dateTimePlacholder
        }
    }
    
    // Set textColor
    @IBInspectable
    public var dateTimeFieldTextColor = UIColor.black {
        didSet {
            dateTimeField.textColor = dateTimeFieldTextColor
        }
    }
    
    // Set fontSize
    @IBInspectable
    public var dateTimeFieldTextFontSize : CGFloat = 17 {
        didSet {
            dateTimeField.font = UIFont.systemFont(ofSize: dateTimeFieldTextFontSize)
        }
    }
    
    // Set iconColor
    @IBInspectable
    public var dateTimeFieldIconColor = UIColor.black {
        didSet {
            datePickerButton.tintColor = dateTimeFieldIconColor
        }
    }
    
    // Set title
    @IBInspectable
    public var titleBackgroundColor: UIColor? {
        didSet {
            titleLabel.layer.backgroundColor = titleBackgroundColor?.cgColor
        }
    }
    
    // Set titleText
    @IBInspectable
    public var titleText : String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    // Set titleFontSize
    @IBInspectable
    public var titleFontSize : CGFloat = 17 {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    // Set titleFontStyle
    @IBInspectable
    open var titleFontBold : CGFloat = 17 {
        didSet {
            titleLabel.font = UIFont.boldSystemFont(ofSize: titleFontBold)
        }
    }
    
    // Set titleTextColor
    @IBInspectable
    public var titleTextColor : UIColor = .black {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    // Initializer
    public init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func dateTimeDisplayModes(mode : String) {
        if mode != "readonly" {
            dateTimeField.isUserInteractionEnabled = true
            [dateTimeField, datePickerButton].forEach { Button in
                Button.addTarget(self, action: #selector(openDatePicker), for: .touchDown)
            }
        } else {
            dateTimeField.isUserInteractionEnabled = false
        }
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(dateTimeView)
        dateTimeView.addSubview(dateTimeField)
        dateTimeView.addSubview(datePickerButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTimeView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeField.translatesAutoresizingMaskIntoConstraints = false
        datePickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Title
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            //view
            dateTimeView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            dateTimeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dateTimeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dateTimeView.heightAnchor.constraint(equalToConstant: 50),
            
            //TextFiield
            dateTimeField.topAnchor.constraint(equalTo: dateTimeView.topAnchor, constant: 0),
            dateTimeField.bottomAnchor.constraint(equalTo: dateTimeView.bottomAnchor, constant: 0),
            dateTimeField.leadingAnchor.constraint(equalTo: dateTimeView.leadingAnchor, constant: 20),
            dateTimeField.trailingAnchor.constraint(equalTo: datePickerButton.trailingAnchor, constant: -20),
            
            //Button
            datePickerButton.topAnchor.constraint(equalTo: dateTimeView.topAnchor, constant: 0),
            datePickerButton.bottomAnchor.constraint(equalTo: dateTimeView.bottomAnchor, constant: 0),
            datePickerButton.trailingAnchor.constraint(equalTo: dateTimeView.trailingAnchor, constant: -20),
            datePickerButton.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        titleText = "Date Time"
        titleTextColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        dateTimeBorderWidth = 1
        dateTimeCornerRadius = 12
        dateTimeFieldTextFontSize = 12
        dateTimeBorderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        
        dateTimeFieldIconColor = .black
        dateTimePlacholder = "MMMM d, yyyy h:mma"
        datePickerButton.setImage(UIImage(named: "Date_today"), for: .normal)
    }
    
    // Function to open datePicker
    @objc func openDatePicker() {
        datePickerUI()
    }
    
    public func datePickerUI () {
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .dateAndTime, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            self?.selectedDate(date: selectedDate.dateString("MMMM d, yyyy h:mma"))
        })
    }
    
    // Set selected date and time in textField
    public func selectedDate(date:String) {
        dateLabel = date
        dateTimeField.text = dateLabel
    }
}
