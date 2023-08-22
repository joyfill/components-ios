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
    public var titleButton = UILabel()
    public var titleImage = UILabel()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    public var tooltipView: TooltipView?
    
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
    
    public func imageDisplayModes(mode : String) {
        imageDisplayMode = mode
        if mode == "readonly" {
            titleButton.isHidden = true
            uploadButton.isHidden = true
            setupView()
        }else{
            titleButton.isHidden = false
            uploadButton.isHidden = false
            setupView()
        }
    }
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    func setupView() {
        // SubViews
        addSubview(imageFieldAndUploadView)
        imageFieldAndUploadView.addSubview(imageField)
        imageFieldAndUploadView.addSubview(toolTipIconButton)
        imageFieldAndUploadView.addSubview(uploadButton)
        imageField.addSubview(imageCountView)
        imageCountView.addSubview(imageCountButton)
        imageCountView.addSubview(imageCountLabel)
        imageFieldAndUploadView.addSubview(titleButton)
        imageFieldAndUploadView.addSubview(titleImage)
        
        
        // Constraint to arrange subviews acc. to imageView
        imageFieldAndUploadView.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        imageField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountView.translatesAutoresizingMaskIntoConstraints = false
        imageCountButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ImageView Constraint
            imageFieldAndUploadView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            imageFieldAndUploadView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageFieldAndUploadView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageFieldAndUploadView.heightAnchor.constraint(equalToConstant: 450),
            
            // TitleButton Constraint
            titleButton.topAnchor.constraint(equalTo: imageFieldAndUploadView.topAnchor, constant: 6),
            titleButton.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            titleButton.heightAnchor.constraint(equalToConstant: 20),
          
            //TooltipIconButton
            toolTipIconButton.topAnchor.constraint(equalTo: imageFieldAndUploadView.topAnchor, constant: 6),
            toolTipIconButton.leadingAnchor.constraint(equalTo: titleButton.trailingAnchor, constant: 10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 20),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 20),
            
            // UploadButton Constraint
            uploadButton.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 13),
            uploadButton.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            uploadButton.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            uploadButton.heightAnchor.constraint(equalToConstant: 86),
            
            // TitleImage Constraint
            titleImage.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 35),
            titleImage.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            titleImage.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            
            // Image Constraint
            imageField.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 11),
            imageField.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            imageField.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            imageField.heightAnchor.constraint(equalToConstant: 212),
            
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
        uploadButton.addTarget(self, action: #selector(imageUploadButtonTapped), for: .touchUpInside)
        
        imageField.cornerRadius = 10
        imageField.layer.masksToBounds = true
        imageField.isUserInteractionEnabled = true
        
        titleButton.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleButton.text = "Empty Image Field"
        
        titleImage.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleImage.text = "Image Field With Images"
        
        toolTipIconButton.setImage(UIImage(named: "Info"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipIconButton.isSelected = !toolTipIconButton.isSelected
        let selected = toolTipIconButton.isSelected
        // Create the tooltip view
        if selected == true {
            tooltipView = TooltipView()
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.addSubview(tooltipView!)
                
                tooltipView?.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    tooltipView!.bottomAnchor.constraint(equalTo: toolTipIconButton.topAnchor, constant: -5),
                    tooltipView!.centerXAnchor.constraint(equalTo: toolTipIconButton.centerXAnchor),
                    tooltipView!.widthAnchor.constraint(equalToConstant: 150),
                ])
                
                tooltipView?.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.tooltipView?.alpha = 1
                }
                tooltipView?.titleText.text = toolTipTitle
                tooltipView?.descriptionText.text = toolTipDescription
            }
        } else {
            tooltipView?.removeFromSuperview()
        }
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
    
    // MARK: Functions to access and fetch image from camera and gallery.
    @objc public func imageUploadButtonTapped() {
        guard let viewController = self.findImageViewController() else {
            return
        }
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openImageCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openImageGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public func findImageViewController() -> UIViewController? {
        var responder: UIResponder? = self
        
        while let currentResponder = responder {
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
            responder = currentResponder.next
        }
        return nil
    }
    
    public func openImageCamera() {
        guard let viewController = self.findImageViewController() else {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public func openImageGallery() {
        guard let viewController = self.findImageViewController() else {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
        }  else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let viewController = self.findImageViewController() else {
            return
        }
        viewController.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImg.append(pickedImage)
            imageCountLabel.labelText = "+\(pickedImg.count)"
            imageField.image = pickedImage
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let viewController = self.findImageViewController() else {
            return
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}
