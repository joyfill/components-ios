import Foundation
import UIKit

open class LongText: UIView, UITextViewDelegate {
    
    public var view = UIView()
    public var topLabel = Label()
    public var textField = RichDisplayText()
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
        topLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        topLabel.borderWidth = 0
        topLabel.textColor = .black
        textField.backgroundColor = .clear
        
        view.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // SubViews
        view.addSubview(topLabel)
        view.addSubview(toolTipIconButton)
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
            topLabel.heightAnchor.constraint(equalToConstant: 15),
            
            toolTipIconButton.topAnchor.constraint(equalTo: view.topAnchor),
            toolTipIconButton.leadingAnchor.constraint(equalTo: topLabel.trailingAnchor, constant: 5),
            toolTipIconButton.heightAnchor.constraint(equalToConstant: 15),
            toolTipIconButton.widthAnchor.constraint(equalToConstant: 15),
            
            textField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 13),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        toolTipIconButton.setImage(UIImage(named: "information"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
        
        textField.delegate = self
        textField.isScrollEnabled = false
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
