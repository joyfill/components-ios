import Foundation
import UIKit

open class Table: UIView, UIViewControllerTransitioningDelegate {
    
    public var countLabel = Label()
    public var countView = UIView()
    public var floorsLabel = Label()
    public var viewButton = Button()
    public var collectionView = CollectionViewTable()
    
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
    
    func setupView() {
        // SubViews
        addSubview(countView)
        addSubview(collectionView)
        addSubview(floorsLabel)
        countView.addSubview(viewButton)
        countView.addSubview(countLabel)
        
        // Constraint to arrange subviews acc. to imageView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        countView.translatesAutoresizingMaskIntoConstraints = false
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        floorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // FloorsLabel Constraint
            floorsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            floorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            floorsLabel.widthAnchor.constraint(equalToConstant: 60),
            floorsLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // CountView Constraint
            countView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            countView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            countView.widthAnchor.constraint(equalToConstant: 90),
            countView.heightAnchor.constraint(equalToConstant: 30),
            
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
}
