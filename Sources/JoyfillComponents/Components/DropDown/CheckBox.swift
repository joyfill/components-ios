import Foundation
import UIKit

@IBDesignable
open class Checkbox: UIControl {
    
    // Shape of the checkmark appear inside the checkbox.
    @objc public enum CheckmarkStyle: Int {
        case square
        case circle
        case cross
        case tick
    }
    
    // Outside box on checkbox
    @objc public enum BorderStyle: Int {
        case square
        case circle
    }
    
    // Default value given to checkmarkStyle = tick
    @objc dynamic public var checkmarkStyle: CheckmarkStyle = .tick
    @IBInspectable private var checkmarkStyleIB: Int {
        set {
            checkmarkStyle = CheckmarkStyle(rawValue: newValue) ?? .tick
        }
        get {
            return checkmarkStyle.rawValue
        }
    }
    
    // Default value given to borderStyle = square
    @objc dynamic public var borderStyle: BorderStyle = .square
    @IBInspectable private var borderStyleIB: Int {
        set {
            borderStyle = BorderStyle(rawValue: newValue) ?? .square
        }
        get {
            return borderStyle.rawValue
        }
    }
    
    @IBInspectable public var borderLineWidth: CGFloat = 2
    @IBInspectable public var checkmarkSize: CGFloat = 0.5
    @IBInspectable public var uncheckedBorderColor: UIColor!
    @IBInspectable public var checkedBorderColor: UIColor!
    @IBInspectable public var checkmarkColor: UIColor!
   
    // Removed the @absolete for recent fix - jp
    public var checkboxBackgroundColor: UIColor! = .white
    // Removed the @absolete for recent fix - jp
    @IBInspectable public var checkboxFillColor: UIColor = .clear
    @IBInspectable public var borderCornerRadius: CGFloat = 0.0
    @IBInspectable public var increasedTouchRadius: CGFloat = 5
    public var valueChanged: ((_ isChecked: Bool) -> Void)?
    @IBInspectable public var isChecked: Bool = false {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var useHapticFeedback: Bool = true
    
    // MARK: - Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }
    
    private func setupDefaults() {
        backgroundColor = UIColor.init(white: 1, alpha: 0)
        uncheckedBorderColor = tintColor
        checkedBorderColor = tintColor
        checkmarkColor = tintColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(recognizer:)))
        addGestureRecognizer(tapGesture)
    }
    
    override public func draw(_ rect: CGRect) {
        drawBorder(shape: borderStyle, in: rect)
        guard isChecked else { return }
        drawCheckmark(style: checkmarkStyle, in: rect)
    }

    // MARK: - Borders
    private func drawBorder(shape: BorderStyle, in rect: CGRect) {
        let adjustedRect = CGRect(x: borderLineWidth/2,
                                  y: borderLineWidth/2,
                                  width: rect.width-borderLineWidth,
                                  height: rect.height-borderLineWidth)
        
        switch shape {
        case .circle:
            circleBorder(rect: adjustedRect)
        case .square:
            squareBorder(rect: adjustedRect)
        }
    }
    
    // Function to create square border
    private func squareBorder(rect: CGRect) {
        let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: borderCornerRadius)
        
        if isChecked {
            checkedBorderColor.setStroke()
        } else {
            uncheckedBorderColor.setStroke()
        }
        
        rectanglePath.lineWidth = borderLineWidth
        rectanglePath.stroke()
        checkboxFillColor.setFill()
        rectanglePath.fill()
    }
    
    // Function to create circular border
    private func circleBorder(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        if isChecked {
            checkedBorderColor.setStroke()
        } else {
            uncheckedBorderColor.setStroke()
        }
        
        ovalPath.lineWidth = borderLineWidth / 2
        ovalPath.stroke()
        checkboxFillColor.setFill()
        ovalPath.fill()
    }
    
    // MARK: - Checkmarks
    private func drawCheckmark(style: CheckmarkStyle, in rect: CGRect) {
        let adjustedRect = checkmarkRect(in: rect)
        switch checkmarkStyle {
        case .square:
            squareCheckmark(rect: adjustedRect)
        case .circle:
            circleCheckmark(rect: adjustedRect)
        case .cross:
            crossCheckmark(rect: adjustedRect)
        case .tick:
            tickCheckmark(rect: adjustedRect)
        }
    }
    
    // Function to create circular checkMark
    private func circleCheckmark(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalIn: rect)
        checkmarkColor.setFill()
        ovalPath.fill()
    }
    
    // Function to create square checkMark
    private func squareCheckmark(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        checkmarkColor.setFill()
        path.fill()
    }
    
    // Function to create cross checkMark
    private func crossCheckmark(rect: CGRect) {
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: rect.minX + 0.06250 * rect.width, y: rect.minY + 0.06452 * rect.height))
        bezier4Path.addLine(to: CGPoint(x: rect.minX + 0.93750 * rect.width, y: rect.minY + 0.93548 * rect.height))
        bezier4Path.move(to: CGPoint(x: rect.minX + 0.93750 * rect.width, y: rect.minY + 0.06452 * rect.height))
        bezier4Path.addLine(to: CGPoint(x: rect.minX + 0.06250 * rect.width, y: rect.minY + 0.93548 * rect.height))
        checkmarkColor.setStroke()
        bezier4Path.lineWidth = checkmarkSize * 2
        bezier4Path.stroke()
    }
    
    // Function to create tick checkMark
    private func tickCheckmark(rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.minX + 0.04688 * rect.width, y: rect.minY + 0.63548 * rect.height))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 0.34896 * rect.width, y: rect.minY + 0.95161 * rect.height))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 0.95312 * rect.width, y: rect.minY + 0.04839 * rect.height))
        checkmarkColor.setStroke()
        bezierPath.lineWidth = checkmarkSize * 2
        bezierPath.stroke()
    }
    
    // MARK: - Size Calculations
    private func checkmarkRect(in rect: CGRect) -> CGRect {
        let width = rect.maxX * checkmarkSize
        let height = rect.maxY * checkmarkSize
        let adjustedRect = CGRect(x: (rect.maxX - width) / 2,
                                  y: (rect.maxY - height) / 2,
                                  width: width,
                                  height: height)
        return adjustedRect
    }
    
    // MARK: - Touch
    @objc private func handleTapGesture(recognizer: UITapGestureRecognizer) {
        isChecked = !isChecked
        valueChanged?(isChecked)
        sendActions(for: .valueChanged)
    }
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
