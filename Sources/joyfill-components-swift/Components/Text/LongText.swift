import Foundation
import UIKit

open class LongText: UIView, UITextViewDelegate {
    
    public var view = UIView()
    public var topLabel = UILabel()
    public var textField = RichDisplayText()
    
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
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        topLabel.layer.borderWidth = 0
        topLabel.textColor = .black
        textField.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // SubViews
        view.addSubview(topLabel)
        view.addSubview(textField)
        self.addSubview(view)
        
        // Constraint to arrange subviews acc. to LongTextView
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            topLabel.topAnchor.constraint(equalTo: view.topAnchor),
            topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 17),
            
            textField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 13),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    
        textField.delegate = self
        textField.isScrollEnabled = false
    }
}
