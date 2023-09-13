import Foundation
import UIKit

// Date Extension
extension Date {
    func dateString(_ format: String = "MMM dd, yyyy hh:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "en_US")
        let strDate = formatter.string(from: self)
        return strDate
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// UIApplication Extension
extension UIApplication {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        } else {
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
}

// UIWindow Extension
extension UIWindow {
    static var currentController: UIViewController? {
        return UIApplication.keyWindow?.currentController
    }
    
    var currentController: UIViewController? {
        if let vc = self.rootViewController {
            return topViewController(controller: vc)
        }
        return nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nc = controller as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return topViewController(controller: nc.viewControllers.last!)
            } else {
                return nc
            }
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

// UIView Extension
extension UIView {
    func pinConstraints(_ byView: UIView, left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let l = left { leftAnchor.constraint(equalTo: byView.leftAnchor, constant: l).isActive = true }
        if let r = right { rightAnchor.constraint(equalTo: byView.rightAnchor, constant: r).isActive = true }
        if let t = top { topAnchor.constraint(equalTo: byView.topAnchor, constant: t).isActive = true }
        if let b = bottom { bottomAnchor.constraint(equalTo: byView.bottomAnchor, constant: b).isActive = true }
        if let h = height { heightAnchor.constraint(equalToConstant: h).isActive = true }
        if let w = width { widthAnchor.constraint(equalToConstant: w).isActive = true }
    }
    
    func surroundConstraints(_ byView: UIView, left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        pinConstraints(byView, left: left, right: right, top: top, bottom: bottom)
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func viewBorder(borderColor: UIColor, borderWidth: CGFloat?) {
        layer.borderColor = borderColor.cgColor
        if let borderWidth_ = borderWidth {
            layer.borderWidth = borderWidth_
        } else {
            layer.borderWidth = 1.0
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func roundCornerView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func hideKeyboardOnTapAnyView() {
        let tap =  UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        tap.addTarget(self, action: #selector(tapTriggeredAnyView))
        
        addGestureRecognizer(tap)
    }
    
    @objc private func tapTriggeredAnyView(_ gesture: UIGestureRecognizer) {
        window?.endEditing(true)
    }
}

// UIColor Extension
extension UIColor {
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
                    b = CGFloat(hexNumber & 0x0000FF) / 255.0
                    a = 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

// UIBezierPath Extension
extension UIBezierPath {
    func addTopRightCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -(CGFloat.pi / 2)
        let endAngle = CGFloat.zero
        let center = CGPoint(x: point1.x, y: point2.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func addBottomRightCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = CGFloat.zero
        let endAngle = -((CGFloat.pi * 3) / 2)
        let center = CGPoint(x: point2.x, y: point1.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func addBottomLeftCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -((CGFloat.pi * 3) / 2)
        let endAngle = -CGFloat.pi
        let center = CGPoint(x: point1.x, y: point2.y)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func addTopLeftCorner(from point1: CGPoint, to point2: CGPoint, with radius: CGFloat) {
        let startAngle = -CGFloat.pi
        let endAngle = -(CGFloat.pi / 2)
        let center = CGPoint(x: point1.x + radius, y: point2.y + radius)
        addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
}

// Function to make some part of whole text bold
func attributedText(withString string: String,
                    boldString: String,
                    font: UIFont,
                    boldFont: UIFont) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(
        string: string,
        attributes: [NSAttributedString.Key.font: font]
    )
    let boldFontAttribute = [NSAttributedString.Key.font: boldFont]
    let range = (string as NSString).range(of: boldString)
    
    attributedString.addAttributes(boldFontAttribute, range: range)
    return attributedString
}

// UIImage Extension
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        return self
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

// UITableView Extension
extension UITableView {
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

// String Extension
extension String {
    func textAlignmentFromStringValue() -> NSTextAlignment {
        switch self.lowercased() {
        case "left":
            return .left
        case "right":
            return .right
        case "center":
            return .center
        case "justified":
            return .justified
        case "natural":
            return .natural
        default:
            return .left // Default to left alignment if the input is not recognized
        }
    }
}

// Font Extension
extension UIFont {
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
}
