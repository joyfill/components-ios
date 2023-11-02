import Foundation
import UIKit

public struct ColorModel {
    
    public var textColor: UIColor
    public var floatingLabelColor: UIColor
    public var normalLabelColor: UIColor
    public var outlineColor: UIColor
    
    public init(with state: TextField.State) {
        var textColor = UIColor.black
        var floatingLabelColor = UIColor.black
        var normalLabelColor = UIColor.darkGray
        var outlineColor = UIColor.gray
        
        if #available(iOS 13.0, *) {
            textColor = .label
            floatingLabelColor = .label
            normalLabelColor = .label
            outlineColor = .gray
        }
        
        let disabledAlpha: CGFloat = 0.6
        
        if state == .disabled {
            textColor = textColor.withAlphaComponent(disabledAlpha)
            floatingLabelColor = floatingLabelColor.withAlphaComponent(disabledAlpha)
            normalLabelColor = normalLabelColor.withAlphaComponent(disabledAlpha)
            outlineColor = normalLabelColor.withAlphaComponent(disabledAlpha)
        }
        
        self.init(textColor: textColor,
                  floatingLabelColor: floatingLabelColor,
                  normalLabelColor: normalLabelColor,
                  outlineColor: outlineColor)
    }
    
    public init(textColor: UIColor, floatingLabelColor: UIColor, normalLabelColor: UIColor, outlineColor: UIColor) {
        self.textColor = textColor
        self.floatingLabelColor = floatingLabelColor
        self.normalLabelColor = normalLabelColor
        self.outlineColor = outlineColor
    }
}
