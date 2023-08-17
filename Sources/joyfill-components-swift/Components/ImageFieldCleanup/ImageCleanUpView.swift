import Foundation
import UIKit

public class ImageCleanUpView: UIImageView {
    
    public let visualLayer = CAShapeLayer()
    
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
    
    // Function to load image URL
    public func load(urlString: String) {
      guard let url = URL(string: urlString) else {
        return
      }
      DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url) {
          if let image = UIImage(data: data) {
            DispatchQueue.main.async {
              self?.image = image
            }
          }
        }
      }
    }
    
    // Sets the image for the imageView.
    @IBInspectable
    open var imageString: String? {
        didSet {
            image = UIImage(named: imageString ?? "")
        }
    }
    
    // Sets the contentMode for the image.
    @IBInspectable
    open var contentModeValue: Int = 0 {
        didSet {
            if let mode = UIView.ContentMode(rawValue: contentModeValue) {
                contentMode = mode
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
    
    // Sets the corner radius for the image.
    @IBInspectable
    open var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    // Sets the border width for the image.
    @IBInspectable
    open var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // Sets the border color for the image.
    @IBInspectable
    open var borderColor: UIColor = UIColor.black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    open func prepare() {
        prepareVisualLayer()
    }
    
    fileprivate func prepareVisualLayer() {
        visualLayer.zPosition = 0
        visualLayer.masksToBounds = true
        layer.addSublayer(visualLayer)
    }
}
