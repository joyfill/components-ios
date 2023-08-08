import Foundation
import UIKit

public class Dropdown : UIView, DropDownSelectText, UITextFieldDelegate {
    
    public var titleLbl = UILabel()
    public var viewTextField = UIView()
    public var textField = UITextField()
    public var button = UIButton()
    public var doneHide = ""
    public var dropdownOptionArray: NSArray = ["Yes","No","N/A"]
    
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
    }
    
    func setupUI () {
        
        addSubview(titleLbl)
        addSubview(viewTextField)
        viewTextField.addSubview(textField)
        viewTextField.addSubview(button)
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        viewTextField.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Title
            titleLbl.topAnchor.constraint(equalTo: self.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLbl.heightAnchor.constraint(equalToConstant: 17),
            
            //view
            viewTextField.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 13),
            viewTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            viewTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            viewTextField.heightAnchor.constraint(equalToConstant: 50),
            
            //TextFiield
            textField.topAnchor.constraint(equalTo: viewTextField.topAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: viewTextField.bottomAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: viewTextField.leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
            
            //Button
            button.topAnchor.constraint(equalTo: viewTextField.topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: viewTextField.bottomAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: viewTextField.trailingAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        self.titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.titleText = "Drop Down"
        self.titleTextColor = .black
        
        self.dropdownCornerRadius = 12
        self.dropdownBorderWidth = 1.0
        self.dropdownBorderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        
        textField.delegate = self
        textField.font = UIFont(name: "Helvetica Neue", size: 14)
        self.dropdownPlaceholder = "Select option"
        let tap = UITapGestureRecognizer(target: self, action: #selector(dropdownOpen))
        textField.addGestureRecognizer(tap)
        textField.isUserInteractionEnabled = true
        
        if #available(iOS 13.0, *) {
            
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "chevron.down", withConfiguration: boldConfig)
            button.setImage(boldSearch, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.addTarget(self, action: #selector(dropdownOpen), for: .touchUpInside)
        button.tintColor = .gray
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //Drop Down CornerRadius
    @IBInspectable
    open var dropdownCornerRadius: CGFloat = 10 {
        didSet {
            viewTextField.layer.cornerRadius = dropdownCornerRadius
        }
    }
    
    @IBInspectable
    open var dropdownBorderWidth: CGFloat = 1 {
        didSet {
            viewTextField.layer.borderWidth = dropdownBorderWidth
        }
    }
    
    @IBInspectable
    open var dropdownBorderColor: UIColor = UIColor.gray {
        didSet {
            viewTextField.layer.borderColor = dropdownBorderColor.cgColor
        }
    }
    
    //DateTime View backgroundColor
    @IBInspectable
    open var dropdownBackgroundColor: UIColor? {
        didSet {
            viewTextField.layer.backgroundColor = dropdownBackgroundColor?.cgColor
        }
    }
    
    //Title
    @IBInspectable
    public var titleBackgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = titleBackgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    public var titleText : String? {
        didSet {
            titleLbl.text = titleText
        }
    }
    
    @IBInspectable
    public var titleTextColor : UIColor = .black {
        didSet {
            titleLbl.textColor = titleTextColor
        }
    }
    
    @IBInspectable
    open var titleFontBold : CGFloat = 17 {
        didSet {
            titleLbl.font = UIFont.boldSystemFont(ofSize: titleFontBold)
        }
    }
    
    @IBInspectable
    open var titleFontSize : CGFloat = 17 {
        didSet {
            titleLbl.font = UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    @IBInspectable
    public var titleFontItalic : CGFloat = 17 {
        didSet {
            titleLbl.font = UIFont.italicSystemFont(ofSize: titleFontItalic)
        }
    }
    
    @IBInspectable
    open var titleFontName: String = "Helvetica Neue" {
        didSet {
            titleLbl.font = UIFont(name: titleFontName, size: titleFontBold)
            
        }
    }
    
    //Placeholder
    @IBInspectable
    public var dropdownPlaceholder = "Select option" {
        didSet {
            textField.placeholder = dropdownPlaceholder
        }
    }
    
    @IBInspectable
    public var dropdownFieldFontBold : CGFloat = 15 {
        didSet {
            textField.font = UIFont.boldSystemFont(ofSize: dropdownFieldFontBold)
        }
    }
    
    @IBInspectable
    public var dropdownFieldFontItalic : CGFloat = 15 {
        didSet {
            textField.font = UIFont.italicSystemFont(ofSize: dropdownFieldFontItalic)
        }
    }
    
    @IBInspectable
    open var dropdownFieldFontName: String = "Helvetica Neue" {
        didSet {
            textField.font = UIFont(name: dropdownFieldFontName, size: dropdownFieldFontBold)
        }
    }
    
    func selectText(text: String) {
        if doneHide == "singleSelect" {
            print(text)
            textField.text = text
            viewTextField.layer.cornerRadius = 12
            viewTextField.layer.borderColor = UIColor(hexString: "#4776EE")?.cgColor
            viewTextField.layer.borderWidth = 1
        } else {
            print(text)
            textField.text = "Select \(text)"
            viewTextField.layer.cornerRadius = 12
            viewTextField.layer.borderColor = UIColor(hexString: "#4776EE")?.cgColor
            viewTextField.layer.borderWidth = 1
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        
        while let currentResponder = responder {
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
            responder = currentResponder.next
        }
        
        return nil
    }
    
    @IBAction func dropdownOpen(_ sender: Any) {
        print("Click")
        guard let viewController = self.findViewController() else {
            return
        }
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        vc.doneHide = doneHide
        vc.dropdownOptionArray = dropdownOptionArray
        // keep false
        // modal animation will be handled in VC itself
        viewController.present(vc, animated: false)
    }
}