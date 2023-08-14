import UIKit

@available(iOS 13.0, *)
class SignatureViewController: UIViewController {
    
    public var signatureView = Signature()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(signatureView)
        
        signatureView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signatureView.topAnchor.constraint(equalTo: view.topAnchor),
            signatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signatureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
