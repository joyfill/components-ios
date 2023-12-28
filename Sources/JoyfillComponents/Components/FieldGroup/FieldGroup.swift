import Foundation
import UIKit

public class FieldGroup: UIView, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private let myArray: NSArray = ["First","Second","Third","First","Second","Third"]
    public var fieldGropTable : UITableView!
    public var titleText = UILabel()
    public var View_Table = UIView()
    fileprivate  var dataArray = [String]()
    var viewRef = UIViewController()
    public var pickedImg = UIImage()
    public var optionIds : [Int]?
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 20), height: 400))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Field Group View CornerRadius
    @IBInspectable
    open var FieldGroupCornerRadius: CGFloat = 5 {
        didSet {
            fieldGropTable.layer.cornerRadius = FieldGroupCornerRadius
        }
    }
    
    @IBInspectable
    open var FieldGroupBorderWidth: CGFloat = 1 {
        didSet {
            fieldGropTable.layer.borderWidth = FieldGroupBorderWidth
        }
    }
    
    @IBInspectable
    open var FieldGroupBorderColor: UIColor = UIColor.lightGray {
        didSet {
            fieldGropTable.layer.borderColor = FieldGroupBorderColor.cgColor
        }
    }
    
    //Field Group View backgroundColor
    @IBInspectable
    open var FieldGroupbackgroundColor: UIColor? {
        didSet {
            fieldGropTable.layer.backgroundColor = FieldGroupbackgroundColor?.cgColor
        }
    }
    
    //Title Text Set
    @IBInspectable
    public var titleTextLbl : String?{
        didSet {
            titleText.text = titleTextLbl
        }
    }
    
    @IBInspectable
    public var titleFontSize : CGFloat = 17 {
        didSet {
            titleText.font = UIFont.systemFont(ofSize: titleFontSize)
        }
    }
    
    @IBInspectable
    public var titleTextColor : UIColor? {
        didSet {
            titleText.textColor = titleTextColor
        }
    }
    
    @IBInspectable
    public var titleFontBold : CGFloat = 17 {
        didSet {
            titleText.font = UIFont.boldSystemFont(ofSize: titleFontBold)
        }
    }
    
    @IBInspectable
    public var titleFontItalic : CGFloat = 17 {
        didSet {
            titleText.font = UIFont.italicSystemFont(ofSize: titleFontItalic)
        }
    }
    
    @IBInspectable
    open var titlefontName: String = "Helvetica" {
        didSet {
            titleText.font = UIFont(name: titlefontName, size: titleFontBold)
            
        }
    }
    
    //TextField Column
    @IBInspectable
    open var textFieldColumnBold : CGFloat = 17 {
        didSet {
            UIFont.boldSystemFont(ofSize: textFieldColumnBold)
        }
    }
    
    @IBInspectable
    public var textFieldColumnFontItalic : CGFloat = 17 {
        didSet {
            UIFont.italicSystemFont(ofSize: textFieldColumnFontItalic)
        }
    }
    
    // Sets text bold and italic both of the label
    @IBInspectable
    open var isTextBold: Bool = false {
        didSet {
            textFieldColumnBold = 17
        }
    }
    
    @IBInspectable
    open var isTextItalic: Bool = false {
        didSet {
            textFieldColumnFontItalic = 17
        }
    }
    
    public var optionArray = [String]() {
        didSet{
            self.dataArray = self.optionArray
        }
    }
    
    func setupUI () {
        titleText.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: 20)
        self.titleTextLbl = "Field Group"
        self.titleTextColor = .black
        addSubview(titleText)
        
        fieldGropTable = UITableView(frame: CGRect(x: 0, y: titleText.frame.maxY + 5, width: bounds.size.width, height: 370))
        fieldGropTable.register(TextFieldGroupCell.self, forCellReuseIdentifier: "TextFieldGroupCell")
        fieldGropTable.register(DropDownGroupCell.self, forCellReuseIdentifier: "DropDownGroupCell")
        fieldGropTable.register(ImageGroupCell.self, forCellReuseIdentifier: "ImageGroupCell")
        fieldGropTable.delegate = self
        fieldGropTable.dataSource = self
        fieldGropTable.allowsSelection = false
        self.FieldGroupBorderColor = UIColor(hexString: "#C0C1C6") ?? .lightGray
        self.FieldGroupBorderWidth = 0.5
        self.FieldGroupCornerRadius = 10
        
        addSubview(fieldGropTable)
        
        self.fieldGropTable.layoutIfNeeded()
        self.fieldGropTable.frame.size.height = self.fieldGropTable.contentSize.height
        self.View_Table.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldGroupCell", for: indexPath) as! TextFieldGroupCell
            cell.title_Lbl.text = "Text Field Column"
            cell.textField_Column.boldText = textFieldColumnBold
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "DropDownGroupCell", for: indexPath) as! DropDownGroupCell
            cell1.selectionStyle = .none
            cell1.title_DropDown.text = "Drop Down Column"
            cell1.dropDown_Colum.optionArray = optionArray
            cell1.dropDown_Colum.optionIds = optionIds
            cell1.dropDown_Colum.checkMarkEnabled = false
            cell1.dropDown_Colum.cornerRadius(corner: 5)
            cell1.dropDown_Colum.borderWidth(border: 1)
            cell1.dropDown_Colum.layer.borderColor = UIColor.black.cgColor
            cell1.dropDown_Colum.semanticContentAttribute = .forceRightToLeft
            return cell1
            
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "ImageGroupCell", for: indexPath) as! ImageGroupCell
            cell2.image_Colum.layer.cornerRadius = 5
            cell2.image_Colum.layer.borderColor = UIColor.black.cgColor
            cell2.image_Colum.layer.borderWidth = 1
            cell2.title_image.text = "Image Column"
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadImage))
            cell2.ImageGroup.addGestureRecognizer(tap)
            cell2.ImageGroup.isUserInteractionEnabled = true
            cell2.ImageGroup.image = pickedImg
            return cell2
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else if indexPath.row == 1 {
            return 90
        } else {
            return 130
        }
    }
    
    //Open Gallery
    @objc func uploadImage() {
        guard let viewController = self.findViewController() else {
            return
        }
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        
        while let currentResponder = responder {
            if let viewController = currentResponder as? UIViewController {
                return viewController
            }
            responder = currentResponder.next
        }
        
        return nil
    }
    
    func openGallery() {
        guard let viewController = self.findViewController() else {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let viewController = self.findViewController() else {
            return
        }
        viewController.dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImg = pickedImage
            fieldGropTable.reloadData()
            //photoUploadBtn.setImage(pickedImage, for: .normal)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let viewController = self.findViewController() else {
            return
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}

// TextFieldGroupCell
public class TextFieldGroupCell : UITableViewCell {
    var textFieldcolumn_View = UIView()
    var title_Lbl = UILabel()
    var textField_Column = TextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //TextField
        textFieldcolumn_View.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        title_Lbl.frame = CGRect(x: 15, y: 5, width: UIScreen.main.bounds.width - 20, height: 20)
        textFieldcolumn_View.addSubview(title_Lbl)
        textField_Column.frame = CGRect(x: 15, y: title_Lbl.frame.maxY + 5, width: textFieldcolumn_View.bounds.width - 50, height: 50)
        textFieldcolumn_View.addSubview(textField_Column)
        contentView.addSubview(textFieldcolumn_View)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// DropdownGroupCell
public class DropDownGroupCell : UITableViewCell {
    var title_DropDown = UILabel()
    var dropDownColumn_View = UIView()
    var dropDown_Colum = DropDownTestField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Drop Down Group
        dropDownColumn_View.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        title_DropDown.frame = CGRect(x: 15, y: 5, width: UIScreen.main.bounds.width - 20, height: 20)
        dropDownColumn_View.addSubview(title_DropDown)
        dropDown_Colum.frame = CGRect(x: 15, y: title_DropDown.frame.maxY + 5, width: dropDownColumn_View.bounds.width - 50, height: 50)
        dropDownColumn_View.addSubview(dropDown_Colum)
        contentView.addSubview(dropDownColumn_View)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// ImageGroupCell
public class ImageGroupCell : UITableViewCell {
    var title_image = UILabel()
    var imageColumn_View = UIView()
    var image_Colum = UIView()
    public var ImageGroup = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Image Group
        imageColumn_View.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        title_image.frame = CGRect(x: 15, y: 5, width: UIScreen.main.bounds.width - 20, height: 20)
        imageColumn_View.addSubview(title_image)
        image_Colum.frame = CGRect(x: 15, y: title_image.frame.maxY + 5, width: imageColumn_View.bounds.width - 50, height: 100)
        ImageGroup.frame = CGRect(x: 15, y: 0, width: 100, height: 100)
        imageColumn_View.addSubview(image_Colum)
        contentView.addSubview(imageColumn_View)
        image_Colum.addSubview(ImageGroup)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
