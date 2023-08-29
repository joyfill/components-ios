import Foundation
import UIKit
import PencilKit

public var signedImage = String()
public var privacyPolicyText = String()
public var signatureDisplayModes = String()

@available(iOS 13.0, *)
open class Signature: UIView {
    
    private var viewReady: Bool = false
    public let view = UIView()
    public let topLabel = Label()
    public let bottonLabel = Label()
    public let button = Button()
    public let clrButton = Button()
    public let closeButton = Button()
    public var textField = TextField()
    public var saveView = UIView()
    public var saveText = UILabel()
    public var saveIcon = UIImageView()
    public var lookIcon = UIImageView()
    public var lookTitle = UILabel()
    public var lookView = UIView()
    public var infomText = Label()
    public var signatureMode = Bool()
    public var signatureView = Canvas()
    
    // Sets corner radius of signature view
    @IBInspectable
    open var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    // MARK: - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSignatureView()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        createSignatureView()
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override open func updateConstraintsIfNeeded() {
        super.updateConstraintsIfNeeded()
        if viewReady {
            return
        }
        viewReady = true
    }
    
    private func createSignatureView() {
        // SubViews
        view.addSubview(topLabel)
        view.addSubview(signatureView)
        view.addSubview(clrButton)
        view.addSubview(closeButton)
        view.addSubview(textField)
        view.addSubview(saveView)
        saveView.addSubview(saveText)
        saveView.addSubview(saveIcon)
        view.addSubview(lookView)
        lookView.addSubview(lookIcon)
        lookView.addSubview(lookTitle)
        view.addSubview(infomText)
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        clrButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveText.translatesAutoresizingMaskIntoConstraints = false
        saveIcon.translatesAutoresizingMaskIntoConstraints = false
        lookView.translatesAutoresizingMaskIntoConstraints = false
        lookIcon.translatesAutoresizingMaskIntoConstraints = false
        lookTitle.translatesAutoresizingMaskIntoConstraints = false
        infomText.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to signatureView
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            topLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: 10),
            topLabel.heightAnchor.constraint(equalToConstant: 30),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 9),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 50),
            
            signatureView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 18),
            signatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            signatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            signatureView.heightAnchor.constraint(equalToConstant: 143),
            
            textField.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 9),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            textField.trailingAnchor.constraint(equalTo: clrButton.leadingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            clrButton.topAnchor.constraint(equalTo: signatureView.bottomAnchor, constant: 9),
            clrButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            clrButton.widthAnchor.constraint(equalToConstant: 105),
            clrButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 28),
            saveView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -115),
            saveView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 115),
            saveView.heightAnchor.constraint(equalToConstant: 50),
            
            saveText.topAnchor.constraint(equalTo: saveView.topAnchor),
            saveText.bottomAnchor.constraint(equalTo: saveView.bottomAnchor),
            saveText.centerXAnchor.constraint(equalTo: saveView.centerXAnchor),
            saveText.centerYAnchor.constraint(equalTo: saveView.centerYAnchor),
            
            saveIcon.topAnchor.constraint(equalTo: saveView.topAnchor, constant: 18),
            saveIcon.leadingAnchor.constraint(equalTo: saveText.trailingAnchor, constant: 10),
            
            lookView.topAnchor.constraint(equalTo: saveView.bottomAnchor, constant: 10),
            lookView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -115),
            lookView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 115),
            lookView.heightAnchor.constraint(equalToConstant: 30),
            
            lookTitle.topAnchor.constraint(equalTo: lookView.topAnchor),
            lookTitle.bottomAnchor.constraint(equalTo: lookView.bottomAnchor),
            lookTitle.leadingAnchor.constraint(equalTo: lookIcon.trailingAnchor, constant: 5),
            lookTitle.trailingAnchor.constraint(equalTo: lookView.trailingAnchor, constant: -5),
            
            
            lookIcon.topAnchor.constraint(equalTo: lookView.topAnchor, constant: 4),
            lookIcon.leadingAnchor.constraint(equalTo: lookView.leadingAnchor, constant: 15),
            lookIcon.heightAnchor.constraint(equalToConstant: 20),
            lookIcon.widthAnchor.constraint(equalToConstant: 20),
            
            infomText.topAnchor.constraint(equalTo: lookView.bottomAnchor, constant: 45),
            infomText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            infomText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
        ])
        
        signatureView.lineWidth = 3
        signatureView.layer.borderWidth = 1
        signatureView.layer.cornerRadius = 8
        signatureView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        signatureView.backgroundColor = .white
        
        // MARK: Label Function Call From Package
        topLabel.labelText = "Signature"
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        topLabel.borderWidth = 0
        topLabel.textColor = .black
        
        clrButton.title = "Clear"
        clrButton.semanticContentAttribute = .forceRightToLeft
        clrButton.contentVerticalAlignment = .center
        clrButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        clrButton.titleColor = .black
        clrButton.backgroundColor = .clear
        clrButton.cornerRadius = 6
        clrButton.borderColor = UIColor(hexString: "#D1D1D6") ?? .gray
        clrButton.borderWidth = 1
        let icon = UIImage(named: "close_ring")
        clrButton.setImage(icon, for: .normal)
        clrButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        clrButton.addTarget(self, action: #selector(clrButtonTapped), for: .touchUpInside)
        
        // Sets image and action to pageButton
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let boldSearch = UIImage(systemName: "xmark.circle", withConfiguration: boldConfig)
        closeButton.setImage(boldSearch, for: .normal)
        
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(clossTapped), for: .touchUpInside)
        
        textField.placeholder = "Type to sign"
        textField.borderColor = UIColor(hexString: "#D1D1D6") ?? .gray
        textField.layer.cornerRadius = 6
        textField.borderWidth = 1
        
        saveView.layer.cornerRadius = 6
        saveView.backgroundColor = UIColor(hexString: "#256FFF")
        let tap = UITapGestureRecognizer(target: self, action: #selector(saveSignature))
        saveView.addGestureRecognizer(tap)
        
        saveText.text = "Save"
        saveText.textColor = .white
        saveText.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        saveIcon.image = UIImage(named: "Edit_alt")
        
        lookTitle.text = "Save to add timestamp"
        lookTitle.textColor = UIColor(hexString: "#C0C1CC")
        lookTitle.font = UIFont.systemFont(ofSize: 14)
        
        lookIcon.image = UIImage(named: "Lock")
        
        infomText.text = privacyPolicyText
        infomText.textAlignment = .center
        infomText.numberOfLines = 0
        infomText.textColor = UIColor(hexString: "#C0C1CC")
        infomText.font = UIFont.systemFont(ofSize: 14)
    }
    
    // Action for SaveSignature button
    @objc func saveSignature() {
        if let image = signatureView.getDesign {
            convertImageToDataURI(uri: image, signer: textField.text ?? "")
        }
        clossTapped()
    }
    
    
    // Function to convert UIImage to data URI
    func convertImageToDataURI(uri: UIImage, signer: String) {
        if let imageData = uri.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()
            signedImage = "data:image/jpeg;base64,\(base64String)"
        }
    }
    
    // Action for close button
    @objc func clossTapped() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                viewController.dismiss(animated: true)
                break
            }
        }
    }
    
    @objc func clrButtonTapped() {
        signatureView.clear()
    }
}
