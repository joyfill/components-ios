import Foundation
import UIKit

public class NumberField: UIView, UITextFieldDelegate {
    
    public var view = UIView()
    public var titleLbl = Label()
    public var toolTipTitle = String()
    public var numberField = UITextField()
    public var toolTipDescription = String()
    public var toolTipIconButton = UIButton()
    
    var index = Int()
    public var currentPage : Int = 0
    var saveDelegate: SaveTextFieldValue? = nil
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
        numberField.delegate = self
    }
    
    // Number View CornerRadius
    @IBInspectable
    open var numberViewCornerRadius: CGFloat = 20 {
        didSet {
            view.layer.cornerRadius = numberViewCornerRadius
        }
    }
    
    @IBInspectable
    open var numberViewBorderWidth: CGFloat = 1 {
        didSet {
            view.layer.borderWidth = numberViewBorderWidth
        }
    }
    
    @IBInspectable
    open var numberViewBorderColor: UIColor = UIColor.gray {
        didSet {
            view.layer.borderColor = numberViewBorderColor.cgColor
        }
    }
    
    // Number View backgroundColor
    @IBInspectable
    open var numberViewBackgroundColor: UIColor? {
        didSet {
            view.layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    // Title
    @IBInspectable
    public var titleBackgroundColor: UIColor? {
        didSet {
            titleLbl.layer.backgroundColor = titleBackgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    public var titleText : String? {
        didSet {
            titleLbl.text = titleText
        }
    }
    
    @IBInspectable
    public var titleFontBold : CGFloat = 17 {
        didSet {
            titleLbl.font = UIFont.boldSystemFont(ofSize: titleFontBold)
        }
    }
    
    @IBInspectable
    public var titleFontItalic : CGFloat = 17 {
        didSet {
            titleLbl.font = UIFont.italicSystemFont(ofSize: titleFontItalic)
        }
    }
    
    @IBInspectable
    open var titlefontName: String = "Helvetica" {
        didSet {
            titleLbl.font = UIFont(name: titlefontName, size: titleFontBold)
        }
    }
    
    @IBInspectable
    public var titleTextColor : UIColor = .black {
        didSet {
            titleLbl.textColor = titleTextColor
        }
    }
    
    // Placeholder
    @IBInspectable
    public var numberFieldPlacholder = "Building count" {
        didSet {
            numberField.placeholder = numberFieldPlacholder
        }
    }
    
    @IBInspectable
    public var numberFieldTextColor = UIColor.black {
        didSet {
            numberField.textColor = numberFieldTextColor
        }
    }
    
    @IBInspectable
    public var numberFieldTextSize : CGFloat = 17 {
        didSet {
            numberField.font = UIFont.systemFont(ofSize: numberFieldTextSize)
        }
    }
    
    @IBInspectable
    public var numberFieldFontBold : CGFloat = 17 {
        didSet {
            numberField.font = UIFont.boldSystemFont(ofSize: numberFieldFontBold)
        }
    }
    
    @IBInspectable
    public var numberFieldFontItalic : CGFloat = 17 {
        didSet {
            numberField.font = UIFont.italicSystemFont(ofSize: numberFieldFontItalic)
        }
    }
    
    @IBInspectable
    open var numberFieldFontName: String = "Helvetica Neue" {
        didSet {
            numberField.font = UIFont(name: numberFieldFontName, size: numberFieldFontBold)
        }
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    func setupUI () {
        addSubview(titleLbl)
        addSubview(toolTipIconButton)
        addSubview(view)
        view.addSubview(numberField)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        numberField.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLbl.topAnchor.constraint(equalTo: self.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLbl.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLbl.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // View
            view.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 13),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            view.heightAnchor.constraint(equalToConstant: 50),
            
            // NumberFiield
            numberField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            numberField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            numberField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            numberField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        if #available(iOS 13.0, *) {
         self.overrideUserInterfaceStyle = .light
        }
        
        // Title label properties
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleTextColor = .black
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        numberViewBorderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        numberViewBorderWidth = 1.0
        numberViewCornerRadius = 12
        
        numberFieldTextSize = 14
        numberField.keyboardType = .numberPad
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        saveDelegate?.handleFieldChange(text: textField.text ?? "", isEditingEnd: true, index: index)
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
