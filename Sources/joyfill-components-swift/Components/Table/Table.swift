import Foundation
import UIKit

open class Table: UIView, UIViewControllerTransitioningDelegate {
    
    public var countLabel = Label()
    public var countView = UIView()
    public var floorsLabel = Label()
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
    
    func setupView() {
        // SubViews
        addSubview(countView)
        addSubview(collectionView)
        addSubview(floorsLabel)
        addSubview(toolTipIconButton)
        countView.addSubview(viewButton)
        countView.addSubview(countLabel)
        
        // Constraint to arrange subviews acc. to imageView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        countView.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        floorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // FloorsLabel Constraint
            floorsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            floorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            floorsLabel.heightAnchor.constraint(equalToConstant: 15),
            
            //TooltipIconButton
            toolTipIconButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            toolTipIconButton.leadingAnchor.constraint(equalTo: floorsLabel.trailingAnchor, constant: 5),
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
            collectionView.topAnchor.constraint(equalTo: floorsLabel.bottomAnchor, constant: 7),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
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
        
        floorsLabel.labelText = "Floors"
        floorsLabel.fontSize = 14
        floorsLabel.isTextBold = true
        
        toolTipIconButton.setImage(UIImage(named: "tooltipIcon"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        numberOfColumns = 3
        numberOfRows = 4
        collectionView.cellHeight = 37.5
        collectionView.cellWidth = 133.0
        tableHeading = ["First Floor", "Second Floor", "Third Floor"]
        collectionView.collectionView.layer.borderWidth = 1
        collectionView.collectionView.layer.cornerRadius = 14
        collectionView.collectionView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
        
        countLabel.labelText = "+\(numberOfRows - 1)"
        countLabel.textAlignment = .center
        countLabel.fontSize = 12
    }
    
    // Action function for viewButton
    @objc func viewButtonTapped() {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                let newViewController = ViewTable()
                newViewController.transitioningDelegate = self
                viewController.present(newViewController, animated: true, completion: nil)
                break
            }
        }
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
