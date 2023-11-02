import UIKit

// MARK: - Designable Class
@IBDesignable
open class Canvas: UIView {
    
    private var path = UIBezierPath()
    private var lines = [[CGPoint]]()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Inspectable elements
    @IBInspectable
    open var lineWidth: CGFloat = 10.0 {
        didSet {
            path.lineWidth = lineWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var lineColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var style: CGLineCap = .round {
        didSet {
            path.lineCapStyle = style
            setNeedsDisplay()
        }
    }
    
    open var isEmpty: Bool {
        get {
            guard !self.path.isEmpty else {
                return true
            }
            return false
        }
    }
    
    // Convert UIView to Image
    open var getDesign: UIImage? {
        return UIImage(view: self)
        
    }
    
    // Clear sign
    internal func clear() {
        lines.removeAll()
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    // Custome Drawing
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        lines.forEach { (line) in
            for (i,p) in line.enumerated() {
                if i == 0 {
                    path.move(to: p)
                }
                else {
                    path.addLine(to: p)
                }
            }
        }
        lineColor.setStroke()
        path.stroke()
    }
    
    // Track the finger as we move across screen
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override open func touchesMoved (_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let points = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.append(points)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
