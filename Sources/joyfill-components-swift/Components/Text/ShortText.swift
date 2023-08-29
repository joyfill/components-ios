import Foundation
import UIKit

open class ShortText: UIView {
    
    public var view = UIView()
    public var topLabel = Label()
    public var textField = TextField()
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
        textField.borderColor = UIColor(hexString: "#D1D1D6") ?? .lightGray
        
        let insets = UIEdgeInsets(top: 13, left: 15, bottom: 13, right: 10)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: textField.frame.width, height: textField.frame.height + insets.top + insets.bottom))
        container.layoutMargins = insets
        textField.inputAccessoryView = container
        
        view.translatesAutoresizingMaskIntoConstraints = false
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        toolTipIconButton.translatesAutoresizingMaskIntoConstraints = false
        
        // SubViews
        view.addSubview(topLabel)
        view.addSubview(toolTipIconButton)
        view.addSubview(textField)
        self.addSubview(view)
        
        // Constraint to arrange subviews acc. to ShortTextView
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
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        toolTipIconButton.setImage(UIImage(named: "information"), for: .normal)
        toolTipIconButton.addTarget(self, action: #selector(tooltipButtonTapped), for: .touchUpInside)
    }
    
    @objc func tooltipButtonTapped(_ sender: UIButton) {
        toolTipAlertShow(for: self, title: toolTipTitle, message: toolTipDescription)
    }
}
