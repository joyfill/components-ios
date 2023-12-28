import Foundation
import UIKit

public class FieldForm: UIView, UITableViewDelegate, UITableViewDataSource {
    
    public var viewBackg = UIView()
    public var tableView = UITableView()
    
    public var cellCount = Int()
    
    // MARK: - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(viewBackg)
        viewBackg.addSubview(tableView)
        viewBackg.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewBackg.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            viewBackg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            viewBackg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            viewBackg.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: viewBackg.topAnchor, constant: 9),
            tableView.leadingAnchor.constraint(equalTo: viewBackg.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: viewBackg.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: viewBackg.bottomAnchor, constant: -10)
        ])
        
        backgroundColor = .white
        viewBackg.backgroundColor = .white
        viewBackg.layer.cornerRadius = 15
        viewBackg.layer.shadowOpacity = 0.3
        viewBackg.layer.shadowRadius = 3.0
        viewBackg.layer.shadowColor = UIColor.black.cgColor
        viewBackg.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let shortText = ShortText()
        shortText.frame = CGRect(x: 10, y: 0, width: tableView.bounds.width - 20, height: 80)
        shortText.topLabel.labelText = "Text Field"
        shortText.textField.fieldText = "Jane Doe"
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(shortText)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
