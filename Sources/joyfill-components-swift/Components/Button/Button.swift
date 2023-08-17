import Foundation
import UIKit

open class Button: UIButton {
    
    public let visualLayer = CAShapeLayer()
    
    // A property that accesses the backing layer's background
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    // Sets the corner radius of the button
    @IBInspectable
    open var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // Sets the border of the button
    @IBInspectable
    open var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    open var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Sets the normal and highlighted image for the button.
    @IBInspectable
    open var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
            setImage(image, for: .selected)
            setImage(image, for: .highlighted)
            setImage(image, for: .disabled)
            
            if #available(iOS 9, *) {
                setImage(image, for: .application)
                setImage(image, for: .focused)
                setImage(image, for: .reserved)
            }
        }
    }
    
    // Sets the normal and highlighted title for the button.
    @IBInspectable
    open var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .selected)
            setTitle(title, for: .highlighted)
            setTitle(title, for: .disabled)
            
            if #available(iOS 9, *) {
                setTitle(title, for: .application)
                setTitle(title, for: .focused)
                setTitle(title, for: .reserved)
            }
            
            guard nil != title else {
                return
            }
            
            guard nil == titleColor else {
                return
            }
            titleColor = UIColor.black
        }
    }
    
    // Sets the normal and highlighted titleColor for the button.
    @IBInspectable
    open var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
            setTitleColor(titleColor, for: .highlighted)
            setTitleColor(titleColor, for: .disabled)
            
            if nil == selectedTitleColor {
                setTitleColor(titleColor, for: .selected)
            }
            
            if #available(iOS 9, *) {
                setTitleColor(titleColor, for: .application)
                setTitleColor(titleColor, for: .focused)
                setTitleColor(titleColor, for: .reserved)
            }
        }
    }
    
    // Sets the selected titleColor for the button.
    @IBInspectable
    open var selectedTitleColor: UIColor? {
        didSet {
            setTitleColor(selectedTitleColor, for: .selected)
        }
    }
    
    // MARK: Initializer
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // Set these here to avoid overriding storyboard values
        tintColor = UIColor.blue
        prepare()
    }
    
    // Initializer parameters image & tintColor
    public init(image: UIImage?, tintColor: UIColor? = nil) {
        super.init(frame: .zero)
        prepare()
        prepare(with: image, tintColor: tintColor)
    }
    
    // Initializer parameters title & titleColor
    public init(title: String?, titleColor: UIColor? = nil) {
        super.init(frame: .zero)
        prepare()
        prepare(with: title, titleColor: titleColor)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutVisualLayer()
    }
    
    open func bringImageViewToFront() {
        guard let v = imageView else {
            return
        }
        
        bringSubviewToFront(v)
    }

    open func prepare() {
        cornerRadius = 12
        prepareVisualLayer()
    }
}

extension Button {
    // Prepares the visualLayer property.
    fileprivate func prepareVisualLayer() {
        visualLayer.zPosition = 0
        visualLayer.masksToBounds = true
        layer.addSublayer(visualLayer)
    }
    
    
    // Prepares the Button with an image and tint
    fileprivate func prepare(with image: UIImage?, tintColor: UIColor?) {
        self.image = image
        self.tintColor = tintColor ?? self.tintColor
    }
    
    
    // Prepares the Button with a title and titleColor
    fileprivate func prepare(with title: String?, titleColor: UIColor?) {
        self.title = title ?? "Button"
        self.titleColor = titleColor ?? self.titleColor
    }
}

extension Button {
    // Manages the layout for the visualLayer property.
    fileprivate func layoutVisualLayer() {
        visualLayer.frame = bounds
        visualLayer.cornerRadius = 18.0
    }
}
