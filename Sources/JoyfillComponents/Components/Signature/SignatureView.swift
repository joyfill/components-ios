import Foundation
import UIKit

protocol saveSignatureFieldValue {
    func handleSignatureUpload(sign: Any, signer: String, index: Int)
}

open class SignatureView : UIView {
    
    public var titleLabel = Label()
    public var imageView = UIView()
    public var imageSignature = ImageView()
    public var signViewBt = UIView()
    public var signLbBt = Label()
    public var signIconBt = ImageView()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
    var index = Int()
    var saveDelegate: saveSignatureFieldValue? = nil
    var fieldDelegate: SaveTextFieldValue? = nil
    
    // MARK: - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if signatureDisplayModes == "readonly" {
            signViewBt.isHidden = true
        } else {
            signViewBt.isHidden = false
        }
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    func setupUI() {
        // SubViews
        self.addSubview(titleLabel)
        self.addSubview(toolTipIconButton)
        self.addSubview(imageView)
        self.addSubview(signViewBt)
        imageView.addSubview(imageSignature)
        signViewBt.addSubview(signLbBt)
        signViewBt.addSubview(signIconBt)
        
        signLbBt.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        signViewBt.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        signIconBt.translatesAutoresizingMaskIntoConstraints = false
        imageSignature.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to signatureView
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            imageView.heightAnchor.constraint(equalToConstant: 143),
            
            imageSignature.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            imageSignature.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            imageSignature.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
            imageSignature.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            
            signViewBt.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            signViewBt.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            signViewBt.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            signViewBt.heightAnchor.constraint(equalToConstant: 40),
            
            signLbBt.topAnchor.constraint(equalTo: signViewBt.topAnchor),
            signLbBt.leadingAnchor.constraint(equalTo: signViewBt.leadingAnchor),
            signLbBt.trailingAnchor.constraint(equalTo: signViewBt.trailingAnchor, constant: -30),
            signLbBt.bottomAnchor.constraint(equalTo: signViewBt.bottomAnchor),
            
            signIconBt.topAnchor.constraint(equalTo: signViewBt.topAnchor, constant: 10),
            signIconBt.leadingAnchor.constraint(equalTo: signLbBt.trailingAnchor, constant: 2),
            signIconBt.trailingAnchor.constraint(equalTo: signViewBt.trailingAnchor,constant: -10),
            signIconBt.bottomAnchor.constraint(equalTo: signViewBt.bottomAnchor, constant: -10)
        ])
        setGlobalUserInterfaceStyle()
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.text = "Signature Filled"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon", in: .module, compatibleWith: nil), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        
        signViewBt.layer.cornerRadius = 6
        signViewBt.layer.borderWidth = 1
        signViewBt.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        if #available(iOS 13.0, *) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(signButtonAction))
            signViewBt.addGestureRecognizer(tap)
        } else {
            // Fallback on earlier versions
        }
        signViewBt.isUserInteractionEnabled = true
        
        signIconBt.image = UIImage(named: "Edit_alt_black", in: .module, compatibleWith: nil)
        signLbBt.fontSize = 14
        signLbBt.isTextBold = true
        signLbBt.labelText = "Sign"
        signLbBt.textAlignment = .center
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
    
    // Action function for SignButton
    @available(iOS 13.0, *)
    @objc func signButtonAction() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                let newViewController = SignatureViewController()
                newViewController.index = index
                fieldDelegate?.handleFocus(index: index)
                newViewController.saveDelegate = self.saveDelegate
                newViewController.fieldDelegate = self.fieldDelegate
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
}
