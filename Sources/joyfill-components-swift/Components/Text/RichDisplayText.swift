import Foundation
import UIKit

open class RichDisplayText: UITextView {
    
    private var textViewAlignment: NSTextAlignment = .left
    private var textViewText: String = "Hello World"
    private var scrollEnable: Bool = false
    
    //MARK: - Initializer
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDefaults()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setDefaults()
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
        self.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 10)
        borderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        fontSize = 14.0
        fontName = "Helvetica Neue"
        borderWidth = 1.0
        cornerRadius = 12
    }
}
