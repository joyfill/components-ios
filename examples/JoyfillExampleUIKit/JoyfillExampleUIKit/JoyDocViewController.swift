//
//import UIKit
//
//class JoyDocViewController: UIViewController {
//    
//    // MARK: - Components
//    private lazy var documentVw: DocumentView = {
//        
//        let vw = DocumentView { [weak self] in
//            print("hello")
//        }
//        return vw
//        
//    }()
//    
//    // MARK: - Lifecycles
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("test")
//        setup()
//    }
//    
//    
//}
//
//// MARK: - Composition
//private extension JoyDocViewController {
//    
//    func setup() {
//        
//        self.view.backgroundColor = .white
//        
//        self.view.addSubview(documentVw)
//        
//        NSLayoutConstraint.activate([
//            documentVw.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            documentVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            documentVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//        ])
//        
//    }
//    
//}
//
