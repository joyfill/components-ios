
import UIKit

// List of documents (not templates rather submissions)
class DocumentView: UIView {
    
    // MARK: - Components
    private lazy var viewBtn: UIButton = {
        
        var config = UIButton.Configuration.filled()
        config.title = "View"
        config.baseBackgroundColor = .systemBlue.withAlphaComponent(0.08)
        config.baseForegroundColor = .systemBlue
        config.buttonSize = .medium
        config.cornerStyle = .medium
        
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
        
    }()
    
    private lazy var nameLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = .systemFont(ofSize: 16, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
    private lazy var idLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
        
    }()
    
    private lazy var createdOnLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
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
    
    func set(name: String, id: String, createdOn: String) {
        nameLbl.text = "\(name)"
        createdOnLbl.text = "Created: \(createdOn)"
        idLbl.text = "Identifier: \(id.suffix(8))"
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
        documentStackVw.addArrangedSubview(createdOnLbl)
        documentStackVw.addArrangedSubview(idLbl)
        documentStackVw.addArrangedSubview(viewBtn)
        
        NSLayoutConstraint.activate([
            documentStackVw.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            documentStackVw.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            documentStackVw.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            documentStackVw.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        viewBtn.addTarget(self,
                               action: #selector(didTapView),
                               for: .touchUpInside)
        
    }
    
    // @objc only required for legacy btn target methods
    @objc func didTapView(sender: UIButton) {
        completion()
    }

}
