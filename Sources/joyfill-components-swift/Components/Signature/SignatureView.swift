import Foundation
import UIKit

open class SignatureView : UIView {
    
    public var titleLabel = Label()
    public var lookIcon = UIImageView()
    public var lookTitle = UILabel()
    public var lookView = UIView()
    public var imageView = UIView()
    public var imageSignature = ImageView()
    public var signViewBt = UIView()
    public var signLbBt = Label()
    public var signIconBt = ImageView()
    
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
        if signatureDisplayModes != "readonly" {
            if signedImage != "" {
                imageView.layer.borderWidth = 0
                imageSignature.load(urlString: signedImage)
            }
        }
    }
    
    func setupUI() {
        // SubViews
        self.addSubview(titleLabel)
        self.addSubview(lookView)
        self.addSubview(imageView)
        self.addSubview(signViewBt)
        lookView.addSubview(lookIcon)
        lookView.addSubview(lookTitle)
        imageView.addSubview(imageSignature)
        signViewBt.addSubview(signLbBt)
        signViewBt.addSubview(signIconBt)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lookView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        signViewBt.translatesAutoresizingMaskIntoConstraints = false
        lookTitle.translatesAutoresizingMaskIntoConstraints = false
        imageSignature.translatesAutoresizingMaskIntoConstraints = false
        lookIcon.translatesAutoresizingMaskIntoConstraints = false
        signLbBt.translatesAutoresizingMaskIntoConstraints = false
        signIconBt.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to signatureView
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            lookView.topAnchor.constraint(equalTo: self.topAnchor, constant: 21),
            lookView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -9),
            lookView.heightAnchor.constraint(equalToConstant: 30),
            lookView.widthAnchor.constraint(equalToConstant: 200),
            
            lookTitle.topAnchor.constraint(equalTo: lookView.topAnchor),
            lookTitle.bottomAnchor.constraint(equalTo: lookView.bottomAnchor),
            lookTitle.trailingAnchor.constraint(equalTo: lookView.trailingAnchor),
            lookTitle.leadingAnchor.constraint(equalTo: lookIcon.trailingAnchor, constant: 5),
            
            lookIcon.topAnchor.constraint(equalTo: lookView.topAnchor, constant: 4),
            lookIcon.heightAnchor.constraint(equalToConstant: 20),
            lookIcon.widthAnchor.constraint(equalToConstant: 20),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
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
            signIconBt.bottomAnchor.constraint(equalTo: signViewBt.bottomAnchor, constant: -7)
        ])
        
        titleLabel.text = "Signature Filled"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .black
        
        lookTitle.text = "Sign to add timestamp"
        lookTitle.textColor = UIColor(hexString: "#C0C1CC")
        lookTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lookIcon.image = UIImage(named: "Lock")
        
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        
        signViewBt.layer.cornerRadius = 6
        signViewBt.layer.borderWidth = 1
        signViewBt.layer.borderColor = UIColor(hexString: "#D1D1D6")?.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(signButtonAction))
        signViewBt.addGestureRecognizer(tap)
        signViewBt.isUserInteractionEnabled = true
        
        signIconBt.image = UIImage(named: "Edit_alt_black")
        signLbBt.fontSize = 14
        signLbBt.isTextBold = true
        signLbBt.labelText = "Sign"
        signLbBt.textAlignment = .center
    }
    
    // Action function for SignButton
    @objc func signButtonAction() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                var newViewController = UIViewController()
                if #available(iOS 13.0, *) {
                    newViewController = SignatureViewController()
                } else {
                    // Fallback on earlier versions
                }
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
}
