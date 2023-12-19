
import UIKit

// List of documents (not templates rather submissions)
class DocumentView: UIView {
    
    // MARK: - Components
    private lazy var subscribeBtn: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.title = "Subscribe".uppercased()
        config.baseBackgroundColor = UIColor.red
        config.baseForegroundColor = UIColor.white
        config.buttonSize = .large
        config.cornerStyle = .medium
        
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
        
    }()
    
    private lazy var nameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "Billy Bob"
        lbl.font = .systemFont(ofSize: 18, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
    private lazy var emailLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.text = "bill.bill@s.com"
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
    private lazy var documentStackVw: UIStackView = {
        
        let vw = UIStackView()
        vw.axis = .vertical
        vw.spacing = 8
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
        
    }()
    
    // MARK: - Lifecycles
    private var completion: () -> ()
    
    init(completion: @escaping () -> ()) {
        self.completion = completion
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(name: String, email: String) {
        nameLbl.text = name
        emailLbl.text = email
    }
    
}

// MARK: - Composition
private extension DocumentView {
    
    func setup() {
        
        self.layer.cornerRadius = 10
        self.backgroundColor = .gray.withAlphaComponent(0.1)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(documentStackVw)
        
        documentStackVw.addArrangedSubview(nameLbl)
        documentStackVw.addArrangedSubview(emailLbl)
        documentStackVw.addArrangedSubview(subscribeBtn)
        
        NSLayoutConstraint.activate([
            documentStackVw.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            documentStackVw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            documentStackVw.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            documentStackVw.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        subscribeBtn.addTarget(self,
                               action: #selector(didTapSubscribe),
                               for: .touchUpInside)
        
    }
    
    // @objc only required for legacy btn target methods
    @objc func didTapSubscribe(sender: UIButton) {
        completion()
    }

}
