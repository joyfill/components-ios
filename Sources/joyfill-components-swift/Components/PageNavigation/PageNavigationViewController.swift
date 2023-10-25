import Foundation
import UIKit

protocol SavePageNavigationChange {
    func handlePageDelete(pageId: String)
    func handlePageDuplicate(change: [String: Any], fieldChange: [[String: Any]])
}

class PageNavigationViewController: UIViewController {
    
    var fieldsData = [[String: Any]]()
    var saveDelegate: SavePageNavigationChange? = nil
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Actions"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#75767E")
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor(hexString: "#0066FF"), for: .normal)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var duplicatePageView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        view.layer.borderColor = UIColor(hexString: "#E4E5E8")?.cgColor
        return view
    }()
    
    lazy var duplicatePageImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "duplicatePage")
        return image
    }()
    
    lazy var duplicatePageLabel: UILabel = {
        let label = UILabel()
        label.text = "Duplicate Page"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var deletePageView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexString: "#F5F5F5")
        view.layer.borderColor = UIColor(hexString: "#E4E5E8")?.cgColor
        return view
    }()
    
    lazy var deletePageImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "deletePage")
        return image
    }()
    
    lazy var deletePageLabel: UILabel = {
        let label = UILabel()
        label.text = "Delete Page"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0.6
        view.backgroundColor = .black
        return view
    }()
    
    lazy var pagesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Pages"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(hexString: "#75767E")
        return label
    }()
    
    lazy var pagesOptionTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor(hexString: "#F5F5F5")
        tableView.layer.borderColor = UIColor(hexString: "#E4E5E8")?.cgColor
        tableView.register(PageNavigationTableViewCell.self, forCellReuseIdentifier: "PageNavigationTableViewCell")
        return tableView
    }()
    
    // Constants
    let defaultHeight: CGFloat = 500
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        if #available(iOS 13.0, *) {
            view.overrideUserInterfaceStyle = .light
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0.6
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // Add subviews
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(duplicatePageView)
        containerView.addSubview(deletePageView)
        containerView.addSubview(pagesTitleLabel)
        containerView.addSubview(pagesOptionTableView)
        duplicatePageView.addSubview(duplicatePageImage)
        duplicatePageView.addSubview(duplicatePageLabel)
        deletePageView.addSubview(deletePageImage)
        deletePageView.addSubview(deletePageLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        deletePageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        pagesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        deletePageImage.translatesAutoresizingMaskIntoConstraints = false
        deletePageLabel.translatesAutoresizingMaskIntoConstraints = false
        duplicatePageView.translatesAutoresizingMaskIntoConstraints = false
        duplicatePageImage.translatesAutoresizingMaskIntoConstraints = false
        duplicatePageLabel.translatesAutoresizingMaskIntoConstraints = false
        pagesOptionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // BackgroundView Constraints
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ContainerView Constraints
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // TitleLabel Constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 52),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // CloseButton Constraints
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 52),
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            
            // DuplicatePageView Constraints
            duplicatePageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            duplicatePageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            duplicatePageView.widthAnchor.constraint(equalToConstant: 110),
            duplicatePageView.heightAnchor.constraint(equalToConstant: 64),
            
            // DuplicatePageImage Constraints
            duplicatePageImage.topAnchor.constraint(equalTo: duplicatePageView.topAnchor, constant: 11),
            duplicatePageImage.leadingAnchor.constraint(equalTo: duplicatePageView.leadingAnchor, constant: 45),
            duplicatePageImage.trailingAnchor.constraint(equalTo: duplicatePageView.trailingAnchor, constant: -45),
            duplicatePageImage.heightAnchor.constraint(equalToConstant: 20),
            
            // DuplicatePageLabel Constraints
            duplicatePageLabel.topAnchor.constraint(equalTo: duplicatePageImage.bottomAnchor, constant: 3),
            duplicatePageLabel.leadingAnchor.constraint(equalTo: duplicatePageView.leadingAnchor, constant: 12),
            duplicatePageLabel.trailingAnchor.constraint(equalTo: duplicatePageView.trailingAnchor, constant: -12),
            duplicatePageLabel.bottomAnchor.constraint(equalTo: duplicatePageView.bottomAnchor, constant: -13),
            
            // DeletePageView Constraints
            deletePageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            deletePageView.leadingAnchor.constraint(equalTo: duplicatePageView.trailingAnchor, constant: 6),
            deletePageView.widthAnchor.constraint(equalToConstant: 110),
            deletePageView.heightAnchor.constraint(equalToConstant: 64),
            
            // DeletePageImage Constraints
            deletePageImage.topAnchor.constraint(equalTo: deletePageView.topAnchor, constant: 11),
            deletePageImage.leadingAnchor.constraint(equalTo: deletePageView.leadingAnchor, constant: 45),
            deletePageImage.trailingAnchor.constraint(equalTo: deletePageView.trailingAnchor, constant: -45),
            deletePageImage.heightAnchor.constraint(equalToConstant: 20),
            
            // DeletePageLabel Constraints
            deletePageLabel.topAnchor.constraint(equalTo: deletePageImage.bottomAnchor, constant: 3),
            deletePageLabel.leadingAnchor.constraint(equalTo: deletePageView.leadingAnchor, constant: 12),
            deletePageLabel.trailingAnchor.constraint(equalTo: deletePageView.trailingAnchor, constant: -12),
            deletePageLabel.bottomAnchor.constraint(equalTo: deletePageView.bottomAnchor, constant: -13),
            
            // PagesTitleLabel Constraints
            pagesTitleLabel.topAnchor.constraint(equalTo: duplicatePageView.bottomAnchor, constant: 10),
            pagesTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            pagesTitleLabel.widthAnchor.constraint(equalToConstant: 52),
            pagesTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // PagesOptionTableView Constraints
            pagesOptionTableView.topAnchor.constraint(equalTo: pagesTitleLabel.bottomAnchor, constant: 10),
            pagesOptionTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            pagesOptionTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            pagesOptionTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Sets height and width to ContainerView
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        checkForPageCountToHandleDeletePageViewState()
        let duplicatePageTapGesture = UITapGestureRecognizer(target: self, action: #selector(duplicatePageTapped))
        duplicatePageView.addGestureRecognizer(duplicatePageTapGesture)
        
        let deletePageTapGesture = UITapGestureRecognizer(target: self, action: #selector(deletePageTapped))
        deletePageView.addGestureRecognizer(deletePageTapGesture)
    }
    
    // Action function for close button
    @objc func closeTapped() {
        dismissNavigationController()
    }
    
    // Function to close navigation modal
    func dismissNavigationController() {
        backgroundView.alpha = 0.6
        UIView.animate(withDuration: 0.4) {
            self.backgroundView.alpha = 0
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // Action performed to duplicate page
    @objc func duplicatePageTapped() {
        if joyDocStruct?.files?[0].views?.count == 0 {
            // For Primary View
            if let indx = joyDocStruct?.files?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].pageOrder?[pageIndex])}) {
                let newPageId = generateObjectId()
                let itemToDuplicate = (joyDocPageData?[indx])!
                
                joyDocPageData?.insert(itemToDuplicate, at: indx + 1)
                joyDocStruct?.files?[0].pages?.insert(itemToDuplicate, at: indx + 1)
                joyDocStruct?.files?[0].pages?[indx + 1].id = newPageId
                
                // Update page id with new generated id
                joyDocPageData?[indx + 1].id = newPageId
                joyDocPageOrderId.insert(newPageId, at: pageIndex + 1)
                joyDocStruct?.files?[0].pageOrder?.insert(newPageId, at: pageIndex + 1)
                
                // Check pageId and update fieldId with new generated id
                if let indx = joyDocStruct?.files?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].pageOrder?[indx + 1])}) {
                    if let fieldPositions = joyDocStruct?.files?[0].pages?[indx].fieldPositions {
                        var modifiedPositions = fieldPositions
                        for i in 0..<fieldPositions.count {
                            let newFieldId = generateObjectId()
                            modifiedPositions[i].field = newFieldId
                        }
                        joyDocPageData?[indx].fieldPositions = modifiedPositions
                        joyDocStruct?.files?[0].pages?[indx].fieldPositions = modifiedPositions
                    }
                }
                
                sendDuplicatedDataToChangeLogs(indx: indx)
            }
            
        } else {
            // For Mobile View
            if let indx = joyDocStruct?.files?[0].views?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].views?[0].pageOrder?[pageIndex])}) {
                let newPageId = generateObjectId()
                let itemToDuplicate = (joyDocPageData?[indx])!
                
                joyDocPageData?.insert(itemToDuplicate, at: indx + 1)
                joyDocStruct?.files?[0].views?[0].pages?.insert(itemToDuplicate, at: indx + 1)
                joyDocStruct?.files?[0].views?[0].pages?[indx + 1].id = newPageId
                
                // Update page id with new generated id
                joyDocPageData?[indx + 1].id = newPageId
                joyDocPageOrderId.insert(newPageId, at: pageIndex + 1)
                joyDocStruct?.files?[0].views?[0].pageOrder?.insert(newPageId, at: pageIndex + 1)
                
                // Check pageId and update fieldId with new generated id
                if let indx = joyDocStruct?.files?[0].views?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].views?[0].pageOrder?[indx + 1])}) {
                    if let fieldPositions = joyDocStruct?.files?[0].views?[0].pages?[indx].fieldPositions {
                        var modifiedPositions = fieldPositions
                        for i in 0..<fieldPositions.count {
                            let newFieldId = generateObjectId()
                            modifiedPositions[i].field = newFieldId
                        }
                        joyDocPageData?[indx].fieldPositions = modifiedPositions
                        joyDocStruct?.files?[0].views?[0].pages?[indx].fieldPositions = modifiedPositions
                    }
                }
                
                sendDuplicatedDataToChangeLogs(indx: indx)
            }
        }
    }
    
    func sendDuplicatedDataToChangeLogs(indx: Int) {
        // Get joyDocField of page to duplicate based on id
        for i in 0..<joyDocFieldData.count {
            if let _ = joyDocPageData?[indx + 1].fieldPositions?.first(where: { $0.field != joyDocFieldData[i].id }) {
                do {
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.outputFormatting = .prettyPrinted
                    let fieldsDataToJson = try jsonEncoder.encode(joyDocFieldData[i])
                    if var jsonObject = try JSONSerialization.jsonObject(with: fieldsDataToJson, options: []) as? [String: Any] {
                        jsonObject["_id"] = joyDocPageData?[indx + 1].fieldPositions?[i].field
                        joyDocFieldData[i].id = joyDocPageData?[indx + 1].fieldPositions?[i].field
                        fieldsData.append(jsonObject)
                        joyDocStruct?.fields?.append(joyDocFieldData[i])
                    }
                } catch {
                    print("Error encoding the Page struct to JSON: \(error)")
                }
            }
        }
        
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let jsonData = try jsonEncoder.encode(joyDocPageData?[indx + 1])
            if let pagesDataToJson = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                let change = ["page": pagesDataToJson,
                              "targetIndex": pageIndex + 1] as [String : Any]
                self.saveDelegate?.handlePageDuplicate(change: change, fieldChange: fieldsData)
            }
        } catch {
            print("Error encoding the Page struct to JSON: \(error)")
        }
        
        fetchDataFromJoyDoc()
        deletePageView.isHidden = false
        DispatchQueue.main.async {
            componentTableView.reloadData()
        }
        pagesOptionTableView.reloadData()
    }
    
    // Action performed to delete page
    @objc func deletePageTapped() {
        if joyDocStruct?.files?[0].views?.count == 0 {
            if let indx = joyDocStruct?.files?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].pageOrder?[pageIndex])}) {
                self.saveDelegate?.handlePageDelete(pageId: joyDocPageData?[indx].id ?? "")
                joyDocStruct?.files?[0].pages?.remove(at: indx)
                joyDocPageData?.remove(at: indx)
                joyDocStruct?.files?[0].pageOrder?.remove(at: pageIndex)
            }
        } else {
            if let indx = joyDocStruct?.files?[0].views?[0].pages?.firstIndex(where: {$0.id == (joyDocStruct?.files?[0].views?[0].pageOrder?[pageIndex])}) {
                self.saveDelegate?.handlePageDelete(pageId: joyDocPageData?[indx].id ?? "")
                joyDocStruct?.files?[0].views?[0].pages?.remove(at: indx)
                joyDocPageData?.remove(at: indx)
                joyDocStruct?.files?[0].views?[0].pageOrder?.remove(at: pageIndex)
            }
        }

        pageIndex = pagesOptionTableView.indexPathForSelectedRow?.row ?? 0
        fetchDataFromJoyDoc()
        DispatchQueue.main.async {
            componentTableView.reloadData()
        }
        deletePageView.isHidden = false
        pagesOptionTableView.reloadData()
        checkForPageCountToHandleDeletePageViewState()
    }
    
    func checkForPageCountToHandleDeletePageViewState() {
        if joyDocPageOrderId.count == 1 {
            deletePageView.isHidden = true
        } else {
            deletePageView.isHidden = false
        }
    }
}

extension PageNavigationViewController: UITableViewDelegate, UITableViewDataSource {
    //Table class extension to add tableview delegate and dataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joyDocPageOrderId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageNavigationTableViewCell", for: indexPath as IndexPath) as! PageNavigationTableViewCell
        tableView.rowHeight = 40
        
        var cellLabelValue = [Int]()
        for i in 0..<joyDocPageOrderId.count {
            cellLabelValue.append(i)
        }
        
        if pageIndex == indexPath.row {
            cell.cellCheckbox.isChecked = true
        } else {
            cell.cellCheckbox.isChecked = false
            cell.cellCheckbox.checkboxFillColor = .white
        }
        
        cell.cellLabel.text = "#\(cellLabelValue[indexPath.row] + 1) Page"
        cell.cellCheckbox.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pageIndex = indexPath.row
        fetchDataFromJoyDoc()
        DispatchQueue.main.async {
            componentTableView.reloadData()
        }
        pagesOptionTableView.reloadData()
    }
}
