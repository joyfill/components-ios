import Foundation
import UIKit

open class Table: UIView, UIViewControllerTransitioningDelegate {
    
    public var countLabel = Label()
    public var countView = UIView()
    public var titleLabel = Label()
    public var viewButton = Button()
    public var collectionView = CollectionViewTable()
    public var toolTipIconButton = UIButton()
    public var toolTipTitle = String()
    public var toolTipDescription = String()
    
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
    
    public func tooltipVisible(bool: Bool) {
        if bool {
            toolTipIconButton.isHidden = false
        } else {
            toolTipIconButton.isHidden = true
        }
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        countLabel.labelText = "+\(numberOfRows)"
    }
    
    func setupView() {
        // SubViews
        addSubview(countView)
        addSubview(collectionView)
        addSubview(titleLabel)
        addSubview(toolTipIconButton)
        countView.addSubview(viewButton)
        countView.addSubview(countLabel)
        
        // Constraint to arrange subviews acc. to imageView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        countView.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: toolTipIconButton.leadingAnchor, constant: -5),
            
            //TooltipIconButton
            toolTipIconButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            toolTipIconButton.trailingAnchor.constraint(lessThanOrEqualTo: countView.leadingAnchor, constant: -10),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            // CountView Constraint
            countView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            countView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            countView.widthAnchor.constraint(equalToConstant: 90),
            countView.heightAnchor.constraint(equalToConstant: 20),
            
            // ViewButton Constraint
            viewButton.topAnchor.constraint(equalTo: countView.topAnchor, constant: 0),
            viewButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor, constant: 2),
            viewButton.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: 0),
            viewButton.widthAnchor.constraint(equalToConstant: 60),
            
            // CountLabel Constraint
            countLabel.topAnchor.constraint(equalTo: countView.topAnchor, constant: 0),
            countLabel.leadingAnchor.constraint(equalTo: viewButton.trailingAnchor, constant: 0),
            countLabel.trailingAnchor.constraint(equalTo: countView.trailingAnchor, constant: -5),
            countLabel.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: 0),
            
            // TableView Constraint
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
        ])

        viewButton.titleLabel?.textColor = UIColor(hexString: "#1464FF")
        viewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        let moreButtonAttributedString = NSMutableAttributedString(string: "View")
        let moreButtonImageAttachment = NSTextAttachment()
        moreButtonImageAttachment.image = UIImage(named: "arrowRight")
        let moreButtonImageAttributedString = NSAttributedString(attachment: moreButtonImageAttachment)
        moreButtonAttributedString.append(NSAttributedString(string: "  "))
        moreButtonAttributedString.append(moreButtonImageAttributedString)
        viewButton.setAttributedTitle(moreButtonAttributedString, for: .normal)
        viewButton.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        
        titleLabel.fontSize = 14
        titleLabel.isTextBold = true
        titleLabel.numberOfLines = 0
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        collectionView.collectionView.layer.borderWidth = 1
        collectionView.collectionView.layer.cornerRadius = 14
        collectionView.collectionView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        numberOfRows = tableRowOrder.count
        
        countLabel.labelText = "+\(numberOfRows)"
        countLabel.textAlignment = .center
        countLabel.fontSize = 12
    }
    
    // Action function for viewButton
    @objc func viewButtonTapped() {
        var parentResponder: UIResponder? = self
        tableColumnTitle.insert("", at: 0)
        tableColumnTitle.insert("#", at: 1)
        tableColumnType.insert("", at: 0)
        tableColumnType.insert("#", at: 1)
        
        if tableRowOrder.count == 1 {
            valueData.removeLast(2)
        } else if tableRowOrder.count == 2 {
            valueData.removeLast(1)
        } else {}
        
        viewType = "modal"
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                viewController.modalPresentationStyle = .fullScreen
                let newViewController = ViewTable()
                newViewController.transitioningDelegate = self
                newViewController.modalPresentationStyle = .fullScreen
                newViewController.updateTitle(text: titleLabel.text ?? "")
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
