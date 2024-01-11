import Foundation
import UIKit

protocol UpdateDateTimeFieldBorderOnBlur {
    func updateBorderOnBlur()
}

public class DateTime: UIView, UITextFieldDelegate, UpdateDateTimeFieldBorderOnBlur {
    
    public var dateLabel = String()
    public var titleLabel = UILabel()
    public var dateTimeView = UIView()
    public var toolTipTitle = String()
    public var dateTimeField = UITextField()
    public var datePickerButton = UIButton()
    public var toolTipDescription = String()
    public var toolTipIconButton = UIButton()

    var index = Int()
    var format = String()
    var saveDelegate: SaveTextFieldValue? = nil
    weak var textViewDelegate: TextViewCellDelegate?
    
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
            dateTimeView.backgroundColor = .white
            dateTimeField.backgroundColor = .white
            dateTimeField.isUserInteractionEnabled = true
            datePickerButton.addTarget(self, action: #selector(openDatePicker), for: .touchDown)
            let tap = UIGestureRecognizer(target: self, action: #selector(openDatePicker))
            dateTimeField.addGestureRecognizer(tap)
        } else {
            dateTimeView.backgroundColor = UIColor(hexString: "#F5F5F5")
            dateTimeField.backgroundColor = UIColor(hexString: "#F5F5F5")
            dateTimeField.isUserInteractionEnabled = false
        }
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    func setupUI() {
        addSubview(titleLabel)
        addSubview(toolTipIconButton)
        addSubview(dateTimeView)
        dateTimeView.addSubview(dateTimeField)
        dateTimeView.addSubview(datePickerButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        dateTimeView.translatesAutoresizingMaskIntoConstraints = false
        dateTimeField.translatesAutoresizingMaskIntoConstraints = false
        datePickerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Title
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            //view
            dateTimeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
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
        
        setGlobalUserInterfaceStyle()
        
        dateTimeField.delegate = self
        titleText = "Date Time"
        titleTextColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon", in: .module, compatibleWith: nil), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        dateTimeBorderWidth = 1
        
        dateTimeCornerRadius = 12
        dateTimeFieldTextFontSize = 12
        dateTimeBorderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        
        dateTimeFieldIconColor = .black
        dateTimePlacholder = "MMMM d, yyyy h:mm a"
        datePickerButton.setImage(UIImage(named: "Date_today", in: .module, compatibleWith: nil), for: .normal)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
    
    // Function to open datePicker
    @objc func openDatePicker() {
        datePickerUI()
        RPicker.sharedInstance.index = self.index
        RPicker.sharedInstance.dateTimeDelegate = self
        RPicker.sharedInstance.saveDelegate = self.saveDelegate
        saveDelegate?.handleFocus(index: index)
        dateTimeView.layer.borderWidth = 2
        dateTimeView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    public func datePickerUI () {
        if format == "MM/DD/YYYY" {
            let dateTime = dateTimeField.text ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            if let dateFromString = dateFormatter.date(from: dateTime) {
                RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .date, selectedDate: dateFromString, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
                    self?.selectedDate(date: selectedDate.dateString("MMMM d, yyyy"))
                    let timestampMilliseconds = dateToTimestampMilliseconds(date: selectedDate)
                    self?.dateTimeUpadte(timestampMilliseconds: timestampMilliseconds)
                    self?.saveDelegate?.handleFieldChange(text: timestampMilliseconds as Any, isEditingEnd: true, index: self?.index ?? 0)
                })
            }else {
                dateTimeSelect(dateFormat: "MMMM d, yyyy", datePickerMode : .date)
            }
        } else if format == "hh:mma" {
            let dateTime = dateTimeField.text ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            if let dateFromString = dateFormatter.date(from: dateTime) {
                RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .time, selectedDate: dateFromString, style: .Wheel, didSelectDate: {[weak self] (selectedDate) in
                    self?.selectedDate(date: selectedDate.dateString("hh:mm a"))
                    let timestampMilliseconds = dateToTimestampMilliseconds(date: selectedDate)
                    self?.dateTimeUpadte(timestampMilliseconds: timestampMilliseconds)
                    self?.saveDelegate?.handleFieldChange(text: timestampMilliseconds as Any, isEditingEnd: true, index: self?.index ?? 0)
                })
            }else {
                RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .time, style: .Wheel, didSelectDate: {[weak self] (selectedDate) in
                    self?.selectedDate(date: selectedDate.dateString("hh:mm a"))
                    let timestampMilliseconds = dateToTimestampMilliseconds(date: selectedDate)
                    self?.dateTimeUpadte(timestampMilliseconds: timestampMilliseconds)
                    self?.saveDelegate?.handleFieldChange(text: timestampMilliseconds as Any, isEditingEnd: true, index: self?.index ?? 0)
                })
            }
        } else {
            let dateTime = dateTimeField.text ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
            if let dateFromString = dateFormatter.date(from: dateTime) {
                RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: .dateAndTime, selectedDate: dateFromString, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
                    self?.selectedDate(date: selectedDate.dateString("MMMM d, yyyy h:mm a"))
                    let timestampMilliseconds = dateToTimestampMilliseconds(date: selectedDate)
                    self?.dateTimeUpadte(timestampMilliseconds: timestampMilliseconds)
                    self?.saveDelegate?.handleFieldChange(text: timestampMilliseconds as Any, isEditingEnd: true, index: self?.index ?? 0)
                })
            } else {
                dateTimeSelect(dateFormat: "MMMM d, yyyy h:mm a", datePickerMode : .dateAndTime)
            }
        }
    }
    
    func dateTimeSelect(dateFormat: String, datePickerMode:UIDatePicker.Mode = .date) {
        RPicker.selectDate(title: "Select Date", cancelText: "Cancel", datePickerMode: datePickerMode, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
            self?.selectedDate(date: selectedDate.dateString(dateFormat))
            let timestampMilliseconds = dateToTimestampMilliseconds(date: selectedDate)
            self?.dateTimeUpadte(timestampMilliseconds: timestampMilliseconds)
            self?.saveDelegate?.handleFieldChange(text: timestampMilliseconds as Any, isEditingEnd: true, index: self?.index ?? 0)
        })
    }
    
    // Update updated value in the joyDoc
    func dateTimeUpadte(timestampMilliseconds: Int) {
        let value = joyDocFieldData[self.index].value
        switch value {
        case .string: break
        case .integer:
            joyDocFieldData[self.index].value = ValueUnion.integer(timestampMilliseconds)
        case .valueElementArray(_): break
        case .array(_): break
        case .none:
            joyDocFieldData[self.index].value = ValueUnion.integer(timestampMilliseconds)
        case .some(.null): break
        }
        
        if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
            let modelValue = joyDocStruct?.fields?[index].value
            switch modelValue {
            case .string: break
            case .integer:
                joyDocStruct?.fields?[index].value = ValueUnion.integer(timestampMilliseconds)
            case .valueElementArray(_): break
            case .array(_): break
            case .none:
                joyDocStruct?.fields?[index].value = ValueUnion.integer(timestampMilliseconds)
            case .some(.null): break
            }
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        dateTimeView.layer.borderWidth = 2
        dateTimeView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        dateTimeView.layer.borderWidth = 1
        dateTimeView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        saveDelegate?.handleFieldChange(text: textField.text ?? "", isEditingEnd: true, index: index)
    }
    
    // Set selected date and time in textField
    public func selectedDate(date: String) {
        dateLabel = date
        dateTimeField.text = dateLabel
    }
    
    func updateBorderOnBlur() {
        dateTimeView.layer.borderWidth = 1
        dateTimeView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
    }
}
