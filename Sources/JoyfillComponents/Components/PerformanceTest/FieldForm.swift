import Foundation
import UIKit

public class FieldForm: UIView, UITableViewDelegate, UITableViewDataSource {
    
    public var backgroundView = UIView()
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
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            backgroundView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 9),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])
        
        backgroundColor = .white
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.shadowOpacity = 0.3
        backgroundView.layer.shadowRadius = 3.0
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        
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
