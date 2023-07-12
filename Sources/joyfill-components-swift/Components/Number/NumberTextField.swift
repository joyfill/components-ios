import Foundation
import UIKit

public class NumberField: UIView, UITextFieldDelegate {
    
    public var view = UIView()
    public var titleLbl = UILabel()
    public var numberField = UITextField()
    public var currentPage : Int = 0
    public let button = UIButton(type: .custom)
    public let button1 = UIButton(type: .custom)
    public let stackView = UIStackView()
    
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
    
    @IBInspectable
    open var numberFieldUpIcon = UIColor.black {
        didSet {
            button.tintColor = numberFieldUpIcon
        }
    }
    
    @IBInspectable
    open var numberFieldDownIcon = UIColor.black {
        didSet {
            button1.tintColor = numberFieldDownIcon
        }
    }
    
    func setupUI () {
        addSubview(titleLbl)
        addSubview(view)
        view.addSubview(numberField)
        view.addSubview(stackView)
        stackView.addSubview(button)
        stackView.addSubview(button1)
        
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        numberField.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLbl.topAnchor.constraint(equalTo: self.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            titleLbl.heightAnchor.constraint(equalToConstant: 17),
            
            // view
            view.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 13),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            view.heightAnchor.constraint(equalToConstant: 50),
            
            // NumberFiield
            numberField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            numberField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            numberField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            numberField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            // StackView
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalToConstant: 30),
            
            // Up Button
            button.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            button.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 3),
            button.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -3),
            button.heightAnchor.constraint(equalToConstant: 20),
            
            // Down Button
            button1.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 3),
            button1.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -3),
            button1.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -5),
            button1.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Title UI
        self.titleLbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.titleText = "Number"
        self.titleTextColor = .black
        
        // View UI
        self.numberViewBorderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        self.numberViewBorderWidth = 1.0
        self.numberViewCornerRadius = 12
        
        // Text Field UI
        self.numberFieldTextSize = 14
        self.numberFieldPlacholder = "Building Count"
        
        // Up Button UI Set
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        button.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "chevron.up", withConfiguration: boldConfig)
            button.setImage(boldSearch, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        // Down Button UI Set
        button1.tintColor = .black
        button1.addTarget(self, action: #selector(self.downNumber), for: .touchUpInside)
        button1.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "chevron.down", withConfiguration: boldConfig)
            button1.setImage(boldSearch, for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.currentPage += 1
        self.numberField.text = String(currentPage)
        let text = self.numberField.text
        currentPage = Int(text!) ?? 0
    }
    
    @IBAction func downNumber(_ sender: Any) {
        self.currentPage -= 1
        self.numberField.text = String(currentPage)
        let text = self.numberField.text
        currentPage = Int(text!) ?? 0
    }
}
