
import UIKit

protocol DocumentCollectionViewCellDelegate: AnyObject {
    func didTapView(item: Document)
}

class DocumentCellView: UICollectionViewCell {
    
    private var vw: DocumentView?
    weak var delegate: DocumentCollectionViewCellDelegate?
    
    var item: Document? {
        didSet {
            
            guard let name = item?.name,
                  let id = item?.identifier,
                  let createdOn = item?.createdOn else { return }
            
            // Quick reformat from milliseconds Int date to Swift Date then back to formatted string
            let createdOnSeconds: Double = TimeInterval(createdOn / 1000)
            let createdOnDate = Date(timeIntervalSince1970: createdOnSeconds)
            let createdOnFormatted = DateFormatter()
            createdOnFormatted.dateFormat = "MMM d, yy h:mma"
            
            vw?.set(name: name, id: id, createdOn: createdOnFormatted.string(from: createdOnDate))
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
            self?.delegate?.didTapView(item: self!.item!)
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
