
import UIKit
import SafariServices

// Shows the list of documents (not templates, rather submissions)
class DocumentsViewController: UIViewController {
    
    private let vm = DocumentsViewModel()
    
    // MARK: - Components
    private lazy var cv: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 150)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(DocumentCellView.self, forCellWithReuseIdentifier: "DocumentCellView")
        vw.dataSource = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
        
    }()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        vm.delegate = self
        vm.getDocuments()
        print("Go get documents....")
    
    }

}

extension DocumentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vm.documents[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCellView", for: indexPath) as! DocumentCellView
        
        cell.item = item
        cell.delegate = self
        
        return cell
    }

}

extension DocumentsViewController: DocumentsViewModelDelegate {
    
    func didFinish() {
        print("Documents retrieved: ", vm.documents)
        print("Got documents now reload...")
        cv.reloadData()
    }
    
    func didFail(_ error: Error) {
        print(error)
    }
    
}

extension DocumentsViewController: DocumentCollectionViewCellDelegate {
    
    func didTapSubscribe() {
        
        let vc = SFSafariViewController(url: .init(string: "https://www.youtube.com/@tundsdev")!)
        vc.modalPresentationStyle = .formSheet
        self.present(vc, animated: true)
    }
}

// MARK: - Composition
private extension DocumentsViewController {
    
    func setup() {
        
        navigationItem.title = "Documents"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
}
