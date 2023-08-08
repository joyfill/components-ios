import Foundation
import UIKit

// Signature Delegate Protocol
public protocol SignatureViewDelegate: AnyObject {
    func signatureViewDidDrawGesture(_ view: ISignatureView, _ tap: UIGestureRecognizer)
    func signatureViewDidDraw(_ view: ISignatureView)
}
