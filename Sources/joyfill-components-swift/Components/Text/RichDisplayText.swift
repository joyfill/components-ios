import Foundation
import UIKit

open class RichDisplayText: UITextView, UITextViewDelegate {
    
    private var textViewAlignment: NSTextAlignment = .left
    private var textViewText: String = "Hello World"
    private var scrollEnable: Bool = false
    
    var index = Int()
    var saveDelegate: SaveTextFieldValue? = nil
    
    //MARK: - Initializer
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDefaults()
        self.delegate = self
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setDefaults()
        self.delegate = self
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.darkGray.cgColor
        saveDelegate?.handleFocus(index: index)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        conditionToCallOnChange(textView: textView)
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        conditionToCallOnChange(textView: textView)
        saveDelegate?.handleBlur(index: index)
    }
    
    func conditionToCallOnChange(textView: UITextView) {
        let valueUnion = joyDocFieldData[index].value
        switch valueUnion {
        case .string(let stringValue):
            if let textFieldText = textView.text, stringValue != textFieldText {
                saveDelegate?.handleFieldChange(text: textView.text ?? "", isEditingEnd: true, index: index)
            }
        case .none:
            saveDelegate?.handleFieldChange(text: textView.text ?? "", isEditingEnd: true, index: index)
        default:
            break
        }
        richDisplayTextValueUpdate(textView: textView.text ?? "")
    }
    
    // Update updated value in the joyDoc
    func richDisplayTextValueUpdate(textView: String) {
        let value = joyDocFieldData[index].value
        switch value {
        case .string:
            joyDocFieldData[index].value = ValueUnion.string(textView)
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none:
            joyDocFieldData[index].value = ValueUnion.string(textView)
        case .some(.null): break
        }
        
        if let index = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
            let modelValue = joyDocStruct?.fields?[index].value
            switch modelValue {
            case .string:
                joyDocStruct?.fields?[index].value = ValueUnion.string(textView)
            case .integer(_): break
            case .valueElementArray(_): break
            case .array(_): break
            case .none:
                joyDocStruct?.fields?[index].value = ValueUnion.string(textView)
            case .some(.null): break
            }
        }
    }

    
    // A property that accesses the backing layer's background
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    // Sets border color of textView
    @IBInspectable
    open var borderColor: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Sets corner radius of textView
    @IBInspectable
    open var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Sets the scroll true/false of the textView
    @IBInspectable
    open override var isScrollEnabled: Bool {
        didSet {
            scrollEnable = isScrollEnabled
        }
    }
    
    // Sets the bold text of the textView
    @IBInspectable
    open var boldText: CGFloat = 17 {
        didSet {
            font = UIFont.boldSystemFont(ofSize: boldText)
        }
    }
    
    // Sets the italic text of the textView
    @IBInspectable
    open var italicText: CGFloat = 17 {
        didSet {
            font = UIFont.italicSystemFont(ofSize: italicText)
        }
    }
    
    // Sets border width of textView
    @IBInspectable
    open var borderWidth: CGFloat = 2 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Sets alignment of the text inside textView
    @IBInspectable
    open override var textAlignment: NSTextAlignment {
        didSet {
            textViewAlignment = textAlignment
        }
    }
    
    // Sets text of the textView
    @IBInspectable
    open override var text: String! {
        didSet {
            textViewText = text
        }
    }
    
    // Sets the fontName for the textView
    @IBInspectable
    open var fontName: String = "Helvetica Neue" {
        didSet {
            if let font = UIFont(name: fontName, size: fontSize) {
                self.font = font
            }
        }
    }
    
    // Sets the fontSize of the textView
    @IBInspectable
    open var fontSize: CGFloat = 17.0 {
        didSet {
            if let font = UIFont(name: fontName, size: fontSize) {
                self.font = font
            }
        }
    }

    // To give default value to the textView
    private func setDefaults() {
        setGlobalUserInterfaceStyle()
        self.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 10)
        borderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        fontSize = 14.0
        fontName = "Helvetica Neue"
        borderWidth = 1.0
        cornerRadius = 12
        tintColor = .blue
    }
}
