import Foundation
import UIKit

public class TooltipView : UIView {
    public  let toolTipView = UIView()
    public let backgroundImage = UIImageView()
    public let viewText = UIView()
    public let titleText = UILabel()
    public let descriptionText = UILabel()
    
    // Initializer
    public init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        toolTipView.addSubview(backgroundImage)
        backgroundImage.addSubview(viewText)
        viewText.addSubview(titleText)
        viewText.addSubview(descriptionText)
        addSubview(toolTipView)
        bringSubviewToFront(toolTipView)
        layoutIfNeeded()
        
        toolTipView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        viewText.translatesAutoresizingMaskIntoConstraints = false
        titleText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints =  false
        
        NSLayoutConstraint.activate([
            backgroundImage.bottomAnchor.constraint(equalTo: toolTipView.bottomAnchor, constant: 5),
            backgroundImage.centerXAnchor.constraint(equalTo: toolTipView.centerXAnchor),
            backgroundImage.widthAnchor.constraint(equalToConstant: 30),
            
            viewText.topAnchor.constraint(equalTo: toolTipView.topAnchor, constant: 5),
            viewText.bottomAnchor.constraint(equalTo: toolTipView.bottomAnchor, constant: -8),
            viewText.trailingAnchor.constraint(equalTo: toolTipView.trailingAnchor, constant: -5),
            viewText.leadingAnchor.constraint(equalTo: toolTipView.leadingAnchor, constant: 5),
            
            titleText.topAnchor.constraint(equalTo: viewText.topAnchor, constant: 10),
            titleText.trailingAnchor.constraint(equalTo: viewText.trailingAnchor, constant: -10),
            titleText.leadingAnchor.constraint(equalTo: viewText.leadingAnchor, constant: 10),
            titleText.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 3),
            descriptionText.bottomAnchor.constraint(equalTo: viewText.bottomAnchor, constant: -10),
            descriptionText.trailingAnchor.constraint(equalTo: viewText.trailingAnchor, constant: -10),
            descriptionText.leadingAnchor.constraint(equalTo: viewText.leadingAnchor, constant: 10),
            
            toolTipView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            toolTipView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5),
            toolTipView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        toolTipView.backgroundColor = .clear
        toolTipView.layer.shadowOpacity = 0.3
        toolTipView.layer.shadowRadius = 3.0
        toolTipView.layer.shadowColor = UIColor.black.cgColor
        toolTipView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        toolTipView.alpha = 1.0
        
        backgroundImage.image = UIImage(named: "tooltip-arrow")
        backgroundImage.contentMode = .scaleAspectFit
        
        viewText.backgroundColor = UIColor(hexString: "#FDFDFD")
        viewText.layer.cornerRadius = 5
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.borderWidth = 2
        
        titleText.backgroundColor = UIColor(hexString: "#FDFDFD")
        titleText.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleText.textColor = .black
        
        descriptionText.backgroundColor = UIColor(hexString: "#FDFDFD")
        descriptionText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        descriptionText.textColor = .black
        descriptionText.numberOfLines = 0
    }
}
