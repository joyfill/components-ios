import Foundation
import UIKit

public func toolTipAlertShow(for view: UIView, title : String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    var mutableString = NSMutableAttributedString()
    mutableString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14, weight: .bold)])
    mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: mutableString.length))
    alertController.setValue(mutableString, forKey: "attributedTitle")

    let actionCancel = UIAlertAction(title: "Dismiss", style: .default)
    alertController.addAction(actionCancel)
    
    var parentResponder : UIResponder?  = view
    while parentResponder != nil {
        parentResponder = parentResponder?.next
        if let viewController = parentResponder as? UIViewController {
            let newViewController = alertController
            viewController.present(newViewController, animated: true)
            break
        }
    }
}
