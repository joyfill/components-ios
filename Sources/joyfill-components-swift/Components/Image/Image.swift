import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

public var pickedImg = [UIImage]()
public var zoomImg = UIImage()
public var imageDisplayMode = String()
open class Image: UIView, UIViewControllerTransitioningDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public var imageFieldAndUploadView = UIView()
    public var imageField = ImageView()
    public var uploadButton = Button()
    public var imageCountView = UIView()
    public var imageCountButton = Button()
    public var imageCountLabel = Label()
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public init() {
        super.init(frame: .zero)
        setupView()
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        imageCountLabel.labelText = "+\(pickedImg.count)"
        setImageField()
    }
    
    func setupView() {
        // SubViews
        addSubview(imageFieldAndUploadView)
        imageFieldAndUploadView.addSubview(imageField)
        imageFieldAndUploadView.addSubview(uploadButton)
        imageField.addSubview(imageCountView)
        imageCountView.addSubview(imageCountButton)
        imageCountView.addSubview(imageCountLabel)
        
        // Constraint to arrange subviews acc. to imageView
        imageFieldAndUploadView.translatesAutoresizingMaskIntoConstraints = false
        imageField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountView.translatesAutoresizingMaskIntoConstraints = false
        imageCountButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ImageView Constraint
            imageFieldAndUploadView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            imageFieldAndUploadView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageFieldAndUploadView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageFieldAndUploadView.heightAnchor.constraint(equalToConstant: 300),
            
            // Image Constraint
            imageField.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 23),
            imageField.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            imageField.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            imageField.heightAnchor.constraint(equalToConstant: 212),
            
            // UploadButton Constraint
            uploadButton.topAnchor.constraint(equalTo: imageFieldAndUploadView.topAnchor),
            uploadButton.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            uploadButton.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 86),
            
            // MoreView Constraint
            imageCountView.bottomAnchor.constraint(equalTo: imageField.bottomAnchor, constant: -9),
            imageCountView.trailingAnchor.constraint(equalTo: imageField.trailingAnchor, constant: -9),
            imageCountView.widthAnchor.constraint(equalToConstant: 90),
            imageCountView.heightAnchor.constraint(equalToConstant: 30),
            
            // MoreButton Constraint
            imageCountButton.topAnchor.constraint(equalTo: imageCountView.topAnchor, constant: 0),
            imageCountButton.leadingAnchor.constraint(equalTo: imageCountView.leadingAnchor, constant: 2),
            imageCountButton.bottomAnchor.constraint(equalTo: imageCountView.bottomAnchor, constant: 0),
            imageCountButton.widthAnchor.constraint(equalToConstant: 60),
            
            // MoreLabel Constraint
            imageCountLabel.topAnchor.constraint(equalTo: imageCountView.topAnchor, constant: 0),
            imageCountLabel.leadingAnchor.constraint(equalTo: imageCountButton.trailingAnchor, constant: 0),
            imageCountLabel.trailingAnchor.constraint(equalTo: imageCountView.trailingAnchor, constant: -4),
            imageCountLabel.bottomAnchor.constraint(equalTo: imageCountView.bottomAnchor, constant: 0)
        ])
        
        // ImageCountView
        imageCountView.backgroundColor = .white
        imageCountView.layer.cornerRadius = 6
        imageCountView.layer.opacity = 0.9
        imageCountLabel.borderWidth = 0
        imageCountLabel.textAlignment = .center
        imageCountLabel.fontSize = 12
        
        imageField.backgroundColor = UIColor(hexString: "#F8F8F9")
        setImageField()
        
        imageCountButton.titleLabel?.textColor = UIColor(hexString: "#1464FF")
        imageCountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let moreButtonAttributedString = NSMutableAttributedString(string: "More")
        let moreButtonImageAttachment = NSTextAttachment()
        moreButtonImageAttachment.image = UIImage(named: "arrowRight")
        let moreButtonImageAttributedString = NSAttributedString(attachment: moreButtonImageAttachment)
        moreButtonAttributedString.append(NSAttributedString(string: " "))
        moreButtonAttributedString.append(moreButtonImageAttributedString)
        imageCountButton.setAttributedTitle(moreButtonAttributedString, for: .normal)
        imageCountButton.addTarget(self, action: #selector(imageCountTapped), for: .touchUpInside)
        
        // Sets UploadButton action with Image.
        uploadButton.image = UIImage(named: "uploadButton")
        
        imageField.cornerRadius = 10
        imageField.layer.masksToBounds = true
        imageField.isUserInteractionEnabled = true
    }
    
    // Fuction to set imageField according to pickedImage
    func setImageField() {
        if pickedImg.count == 0 {
            imageField.borderWidth = 1
            imageField.imageString = ""
            imageField.borderColor = UIColor(hexString: "#C0C1C6") ?? .lightGray
        } else {
            imageField.borderWidth = 0
            imageField.image = pickedImg.last
        }
    }
    
    // Action function for imageCountButton
    @objc func imageCountTapped() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                let newViewController = MultipleImageView()
                newViewController.transitioningDelegate = self
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.modalTransitionStyle = .crossDissolve
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
}
