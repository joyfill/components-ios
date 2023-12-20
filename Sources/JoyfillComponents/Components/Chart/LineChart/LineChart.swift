import Foundation
import UIKit
import QuartzCore

open class LineChart: UIView {
    
    var index = Int()
    let numberOfLabels = 6
    public var xMax = Int()
    public var xMin = Int()
    public var yMax = Int()
    public var yMin = Int()
    
    fileprivate class Helpers {
        // Convert hex color to UIColor
        fileprivate class func UIColorFromHex(_ hex: Int) -> UIColor {
            let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
            let blue = CGFloat((hex & 0xFF)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1)
        }
        
        // Lighten color
        fileprivate class func lightenUIColor(_ color: UIColor) -> UIColor {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return UIColor(hue: h, saturation: s, brightness: b * 1.5, alpha: a)
        }
    }
    
    public struct Labels {
        public var visible: Bool = true
        public var values: [String] = []
    }
    
    // Sets the grid inside the chart
    public struct Grid {
        public var visible: Bool = true
        public var count: CGFloat = 10
        public var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    }
    
    // To show chart axis
    public struct Axis {
        public var visible: Bool = true
        public var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        public var inset: CGFloat = 15
    }
    
    public struct Coordinate {
        public var labels: Labels = Labels()
        public var grid: Grid = Grid()
        public var axis: Axis = Axis()
        
        fileprivate var linear: LinearScale!
        fileprivate var scale: ((CGFloat) -> CGFloat)!
        fileprivate var invert: ((CGFloat) -> CGFloat)!
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    // To show animation on line in chart
    public struct Animation {
        public var enabled: Bool = true
        public var duration: CFTimeInterval = 1
    }
    
    // To show dots on coordinates
    public struct Dots {
        public var visible: Bool = true
        public var color: UIColor = UIColor.white
        public var innerRadius: CGFloat = 8
        public var outerRadius: CGFloat = 12
        public var innerRadiusHighlighted: CGFloat = 8
        public var outerRadiusHighlighted: CGFloat = 12
    }
    
    // default configuration
    open var area: Bool = true
    open var animation: Animation = Animation()
    open var dots: Dots = Dots()
    open var lineWidth: CGFloat = 2
    open var x: Coordinate = Coordinate()
    open var y: Coordinate = Coordinate()
    
    // values calculated on init
    var drawingHeight: CGFloat = 0 {
        didSet {
            let max = getMaximumValue()
            let min = getMinimumValue()
            y.linear = LinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear.scale()
            y.ticks = y.linear.ticks(Int(y.grid.count))
        }
    }
    
    var drawingWidth: CGFloat = 0 {
        didSet {
            let data = dataStore[0]
            x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
            x.scale = x.linear.scale()
            x.invert = x.linear.invert()
            x.ticks = x.linear.ticks(Int(x.grid.count))
        }
    }
    
    // data stores
    fileprivate var dataStore: [[CGFloat]] = []
    fileprivate var dotsDataStore: [[DotCALayer]] = []
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    fileprivate var removeAll: Bool = false
    
    public var colors: [UIColor?] = [
        UIColor(hexString: "#3CBA7E"),
        UIColor(hexString: "#81cfe0"),
        UIColor(hexString: "#736598"),
        UIColor(hexString: "#2ecc71"),
        UIColor(hexString: "#00b5cc"),
        UIColor(hexString: "#9f5afd"),
        UIColor(hexString: "#86e2d5"),
        UIColor(hexString: "#52b3d9"),
        UIColor(hexString: "#a537fd"),
        UIColor(hexString: "#29f1c3"),
        UIColor(hexString: "#336e7b"),
        UIColor(hexString: "#bf55ec"),
        UIColor(hexString: "#1E824D"),
    ]
    
    // MARK: Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        x.grid.visible = false
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
        x.grid.visible = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        x.grid.visible = false
    }
    
    override open func draw(_ rect: CGRect) {
        if index <= xCoordinates.count {
            if xCoordinates[index].isEmpty != true {
                if removeAll {
                    let context = UIGraphicsGetCurrentContext()
                    context?.clear(rect)
                    return
                }
                
                self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
                self.drawingWidth = self.bounds.width - (2 * x.axis.inset)
                
                // remove all labels
                for view: AnyObject in self.subviews {
                    view.removeFromSuperview()
                }
                
                // remove all lines on device rotation
                for lineLayer in lineLayerStore {
                    lineLayer.removeFromSuperlayer()
                }
                lineLayerStore.removeAll()
                
                // remove all dots on device rotation
                for dotsData in dotsDataStore {
                    for dot in dotsData {
                        dot.removeFromSuperlayer()
                    }
                }
                dotsDataStore.removeAll()
                
                // draw grid
                if x.grid.visible && y.grid.visible { drawGrid() }
                
                // draw axes
                if x.axis.visible && y.axis.visible { drawAxes() }
                
                // draw labels
                if x.labels.visible { drawXLabels() }
                if y.labels.visible { drawYLabels() }
                
                // draw lines
                for (lineIndex, _) in yCoordinates[index].enumerated() {
                    
                    drawLine(lineIndex)
                    
                    // draw dots
                    if dots.visible { drawDataDots(lineIndex) }
                    
                    // draw area under line chart
                    // if area { drawAreaBeneathLineChart(lineIndex) }
                }
            }
        }
    }
    
    // Get y value for given x value. Or return zero or maximum value.
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        var result: [CGFloat] = []
        for lineData in dataStore {
            if x < 0 {
                result.append(lineData[0])
            } else if x > lineData.count - 1 {
                result.append(lineData[lineData.count - 1])
            } else {
                result.append(lineData[x])
            }
        }
        return result
    }
    
    //Handle touch events.
    fileprivate func handleTouchEvents(_ touches: NSSet!, event: UIEvent) {
        if (self.dataStore.isEmpty) {
            return
        }
        let point: AnyObject! = touches.anyObject() as AnyObject?
        let xValue = point.location(in: self).x
        let inverted = self.x.invert(xValue - x.axis.inset)
        let rounded = Int(round(Double(inverted)))
        highlightDataPoints(rounded)
        
    }
    
    //Listen on touch end event.
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet?, event: event!)
    }
    
    //Listen on touch move event
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouchEvents(touches as NSSet?, event: event!)
    }
    
    // Highlight data points at index.
    fileprivate func highlightDataPoints(_ index: Int) {
        for (lineIndex, dotsData) in dotsDataStore.enumerated() {
            // make all dots white again
            for dot in dotsData {
                dot.backgroundColor = dots.color.cgColor
            }
            // highlight current data point
            var dot: DotCALayer
            if index < 0 {
                dot = dotsData[0]
            } else if index > dotsData.count - 1 {
                dot = dotsData[dotsData.count - 1]
            } else {
                dot = dotsData[index]
            }
            dot.backgroundColor = Helpers.lightenUIColor(colors[lineIndex] ?? .black).cgColor
        }
    }
    
    // Draw small dot at every data point.
    fileprivate func drawDataDots(_ lineIndex: Int) {
        var dotLayers: [DotCALayer] = []
        let data = yCoordinates[index][lineIndex]
        let data2 = xCoordinates[index][lineIndex]
        let labelData = graphLabelData[index][lineIndex]
        
        for index in 0..<data.count {
            let xValue = self.y.scale(data2[index]) + x.axis.inset - dots.outerRadius/2 + data2[index]
            let yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset - dots.outerRadius/2
            
            let dotLayer = DotCALayer()
            dotLayer.opacity = 0.5
            dotLayer.dotInnerColor = colors[lineIndex] ?? .black
            dotLayer.innerRadius = dots.innerRadius
            dotLayer.backgroundColor = dots.color.cgColor
            dotLayer.cornerRadius = dots.outerRadius / 2
            dotLayer.frame = CGRect(x: xValue, y: yValue, width: dots.outerRadius, height: dots.outerRadius)
            self.layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
            
            if animation.enabled {
                let anim = CABasicAnimation(keyPath: "opacity")
                anim.duration = animation.duration
                anim.fromValue = 0
                anim.toValue = 1
                dotLayer.add(anim, forKey: "opacity")
            }
            
            // Add label on top of the dot
            let label = UILabel(frame: CGRect(x: xValue - 10, y: yValue - 15, width: 50, height: 20))
            label.font = UIFont.systemFont(ofSize: 10)
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.text = "\(labelData[index])"
            self.addSubview(label)
        }
        dotsDataStore.append(dotLayers)
    }
    
    //  Draw x and y axis.
    fileprivate func drawAxes() {
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        // draw x-axis
        x.axis.color.setStroke()
        let y0 = height - self.y.scale(0) - y.axis.inset
        path.move(to: CGPoint(x: x.axis.inset, y: y0))
        path.addLine(to: CGPoint(x: width - x.axis.inset, y: y0))
        path.stroke()
        // draw y-axis
        y.axis.color.setStroke()
        path.move(to: CGPoint(x: x.axis.inset, y: height - y.axis.inset))
        path.addLine(to: CGPoint(x: x.axis.inset, y: y.axis.inset))
        path.stroke()
    }
    
    // Get maximum value in all arrays in data store.
    fileprivate func getMaximumValue() -> CGFloat {
        return CGFloat(yMax)
    }
    
    // Get maximum value in all arrays in data store.
    fileprivate func getMinimumValue() -> CGFloat {
        var min: CGFloat = 0
        for data in dataStore {
            let newMin = data.min()!
            if newMin < min {
                min = newMin
            }
        }
        return min
    }
    
    // Draw line.
    fileprivate func drawLine(_ lineIndex: Int) {
        let data = yCoordinates[index][lineIndex]
        let data2 = xCoordinates[index][lineIndex]
        let path = UIBezierPath()
        
        var xValue = self.y.scale(data2[0]) + x.axis.inset + data2[0]
        var yValue = self.bounds.height - self.y.scale(data[0]) - y.axis.inset
        path.move(to: CGPoint(x: xValue, y: yValue))
        
        for index in 1..<data.count {
            xValue = self.y.scale(data2[index]) + x.axis.inset + data2[index]
            yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: xValue, y: yValue))
        }
        
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.path = path.cgPath
        layer.strokeColor = colors[lineIndex]?.cgColor
        layer.fillColor = nil
        layer.lineWidth = lineWidth
        self.layer.addSublayer(layer)
        
        if animation.enabled {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.duration = animation.duration
            anim.fromValue = 0
            anim.toValue = 1
            layer.add(anim, forKey: "strokeEnd")
        }
        lineLayerStore.append(layer)
    }
    
    // Fill area between line chart and x-axis.
    fileprivate func drawAreaBeneathLineChart(_ lineIndex: Int) {
        let data = self.dataStore[lineIndex]
        let path = UIBezierPath()
        
        colors[lineIndex]?.withAlphaComponent(0.2).setFill()
        // move to origin
        path.move(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        // add line to first data point
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(data[0]) - y.axis.inset))
        // draw whole line chart
        for index in 1..<data.count {
            let x1 = self.x.scale(CGFloat(index)) + x.axis.inset
            let y1 = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
            path.addLine(to: CGPoint(x: x1, y: y1))
        }
        // move down to x axis
        path.addLine(to: CGPoint(x: self.x.scale(CGFloat(data.count - 1)) + x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        // move to origin
        path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
        path.fill()
    }
    
    // Draw x grid.
    fileprivate func drawXGrid() {
        x.grid.color.setStroke()
        let path = UIBezierPath()
        var x1: CGFloat
        let y1: CGFloat = self.bounds.height - y.axis.inset
        let y2: CGFloat = y.axis.inset
        let (start, stop, step) = self.x.ticks
        for i in stride(from: start, through: stop, by: step){
            x1 = self.x.scale(i) + x.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x1, y: y2))
        }
        path.stroke()
    }
    
    // Draw y grid.
    fileprivate func drawYGrid() {
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: CGFloat = x.axis.inset
        let x2: CGFloat = self.bounds.width - x.axis.inset
        var y1: CGFloat
        let (start, stop, step) = self.y.ticks
        for i in stride(from: start, through: stop, by: step){
            y1 = self.bounds.height - self.y.scale(i) - y.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }
    
    // Draw grid.
    fileprivate func drawGrid() {
        drawXGrid()
        drawYGrid()
    }
    
    // Draw Xaxis labels
    fileprivate func drawXLabels() {
        let y = self.bounds.height - x.axis.inset + 5
        let labelWidth = self.bounds.width / CGFloat(numberOfLabels)
        let stepSize = CGFloat((xMax)) / CGFloat(numberOfLabels - 1)
        
        for index in 0..<numberOfLabels {
            let value = xMin + Int(CGFloat(index) * stepSize)
            let xValue = CGFloat(index) * labelWidth + x.axis.inset - 28
            let label = UILabel(frame: CGRect(x: xValue, y: y, width: labelWidth, height: x.axis.inset))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .center
            label.text = "\(value)"
            self.addSubview(label)
        }
    }
    
    // Draw Yaxis labels
    fileprivate func drawYLabels() {
        let labelSpacing: CGFloat = 40
        let yLabelHeight: CGFloat = 20
        let labelWidth = self.bounds.width / CGFloat(numberOfLabels)
        let stepSize = CGFloat((yMax)) / CGFloat(numberOfLabels - 1)
        
        for index in 0..<numberOfLabels {
            let value = yMin + Int(CGFloat(index) * stepSize)
            let yValue = self.bounds.height - CGFloat(index) * labelSpacing - y.axis.inset - yLabelHeight/2
            let label = UILabel(frame: CGRect(x: -30, y: yValue, width: labelWidth, height: yLabelHeight))
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.textAlignment = .center
            label.text = "\(value)"
            self.addSubview(label)
        }
    }
    
    // Add line chart
    open func addLine(_ data: [CGFloat], labels: [String]) {
        self.dataStore.append(data)
        self.x.labels.values = labels
        self.setNeedsDisplay()
    }
    
    // Make whole thing white again.
    open func clearAll() {
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    // Remove charts, areas and labels but keep axis and grid.
    open func clear() {
        // dataStore.removeAll()
        self.setNeedsDisplay()
    }
}

class DotCALayer: CALayer {
    var innerRadius: CGFloat = 8
    var dotInnerColor = UIColor.black
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        let inset = self.bounds.size.width - innerRadius
        let innerDotLayer = CALayer()
        innerDotLayer.frame = self.bounds.insetBy(dx: inset/2, dy: inset/2)
        innerDotLayer.backgroundColor = dotInnerColor.cgColor
        innerDotLayer.cornerRadius = innerRadius / 2
        self.addSublayer(innerDotLayer)
    }
}

open class LinearScale {
    var domain: [CGFloat]
    var range: [CGFloat]
    
    public init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
        self.domain = domain
        self.range = range
    }
    
    open func scale() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func invert() -> (_ x: CGFloat) -> CGFloat {
        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    open func ticks(_ m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTicks(domain, m: m)
    }
    
    fileprivate func scale_linearTicks(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        return scale_linearTickRange(domain, m: m)
    }
    
    fileprivate func scale_linearTickRange(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        let extent = scaleExtent(domain)
        let span = extent[1] - extent[0]
        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
        let err = CGFloat(m) / span * step
        
        // Filter ticks to get closer to the desired count.
        if (err <= 0.15) {
            step *= 10
        } else if (err <= 0.35) {
            step *= 5
        } else if (err <= 0.75) {
            step *= 2
        }
        
        // Round start and stop values to step interval.
        let start = ceil(extent[0] / step) * step
        let stop = floor(extent[1] / step) * step + step * 0.5
        return (start, stop, step)
    }
    
    fileprivate func scaleExtent(_ domain: [CGFloat]) -> [CGFloat] {
        let start = domain[0]
        let stop = domain[domain.count - 1]
        return start < stop ? [start, stop] : [stop, start]
    }
    
    fileprivate func interpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        let diff = b - a
        func f(_ c: CGFloat) -> CGFloat {
            return (a + diff) * c
        }
        return f
    }
    
    fileprivate func uninterpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        let diff = b - a
        let re = diff != 0 ? 1 / diff : 0
        func f(_ c: CGFloat) -> CGFloat {
            return (c - a) * re
        }
        return f
    }
    
    fileprivate func bilinear(_ domain: [CGFloat], range: [CGFloat], uninterpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat, interpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat) -> (_ c: CGFloat) -> CGFloat {
        let u: (_ c: CGFloat) -> CGFloat = uninterpolate(domain[0], domain[1])
        let i: (_ c: CGFloat) -> CGFloat = interpolate(range[0], range[1])
        func f(_ d: CGFloat) -> CGFloat {
            return i(u(d))
        }
        return f
    }
}
