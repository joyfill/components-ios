import Foundation
import UIKit

protocol MultipleImageViewDelegate: AnyObject {
    func imagesDeleted()
    func imagesUpdated()
}

public var imageTableView = UITableView()
public var interiorImageUploadButton = Button()

public class MultipleImageView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    public var mainView = UIView()
    public var interiorImageBar = UIView()
    public var interiorImageLabel = Label()
    public var closeButton = Button()
    public var deleteView = UIView()
    public var deleteLabel = Label()
    public var deleteUploadStack = UIStackView()
    public var deleteImage = ImageView()
    public var selectedIndexPath: Set<Int> = []
    weak var delegate: MultipleImageViewDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageTableView.register(MultipleImageTableCell.self, forCellReuseIdentifier: "MultipleImageTableCell")
        imageTableView.showsVerticalScrollIndicator = false
        imageTableView.showsHorizontalScrollIndicator = false
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.allowsMultipleSelection = true
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupUI()
        
        if imageDisplayMode == "readonly" {
            if pickedImg.count != 0 {
                deleteView.isHidden = true
                interiorImageUploadButton.isHidden = true
            } else {
                deleteView.isHidden = true
                interiorImageUploadButton.isHidden = true
                imageTableView.isHidden = true
            }
        } else {
            if pickedImg.count != 0 {
                deleteView.isHidden = true
                imageTableView.isHidden = false
            } else {
                deleteView.isHidden = true
                imageTableView.isHidden = false
            }
        }
    }
    
    func setupUI() {
        // SubViews
        view.addSubview(mainView)
        view.addSubview(deleteUploadStack)
        view.addSubview(imageTableView)
        mainView.addSubview(interiorImageBar)
        interiorImageBar.addSubview(interiorImageLabel)
        interiorImageBar.addSubview(closeButton)
        deleteView.addSubview(deleteLabel)
        deleteView.addSubview(deleteImage)
        deleteUploadStack.addArrangedSubview(interiorImageUploadButton)
        deleteUploadStack.addArrangedSubview(deleteView)
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        interiorImageUploadButton.translatesAutoresizingMaskIntoConstraints = false
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteImage.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        interiorImageBar.translatesAutoresizingMaskIntoConstraints = false
        interiorImageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        imageTableView.translatesAutoresizingMaskIntoConstraints = false
        deleteUploadStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to imageView
        NSLayoutConstraint.activate([
            // Top View
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            // PageView Constraint
            interiorImageBar.topAnchor.constraint(equalTo: mainView.topAnchor),
            interiorImageBar.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            interiorImageBar.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            interiorImageBar.heightAnchor.constraint(equalToConstant: 39),
            
            // PageLabel Constraint
            interiorImageLabel.topAnchor.constraint(equalTo: interiorImageBar.topAnchor, constant: 4),
            interiorImageLabel.leadingAnchor.constraint(equalTo: interiorImageBar.leadingAnchor, constant: 0),
            interiorImageLabel.widthAnchor.constraint(equalToConstant: 135),
            interiorImageLabel.heightAnchor.constraint(equalToConstant: 16),
            
            // PageButton Constraint
            closeButton.topAnchor.constraint(equalTo: interiorImageBar.topAnchor, constant: 2),
            closeButton.trailingAnchor.constraint(equalTo: interiorImageBar.trailingAnchor, constant: 0),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Stack
            deleteUploadStack.topAnchor.constraint(equalTo: interiorImageBar.bottomAnchor, constant: 0),
            deleteUploadStack.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            deleteUploadStack.heightAnchor.constraint(equalToConstant: 35),
            
            // UploadButton Constraint
            interiorImageUploadButton.widthAnchor.constraint(equalToConstant: 93),
            
            // DeleteButton Constraint
            deleteView.widthAnchor.constraint(equalToConstant: 93),
            
            // DeleteLabel Constraint
            deleteLabel.topAnchor.constraint(equalTo: deleteView.topAnchor, constant: 6),
            deleteLabel.leadingAnchor.constraint(equalTo: deleteView.leadingAnchor, constant: 6),
            deleteLabel.trailingAnchor.constraint(equalTo: deleteImage.leadingAnchor, constant: -2),
            deleteLabel.bottomAnchor.constraint(equalTo: deleteView.bottomAnchor, constant: -5),
            
            // DeleteImage Constraint
            deleteImage.topAnchor.constraint(equalTo: deleteView.topAnchor, constant: 11),
            deleteImage.widthAnchor.constraint(equalToConstant: 15),
            deleteImage.trailingAnchor.constraint(equalTo: deleteView.trailingAnchor, constant: -10),
            deleteImage.bottomAnchor.constraint(equalTo: deleteView.bottomAnchor, constant: -9),
            
            // ImageTableView Constraint
            imageTableView.topAnchor.constraint(equalTo: deleteUploadStack.bottomAnchor, constant: 18),
            imageTableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            imageTableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            imageTableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10)
        ])
        
        // DeleteUploadStack properties
        deleteUploadStack.axis = .horizontal
        deleteUploadStack.distribution = .fillEqually
        deleteUploadStack.spacing = 10
        
        // PageLabel properties
        interiorImageLabel.labelText = "Interior Images"
        interiorImageLabel.fontSize = 14
        interiorImageLabel.isTextBold = true
        
        // Sets image and action to pageButton
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            let boldSearch = UIImage(systemName: "xmark.circle", withConfiguration: boldConfig)
            closeButton.setImage(boldSearch, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(clossTapped), for: .touchUpInside)
        
        // Set DeleteView
        deleteView.layer.borderWidth = 1
        deleteView.layer.borderColor = UIColor(hexString: "#F55243")?.cgColor
        deleteView.layer.cornerRadius = 6
        deleteLabel.labelText = "Delete "
        deleteLabel.borderWidth = 0
        deleteLabel.fontSize = 17
        deleteLabel.textAlignment = .center
        deleteLabel.textColor = UIColor(hexString: "#F55243")
        if #available(iOS 13.0, *) {
            let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
            deleteImage.image = UIImage(systemName: "trash", withConfiguration: boldConfig)
        } else {
            // Fallback on earlier versions
        }
        deleteImage.tintColor = UIColor(hexString: "#F55243")
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        deleteView.addGestureRecognizer(tap)
        deleteView.isUserInteractionEnabled = true
        
        // Set UploadButton
        interiorImageUploadButton.image = UIImage(named: "interiorUploadButton")
    }
    
    // MARK: ImageTableView
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imageMultiValue {
            return pickedImg.count
        } else {
            return pickedSingleImg.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleImageTableCell", for: indexPath) as! MultipleImageTableCell
        cell.contentView.backgroundColor = .clear
        
        if imageMultiValue {
            cell.cellImageField.load(urlString: pickedImg[indexPath.row])
        } else {
            cell.cellImageField.load(urlString: pickedSingleImg[indexPath.row])
        }
        
        tableView.rowHeight = 280
        cell.isSelected = selectedIndexPath.contains(indexPath.row)
        
        if selectedIndexPath.contains(indexPath.row) {
            cell.checkboxButton.isChecked = true
            cell.checkboxButton.checkboxFillColor = UIColor(hexString: "#256FFF") ?? .lightGray
            cell.checkboxButton.backgroundColor = .clear
        } else {
            cell.checkboxButton.isChecked = false
            cell.checkboxButton.backgroundColor = .clear
            cell.checkboxButton.checkboxFillColor = .clear
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath.insert(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as? MultipleImageTableCell
        
        if selectedIndexPath.contains(indexPath.row) {
            cell?.checkboxButton.isChecked = true
            cell?.checkboxButton.checkboxFillColor = UIColor(hexString: "#256FFF") ?? .lightGray
            cell?.checkboxButton.backgroundColor = .clear
        } else {
            cell?.checkboxButton.isChecked = false
            cell?.checkboxButton.backgroundColor = .clear
            cell?.checkboxButton.checkboxFillColor = .clear
        }
        checkDisplayMode()
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexPath.remove(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as? MultipleImageTableCell
        
        if selectedIndexPath.contains(indexPath.row) {
            cell?.checkboxButton.isChecked = true
            cell?.checkboxButton.checkboxFillColor = UIColor(hexString: "#256FFF") ?? .lightGray
            cell?.checkboxButton.backgroundColor = UIColor(hexString: "E3E3E3")
        } else {
            cell?.checkboxButton.isChecked = false
            cell?.checkboxButton.backgroundColor = .clear
            cell?.checkboxButton.checkboxFillColor = .clear
        }
        checkDisplayMode()
    }
    
    // Function to check displayMode is readonly or fill
    func checkDisplayMode() {
        if imageDisplayMode != "readonly" {
            if selectedIndexPath.count == 0 {
                deleteView.isHidden = true
            } else {
                deleteView.isHidden = false
            }
        }
    }
    
    // Action for close button
    @objc func clossTapped() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        delegate?.imagesUpdated()
        componentTableView.reloadData()
    }
    
    // Action for delete button
    @objc func deleteTapped() {
        let sortedIndices = selectedIndexPath.sorted(by: >)
        
        // Delete the selected cells from the data array
        for index in sortedIndices {
            if imageMultiValue {
                pickedImg.remove(at: index)
            } else {
                pickedImg.removeAll()
                pickedSingleImg.removeAll()
            }
        }
        selectedIndexPath.removeAll()
        delegate?.imagesDeleted()
        
        // Update the table view
        imageTableView.beginUpdates()
        imageTableView.deleteRows(at: sortedIndices.map { IndexPath(row: $0, section: 0) }, with: .fade)
        imageTableView.endUpdates()
        
        if pickedImg.count == 0 {
            deleteView.isHidden = true
        } else {
            deleteView.isHidden = false
        }
    }
}
