import Foundation
import UIKit

open class DisplayText: UIView {
    
    public var view = UIView()
    public var label = Label()
    
    public var index = Int()
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public func indexPath(index: Int, borderWidth: CGFloat) {
        setupView(index: index, borderWidth: borderWidth)
    }
    
    func setupView(index: Int, borderWidth: CGFloat) {
        // SubViews
        addSubview(view)
        view.addSubview(label)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: borderWidth),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: borderWidth + 5),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(borderWidth + 5)),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(borderWidth + 5))
            
        ])
    }
}
