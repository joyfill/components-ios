import Foundation
import UIKit

public class TableRow : UIView {
    
    public var countView = UIView()
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
        addSubview(countView)
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        countView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // CountView Constraint
            countView.topAnchor.constraint(equalTo: topAnchor),
            countView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            countView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            countView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
        
        collectionView.collectionView.bounces = false
        collectionView.collectionView.showsVerticalScrollIndicator = true
        collectionView.collectionView.layer.borderWidth = 1
        collectionView.collectionView.layer.cornerRadius = 14
        collectionView.collectionView.layer.borderColor = UIColor(hexString: "#C0C1C6")?.cgColor
    }
}

