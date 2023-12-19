
import UIKit

protocol DocumentCollectionViewCellDelegate: AnyObject {
    func didTapSubscribe()
}

class DocumentCellView: UICollectionViewCell {
    
    private var vw: DocumentView?
    weak var delegate: DocumentCollectionViewCellDelegate?
    
    var item: Document? {
        didSet {
            
            guard let firstName = item?.firstName,
                  let lastName = item?.lastName,
                  let email = item?.email else { return }
            
            vw?.set(name: "\(firstName) \(lastName)", email: email)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension DocumentCellView {
    
    func setup() {
        
        guard vw == nil else { return }
    
        vw = DocumentView { [weak self] in
            self?.delegate?.didTapSubscribe()
        }
        
        contentView.addSubview(vw!)
        
        NSLayoutConstraint.activate([
            vw!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            vw!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            vw!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            vw!.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
}
