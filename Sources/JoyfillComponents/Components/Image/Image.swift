import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

protocol saveImageFieldValue {
    func handleUpload(indexPath: Int)
    func handleDelete(indexPath: Int)
}

open class Image: UIView, UIViewControllerTransitioningDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public var uploadButton = Button()
    public var titleButton = UILabel()
    public var toolTipTitle = String()
    public var imageField = ImageView()
    public var imageCountLabel = Label()
    public var imageCountView = UIView()
    public var imageCountButton = Button()
    public var toolTipDescription = String()
    public var toolTipIconButton = UIButton()
    public var imageFieldAndUploadView = UIView()

    public var index = Int()
    public var imageMultiValue = Bool()
    public var imageDisplayMode = String()
    public var selectedImage = [[String]]()
    public var pickedSingleImg = [[String]]()
    weak var delegate: MultipleImageViewDelegate?
    var saveDelegate: saveImageFieldValue? = nil
    var fieldDelegate: SaveTextFieldValue? = nil
    
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
        checkImageCount()
    }
    
    public func imageDisplayModes(mode : String) {
        imageDisplayMode = mode
    }
    
    public func allowMultipleImages(value : Bool) {
        imageMultiValue = value
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
        
        // Constraint to arrange subviews acc. to imageView
        imageFieldAndUploadView.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        imageField.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountView.translatesAutoresizingMaskIntoConstraints = false
        imageCountButton.translatesAutoresizingMaskIntoConstraints = false
        imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ImageView Constraint
            imageFieldAndUploadView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageFieldAndUploadView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imageFieldAndUploadView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imageFieldAndUploadView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            // TitleButton Constraint
            titleButton.topAnchor.constraint(equalTo: imageFieldAndUploadView.topAnchor),
            titleButton.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            titleButton.heightAnchor.constraint(equalToConstant: 15),
            
            //TooltipIconButton
            toolTipIconButton.leadingAnchor.constraint(equalTo: titleButton.trailingAnchor, constant: 5),
            toolTipIconButton.topAnchor.constraint(equalTo: imageFieldAndUploadView.topAnchor, constant: 13),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // UploadButton Constraint
            uploadButton.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 13),
            uploadButton.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            uploadButton.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: imageFieldAndUploadView.bottomAnchor, constant: -10),
            
            // Image Constraint
            imageField.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 13),
            imageField.leadingAnchor.constraint(equalTo: imageFieldAndUploadView.leadingAnchor),
            imageField.trailingAnchor.constraint(equalTo: imageFieldAndUploadView.trailingAnchor),
            imageField.bottomAnchor.constraint(equalTo: imageFieldAndUploadView.bottomAnchor, constant: -10),
            
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
        
        setGlobalUserInterfaceStyle()
        
        // ImageCountView
        imageCountView.backgroundColor = .white
        imageCountView.layer.cornerRadius = 6
        imageCountView.layer.opacity = 0.9
        imageCountLabel.borderWidth = 0
        imageCountLabel.textAlignment = .center
        imageCountLabel.fontSize = 12
        
        imageField.backgroundColor = UIColor(hexString: "#F8F8F9")
        
        imageCountButton.titleLabel?.textColor = UIColor(hexString: "#1464FF")
        imageCountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let moreButtonAttributedString = NSMutableAttributedString(string: "More")
        let moreButtonImageAttachment = NSTextAttachment()
        moreButtonImageAttachment.image = UIImage(named: "arrowRight", in: .module, compatibleWith: nil)
        let moreButtonImageAttributedString = NSAttributedString(attachment: moreButtonImageAttachment)
        moreButtonAttributedString.append(NSAttributedString(string: " "))
        moreButtonAttributedString.append(moreButtonImageAttributedString)
        imageCountButton.setAttributedTitle(moreButtonAttributedString, for: .normal)
        imageCountButton.addTarget(self, action: #selector(imageCountTapped), for: .touchUpInside)
        
        // Sets UploadButton action with Image.
        uploadButton.image = UIImage(named: "uploadButton", in: .module, compatibleWith: nil)
        
        imageField.cornerRadius = 10
        imageField.layer.masksToBounds = true
        imageField.isUserInteractionEnabled = true
        titleButton.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon", in: .module, compatibleWith: nil), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
    
    public func checkImageCount() {
        if selectedImage[index].count == 0 {
            imageField.isHidden = true
            uploadButton.isHidden = false
            
            imageField.borderWidth = 1
            imageField.imageString = ""
            imageField.borderColor = UIColor(hexString: "#C0C1C6") ?? .lightGray
            
        } else {
            imageField.isHidden = false
            uploadButton.isHidden = true
            imageField.borderWidth = 0
            checkForMulti()
        }
    }
    
    public func checkForMulti() {
        if imageMultiValue {
            imageField.load(urlString: selectedImage[index].first ?? "")
            imageCountLabel.labelText = "+\(selectedImage[index].count)"
        } else {
            imageField.load(urlString: pickedSingleImg[index].first ?? "")
            imageCountLabel.labelText = "+\(pickedSingleImg[index].count)"
        }
    }
    
    // Action function for imageCountButton
    @objc func imageCountTapped() {
        fieldDelegate?.handleFocus(index: index)
        if let parentViewController = parentViewController {
            let newViewController = MultipleImageView()
            newViewController.index = index
            newViewController.delegate = self
            newViewController.saveDelegate = saveDelegate
            newViewController.fieldDelegate = fieldDelegate
            newViewController.selectedImage = selectedImage
            newViewController.imageMultiValue = imageMultiValue
            newViewController.pickedSingleImg = pickedSingleImg
            newViewController.imageDisplayMode = imageDisplayMode
            newViewController.modalTransitionStyle = .crossDissolve
            parentViewController.view.addSubview(newViewController.view)
            newViewController.view.frame = parentViewController.view.bounds
            parentViewController.addChild(newViewController)
            newViewController.didMove(toParent: parentViewController)
        }
    }
}

extension Image: MultipleImageViewDelegate {
    func imagesDeleted(selectedIndex: Int) {
        updateDeletedImage(selectedIndex: selectedIndex)
        joyDoc.reloadData()
        self.saveDelegate?.handleDelete(indexPath: index)
    }
    
    func imagesUpdated() {
        checkImageCount()
    }
    
    func removeAllImages() {
        selectedImage[index].removeAll()
        pickedSingleImg[index].removeAll()
        uploadedImageCount[index].removeAll()
        uploadedSingleImage[index].removeAll()
        uploadedMultipleImage[index].removeAll()
        let indexPathsToReload = [IndexPath(row: index, section: 0)]
        joyDoc.reloadRows(at: indexPathsToReload, with: .fade)
        self.saveDelegate?.handleDelete(indexPath: index)
    }
    
    // Update updated value in the joyDoc
    func updateDeletedImage(selectedIndex: Int) {
        let value = joyDocFieldData[index].value
        switch value {
        case .string(_): break
        case .integer(_): break
        case .valueElementArray(var valueElements):
            valueElements.remove(at: selectedIndex)
            joyDocFieldData[index].value = ValueUnion.valueElementArray(valueElements)
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        if let indexValue = joyDocStruct?.fields?.firstIndex(where: {$0.id == joyDocFieldData[index].id}) {
            let modelValue = joyDocStruct?.fields?[indexValue].value
            switch modelValue {
            case .string(_): break
            case .integer(_): break
            case .valueElementArray(var valueElements):
                valueElements.remove(at: selectedIndex)
                joyDocStruct?.fields?[indexValue].value = ValueUnion.valueElementArray(valueElements)
            case .array(_): break
            case .none: break
            case .some(.null): break
            }
        }
    }
}

