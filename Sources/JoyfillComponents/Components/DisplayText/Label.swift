import Foundation
import UIKit

public class Label: UILabel {
    
    private var labelTextColor: UIColor = .black
    private var collapsedNumberOfLines: Int = 0
    private var labelTextAlignment: NSTextAlignment = .left
    
    // Sets borderWidth of the label
    @IBInspectable
    open var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Sets the borderColor of the label
    @IBInspectable
    open var borderColor: UIColor = UIColor.gray {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Sets the corner radius of the label
    @IBInspectable
    open var borderCornerRadius: CGFloat = 2.0 {
        didSet {
            layer.cornerRadius = borderCornerRadius
        }
    }
    
    // Sets the textColor of the label
    @IBInspectable
    open override var textColor: UIColor! {
        didSet {
            labelTextColor = textColor
        }
    }
    
    // Sets the bold text of the label
    @IBInspectable
    open var boldText: CGFloat = 17 {
        didSet {
            font = UIFont.boldSystemFont(ofSize: boldText)
        }
    }
    
    // Sets the italic text of the label
    @IBInspectable
    open var italicText: CGFloat = 17 {
        didSet {
            font = UIFont.italicSystemFont(ofSize: italicText)
        }
    }
    
    // Sets text bold and italic both of the label
    @IBInspectable
    open var isTextBold: Bool = false {
        didSet {
            updateTitleLabelFont()
        }
    }

    @IBInspectable
    open var isTextItalic: Bool = false {
        didSet {
            updateTitleLabelFont()
        }
    }

    private func updateTitleLabelFont() {
        var fontTraits = UIFontDescriptor.SymbolicTraits()
        
        if isTextBold {
            fontTraits.insert(.traitBold)
        }
        if isTextItalic {
            fontTraits.insert(.traitItalic)
        }
        
        let fontDescriptor = UIFont.systemFont(ofSize: fontSize).fontDescriptor.withSymbolicTraits(fontTraits)
        font = UIFont(descriptor: fontDescriptor!, size: fontSize)
    }
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }
    
    public init() {
        super.init(frame: .zero)
        prepare()
    }
    
    // A property that accesses the backing layer's background
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    // Sets the text for button.
    @IBInspectable
    open var labelText: String? {
        didSet {
            text = labelText
        }
    }
    
    // A property that accesses the number of line of the label
    open override var numberOfLines: Int {
        didSet {
            collapsedNumberOfLines = numberOfLines
        }
    }
    
    // Sets the fontName for the label text
    @IBInspectable
    open var fontName: String = "Helvetica Neue" {
        didSet {
            if let font = UIFont(name: fontName, size: fontSize) {
                self.font = font
            }
        }
    }
    
    // Sets the fontSize of the label text
    @IBInspectable
    open var fontSize: CGFloat = 15.0 {
        didSet {
            if let font = UIFont(name: fontName, size: fontSize) {
                self.font = font
            }
        }
    }
    
    // A property that accesses the text alignment of the label
    @IBInspectable
    open override var textAlignment: NSTextAlignment {
        didSet {
            labelTextAlignment = textAlignment
        }
    }
    
    // Custom content insets
    @IBInspectable
    open var insets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open func prepare() {
        borderWidth = 0
        borderColor = .gray
        borderCornerRadius = 5
        textColor = .black
        labelText = "  Dummy Text"
    }
}
