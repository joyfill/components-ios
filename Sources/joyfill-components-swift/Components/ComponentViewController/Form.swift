import Foundation
import UIKit

var cellHeight = [CGFloat]()
public var imageIndexNo = Int()
public var cellView = [UIView]()
public var chartIndexPath = Int()
public var tableIndexPath = Int()
public var doc: [String: Any] = [:]
public var viewForDataSource = UIView()
public var docChangeLogs: [String: Any] = [:]
public var componentTableView = UITableView()
public var blurAndFocusParams: [String: Any] = [:]
public var componentTableViewCellHeight = [CGFloat]()

public var selectedPicture = [[String]]()
public var pickedSinglePicture = [[String]]()
public var imageSelectionCount = [[String]]()
public var saveButtonTapAction: (() -> Void)?
public var uploadImageTapAction: (() -> Void)?

public protocol onChange {
    func handleOnChange(docChangelog: [String: Any], doc: [String: Any])
    func handleOnFocus(blurAndFocusParams: [String: Any])
    func handleOnBlur(blurAndFocusParams: [String: Any])
}

public class Form: UIView, SaveTableFieldValue, saveImageFieldValue, saveSignatureFieldValue, SavePageNavigationChange {
    
    public var saveButton = Button()
    public var pageNavigationView = UIView()
    public var pageNavigationLabel = Label()
    public var pageNavigationArrow = ImageView()
    
    var joyFillStruct: JoyDoc?
    var imageIndexPath = Int()
    var tableHeight = CGFloat()
    var shortTextHeight = CGFloat()
    var changelogs = [[String: Any]]()
    public var saveDelegate: onChange? = nil
    var dropdownOptionSubArray: [String] = []
    var fieldDelegate: SaveTextFieldValue? = nil
    var multiselectOptionSubArray: [String] = []
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        hideKeyboardOnTapAnyView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        hideKeyboardOnTapAnyView()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        hideKeyboardOnTapAnyView()
    }
    
    public func setupUI() {
        _ = JoyDoc.loadFromJSON()
        self.fieldDelegate = self
        setGlobalUserInterfaceStyle()
        
        // SubViews
        addSubview(pageNavigationView)
        addSubview(componentTableView)
        addSubview(saveButton)
        pageNavigationView.addSubview(pageNavigationArrow)
        pageNavigationView.addSubview(pageNavigationLabel)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        componentTableView.translatesAutoresizingMaskIntoConstraints = false
        pageNavigationView.translatesAutoresizingMaskIntoConstraints = false
        pageNavigationArrow.translatesAutoresizingMaskIntoConstraints = false
        pageNavigationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint to arrange subviews acc. to components
        NSLayoutConstraint.activate([
            // PageNavigationView Constraint
            pageNavigationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            pageNavigationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pageNavigationView.heightAnchor.constraint(equalToConstant: 40),
            pageNavigationView.widthAnchor.constraint(equalToConstant: 150),
            
            // PageNavigationArrow Constraint
            pageNavigationArrow.centerYAnchor.constraint(equalTo: pageNavigationView.centerYAnchor),
            pageNavigationArrow.leadingAnchor.constraint(equalTo: pageNavigationView.leadingAnchor, constant: 30),
            pageNavigationArrow.widthAnchor.constraint(equalToConstant: 14),
            pageNavigationArrow.heightAnchor.constraint(equalToConstant: 18),
            
            // PageNavigationLabel Constraint
            pageNavigationLabel.centerYAnchor.constraint(equalTo: pageNavigationView.centerYAnchor),
            pageNavigationLabel.leadingAnchor.constraint(equalTo: pageNavigationArrow.trailingAnchor, constant: 5),
            pageNavigationLabel.trailingAnchor.constraint(equalTo: pageNavigationView.trailingAnchor, constant: -5),
            
            // TableView Constraint
            componentTableView.topAnchor.constraint(equalTo: pageNavigationView.bottomAnchor, constant: 10),
            componentTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            componentTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            componentTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -5),
            
            // SaveButton Constraint
            saveButton.topAnchor.constraint(equalTo: componentTableView.bottomAnchor, constant: 5),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        // Set cornerRadius and shadow to view.
        backgroundColor = .white
        
        saveButton.title = "Save"
        saveButton.cornerRadius = 20
        saveButton.titleColor = UIColor.blue
        saveButton.backgroundColor = UIColor(hexString: "#F5F5F5")
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        pageNavigationLabel.fontSize = 14
        pageNavigationView.layer.cornerRadius = 20
        if #available(iOS 13.0, *) {
            pageNavigationArrow.image = UIImage(systemName: "chevron.down")
        } else {
            // Fallback on earlier versions
        }
        pageNavigationArrow.tintColor = .black
        pageNavigationLabel.labelText = "Page #\(pageIndex + 1)"
        pageNavigationView.backgroundColor = UIColor(hexString: "#F5F5F5")
        
        // Set tableView Properties
        componentTableView.bounces = false
        componentTableView.separatorStyle = .none
        componentTableView.allowsSelection = false
        componentTableView.tintColor = .white
        componentTableView.showsVerticalScrollIndicator = false
        componentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewForDataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openPageNavigationModal))
        pageNavigationView.addGestureRecognizer(tapGesture)
    }
    
    @objc public func saveButtonTapped(sender: UIButton) {
        saveButtonTapAction?()
        docChangeLogs.removeAll()
        changelogs.removeAll()
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
    
    @objc func openPageNavigationModal() {
        guard let viewController = findViewController() else {
            return
        }
        let vc = PageNavigationViewController()
        vc.saveDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        viewController.present(vc, animated: false)
    }
}

// MARK: Setup tableView
extension Form: UITableViewDelegate, UITableViewDataSource, SaveTextFieldValue, saveChartFieldValue {
    // MARK: TableView delegate method for number of rows in section
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentType.count
    }
    
    // MARK: TableView delegate method for cell for row at
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        componentTableView.separatorStyle = .none
        pageNavigationLabel.labelText = "Page #\(pageIndex + 1)"
        
        // Configure the cell
        let value = joyDocFieldData[indexPath.row].value
        let fieldType = joyDocFieldData[indexPath.row].type
        
        switch fieldType {
        case FieldTypes.text:
            configureTextFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.multiSelect:
            configureMultiSelectFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.dropdown:
            configureDropdownFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.textarea:
            configureTextAreaFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.date:
            configureDateTimeFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.signature:
            configureSignatureFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.block:
            configureBlockFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.number:
            configureNumberFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.chart:
            configureChartFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.richText:
            configureRichTextFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.table:
            configureTableFieldCell(tableView: tableView, i: indexPath.row, value: value)
        case FieldTypes.image:
            configureImageFieldCell(tableView: tableView, i: indexPath.row, value: value)
        default:
            break
        }
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.addSubview(cellView[indexPath.row])
        return cell
    }
    
    // MARK: TableView delegate method to adjust cell height
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fieldType = joyDocFieldData[indexPath.row].type
        switch fieldType {
        case FieldTypes.image:
            if imageSelectionCount[indexPath.row].count == 0 {
                if selectedPicture[indexPath.row].count == 0 {
                    cellHeight.insert(150, at: indexPath.row)
                } else {
                    cellHeight.insert(270, at: indexPath.row)
                }
            } else {
                cellHeight.insert(270, at: indexPath.row)
            }
        case FieldTypes.text, FieldTypes.multiSelect, FieldTypes.dropdown, FieldTypes.textarea, FieldTypes.date, FieldTypes.signature, FieldTypes.number, FieldTypes.chart, FieldTypes.table, FieldTypes.block:
            cellHeight.insert(componentTableViewCellHeight[indexPath.row] + 10, at: indexPath.row)
        case FieldTypes.richText:
            cellHeight.insert(componentTableViewCellHeight[indexPath.row], at: indexPath.row)
        default:
            break
        }
        return cellHeight[indexPath.row]
    }
    
    //MARK: - Image Field
    func configureImageFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let image = Image()
        image.index = i
        image.saveDelegate = self
        image.fieldDelegate = self
        image.uploadButton.tag = i
        image.selectedImage = selectedPicture
        image.pickedSingleImg = pickedSinglePicture
        
        imageSelectionCount[i].removeAll()
        image.selectedImage[i].removeAll()
        image.pickedSingleImg[i].removeAll()
        
        // Image value based on indexPath from JoyDoc
        switch value {
        case .string(_): break
        case .integer(_): break
        case .valueElementArray(let valueElements):
            for k in 0..<valueElements.count {
                imageSelectionCount[i] = [valueElements[k].url ?? ""]
                image.pickedSingleImg[i] = [valueElements[k].url ?? ""]
                image.selectedImage[i].append(valueElements[k].url ?? "")
            }
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        if image.selectedImage[i].count == 0 {
            if selectedPicture[i].count != 0 {
                image.selectedImage[i] = selectedPicture[i]
                image.pickedSingleImg[i] = pickedSinglePicture[i]
                tableView.rowHeight = 260
                image.saveDelegate?.handleUpload(indexPath: i)
            } else {
                tableView.rowHeight = 150
            }
        } else {
            tableView.rowHeight = 260
            if selectedPicture[i].count != 0 {
                image.selectedImage[i].append(selectedPicture[i].last ?? "")
                image.pickedSingleImg[i].append(pickedSinglePicture[i].last ?? "")
                tableView.rowHeight = 260
                image.saveDelegate?.handleUpload(indexPath: i)
            }
        }
        
        image.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        image.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        image.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        image.titleButton.text = joyDocFieldData[i].title
        image.allowMultipleImages(value: joyDocFieldData[i].multi ?? false)
        image.uploadButton.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        image.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(image, at: i)
    }
    @objc public func uploadButtonTapped(sender: UIButton) {
        uploadImageTapAction?()
        imageIndexNo = sender.tag
        fieldDelegate?.handleFocus(index: sender.tag)
    }
    
    //MARK: - Block Field
    func configureBlockFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let displayText = Label()
        displayText.numberOfLines = 0
        displayText.fontSize = CGFloat(blockTextSize[i])
        displayText.textColor = UIColor(hexString: blockTextColor[i])
        displayText.isTextBold = blockTextWeight[i] == "bold" ? true : false
        displayText.isTextItalic = blockTextStyle[i] == "italic" ? true : false
        displayText.textAlignment = blockTextAlignment[i].textAlignmentFromStringValue()
        
        // Block value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            displayText.labelText = string
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        let height = (displayText.labelText?.height(withConstrainedWidth: tableView.bounds.width - 40, font: displayText.font))
        tableView.rowHeight = height ?? 0 + 10
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        displayText.frame = CGRect(x: 20, y: 5, width: tableView.bounds.width - 40, height: tableView.rowHeight)
        cellView.insert(displayText, at: i)
    }
    
    //MARK: - Text Field
    func configureTextFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let shortText = ShortText()
        shortText.index = i
        shortText.textField.index = i
        shortText.saveDelegate = self
        shortText.textField.saveDelegate = self
        
        shortText.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        shortText.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        shortText.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        // TextField value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            shortText.textField.fieldText = string
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        shortText.topLabel.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: shortText.topLabel.font))
        tableView.rowHeight = 80 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        shortText.frame = CGRect(x: 20, y: 5, width: tableView.bounds.width - 40, height: tableView.rowHeight)
        cellView.insert(shortText, at: i)
    }
    //MARK: - TextArea Field
    func configureTextAreaFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let longText = LongText()
        longText.index = i
        longText.textField.index = i
        longText.textField.saveDelegate = self
        longText.textField.saveDelegate = self
        longText.textField.resignFirstResponder()
        longText.topLabel.labelText = joyDocFieldData[i].title
        
        longText.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        longText.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        longText.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        // TextArea value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            longText.textField.text = string
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: longText.topLabel.font))
        tableView.rowHeight = 210 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        longText.frame = CGRect(x: 20, y: 5, width: tableView.bounds.width - 40, height: tableView.rowHeight)
        cellView.insert(longText, at: i)
    }
    
    //MARK: - Number Field
    func configureNumberFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let number = NumberField()
        number.index = i
        number.saveDelegate = self
        
        // Number value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            number.numberField.text = string
        case .integer(let integer):
            number.numberField.text = "\(integer)"
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        number.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        number.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        number.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        number.titleText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: number.titleLbl.font))
        tableView.rowHeight = 80 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        number.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(number, at: i)
    }
    
    //MARK: - DateTime Field
    func configureDateTimeFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let datetime = DateTime()
        datetime.index = i
        datetime.saveDelegate = self
        datetime.dateTimeDisplayModes(mode: "")
        datetime.format = joyDocFieldPositionData?[i].format ?? ""
        
        // DateTime value based on indexPath from JoyDoc
        switch value {
        case .string(_): break
        case .integer(let integer):
            let date = timestampMillisecondsToDate(value: integer)
            datetime.dateTimeField.text = date
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        datetime.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        datetime.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        datetime.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        datetime.titleText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: datetime.titleLabel.font))
        tableView.rowHeight = 80 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        datetime.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(datetime, at: i)
    }
    
    //MARK: - Dropdown Field
    func configureDropdownFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let dropDownText = Dropdown()
        dropDownText.index = i
        dropDownText.saveDelegate = self
        dropDownText.doneHide = "singleSelect"
        dropdownOptionSubArray.removeAll()
        
        dropDownText.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        dropDownText.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        dropDownText.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        // Dropdown options and selectedOption value based on indexPath from JoyDoc
        for option in 0..<(joyDocFieldData[i].options?.count ?? 0) {
            if joyDocFieldData[i].options?[option].deleted == false {
                dropdownOptionSubArray.append(joyDocFieldData[i].options?[option].value ?? "")
            }
            switch value {
            case .string(let string):
                if let _ = string.first(where: { _ in string == joyDocFieldData[i].options?[option].id }) {
                    selectedDropdownOptionIndexPath[i] = option
                    dropDownText.textField.text = joyDocFieldData[i].options?[option].value
                }
            case .integer(_): break
            case .valueElementArray(_): break
            case .array(_): break
            case .none: break
            case .some(.null): break
            }
        }
        
        dropDownText.titleLbl.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: dropDownText.titleLbl.font))
        tableView.rowHeight = 80 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        dropDownText.buttonTag = i
        dropdownOptions.insert(dropdownOptionSubArray, at: i)
        dropDownText.dropdownPlaceholder = dropdownOptions[i].first ?? ""
        dropDownText.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(dropDownText, at: i)
    }
    
    //MARK: - MultiSelect Field
    func configureMultiSelectFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        let multipleChoice = MultipleChoice()
        multipleChoice.index = i
        multipleChoice.saveDelegate = self
        multiSelectOptionId[i].removeAll()
        multiselectOptionSubArray.removeAll()
        
        multipleChoice.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        multipleChoice.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        multipleChoice.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        // Multiselect options based on indexPath from JoyDoc
        for option in 0..<(joyDocFieldData[i].options?.count ?? 0) {
            multiSelect.insert(joyDocFieldData[i].multi ?? true, at: i)
            if joyDocFieldData[i].options?[option].deleted == false {
                multiSelectOptionId[i].append(joyDocFieldData[i].options?[option].id ?? "")
                multiselectOptionSubArray.append(joyDocFieldData[i].options?[option].value ?? "")
            }
        }
        multiSelectOptions.insert(multiselectOptionSubArray, at: i)
        // Fetch selectedOption value of multiSelect
        for optionValue in 0..<multiselectOptionSubArray.count {
            switch value {
            case .string(let string):
                if joyDocFieldData[i].multi == false {
                    if string == multiSelectOptionId[i][optionValue] {
                        multiChoiseSelectedOptionIndexPath[i].add(optionValue)
                    }
                }
            case .integer(_): break
            case .valueElementArray(_): break
            case .array(let array):
                if joyDocFieldData[i].multi == true {
                    if array.first(where: { $0 == multiSelectOptionId[i][optionValue] }) != nil {
                        multiChoiseSelectedOptionIndexPath[i].add(optionValue)
                    }
                } else {
                    if array.first(where: { $0 == multiSelectOptionId[i][optionValue] }) != nil {
                        multiChoiseSelectedOptionIndexPath[i].add(optionValue)
                    }
                }
            case .none: break
            case .some(.null): break
            }
        }
        
        var totalHeight: CGFloat = 0.0
        for count in 0..<multiselectOptionSubArray.count {
            let text = multiSelectOptions[i][count]
            let font = UIFont.systemFont(ofSize: 16)
            let width = tableView.frame.width - 50
            let height = heightForText(text , font: font, width: width) + 32
            
            totalHeight += height
        }
        
        multipleChoice.titleLabel.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: multipleChoice.titleLabel.font))
        tableView.rowHeight = totalHeight + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        multipleChoice.frame = CGRect(x: 20, y: 5, width: tableView.bounds.width - 40, height: tableView.rowHeight)
        cellView.insert(multipleChoice, at: i)
    }
    
    //MARK: - Signature Field
    func configureSignatureFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        // Signature value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            signedImage.insert(string, at: i)
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        let sign = SignatureView()
        sign.index = i
        sign.saveDelegate = self
        sign.fieldDelegate = self
        
        sign.titleLabel.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: sign.titleLabel.font))
        tableView.rowHeight = 220 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        sign.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        sign.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        sign.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        sign.frame = CGRect(x: 20, y: 5, width: tableView.bounds.width - 40, height: tableView.rowHeight)
        cellView.insert(sign, at: i)
    }
    
    //MARK: - Table Field
    func configureTableFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        optionsData[i].removeAll()
        tableRowOrder[i].removeAll()
        tableCellsData[i].removeAll()
        tableFieldValue[i].removeAll()
        tableColumnType[i].removeAll()
        tableColumnTitle[i].removeAll()
        tableColumnOrderId[i].removeAll()
        
        // Table value based on indexPath from JoyDoc
        switch value {
        case .string(_): break
        case .integer(_): break
        case .valueElementArray(let valueElements):
            optionsData[i] = joyDocFieldData[i].tableColumns ?? []
            // Fetch table row order from joyDoc
            for rows in 0..<(joyDocFieldData[i].rowOrder?.count ?? 0) {
                tableRowOrder[i].append(joyDocFieldData[i].rowOrder?[rows] ?? "")
                if let valueElem = valueElements.first(where: {$0.id == joyDocFieldData[i].rowOrder?[rows]}) {
                    if (valueElem.deleted ?? false) == false {
                        tableFieldValue[i].append(valueElem)
                    }
                }
            }
            // Fetch table column type and title after sorting column based on their columnID
            for columns in 0..<(joyDocFieldData[i].tableColumnOrder?.count ?? 0) {
                tableColumnOrderId[i].append(joyDocFieldData[i].tableColumnOrder?[columns] ?? "")
                if let fieldTableColumn = joyDocFieldData[i].tableColumns?.first(where: { $0.id == joyDocFieldData[i].tableColumnOrder?[columns]}) {
                    tableColumnType[i].append(fieldTableColumn.type ?? "")
                    tableColumnTitle[i].append(fieldTableColumn.title ?? "")
                }
            }
            for k in 0..<tableFieldValue[i].count {
                if let cells = tableFieldValue[i][k].cells {
                    let valuesArray = Array(cells.values)
                    tableCellsData[i].append(valuesArray)
                }
            }
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        tableIndexPath = i
        let table = Table()
        table.tableIndexNo(indexPath: i)
        table.saveDelegate = self
        table.fieldDelegate = self
        table.index = i
        table.numberRows(number: tableRowOrder[i].count)
        table.numberColumns(number: tableColumnType[i].count)
        
        table.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        table.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        table.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        table.titleLabel.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 140, font: table.titleLabel.font))
        tableView.rowHeight = 210 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        table.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(table, at: i)
    }
    
    //MARK: - Chart Field
    func configureChartFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        xCoordinates[i].removeAll()
        yCoordinates[i].removeAll()
        chartPointsId[i].removeAll()
        graphLabelData[i].removeAll()
        chartValueElement[i].removeAll()
        
        // Chart value based on indexPath from JoyDoc
        switch value {
        case .string(_): break
        case .integer(_): break
        case .valueElementArray(let valueElements):
            for item in valueElements {
                chartValueElement[i].append(item)
            }
            
            for k in 0..<valueElements.count {
                var graphLabelSubArray: [String] = []
                var graphXCoordinateSubArray: [CGFloat] = []
                var graphYCoordianteSubArray: [CGFloat] = []
                var pointsIdSubArray: [String] = []
                if let points = valueElements[k].points {
                    for l in 0..<points.count {
                        let label = points[l].label ?? ""
                        graphLabelSubArray.append(label)
                        
                        let xCoordinate = points[l].x ?? 0
                        graphXCoordinateSubArray.append(xCoordinate)
                        
                        let yCoordinate = points[l].y ?? 0
                        graphYCoordianteSubArray.append(yCoordinate)
                        
                        let id = points[l].id ?? ""
                        pointsIdSubArray.append(id)
                    }
                }
                chartPointsId[i].append(pointsIdSubArray)
                graphLabelData[i].append(graphLabelSubArray)
                xCoordinates[i].append(graphXCoordinateSubArray)
                yCoordinates[i].append(graphYCoordianteSubArray)
            }
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        chartIndexPath = i
        let chart = Chart()
        chart.index = i
        chart.lineGraph.index = i
        chart.saveDelegate = self
        chart.fieldDelegate = self
        
        chart.titleLabel.labelText = joyDocFieldData[i].title
        let height = (joyDocFieldData[i].title?.height(withConstrainedWidth: tableView.bounds.width - 40, font: chart.titleLabel.font))
        tableView.rowHeight = 340 + (height ?? 0)
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        chart.toolTipTitle = joyDocFieldData[i].tipTitle ?? ""
        chart.toolTipDescription = joyDocFieldData[i].tipDescription ?? ""
        chart.tooltipVisible(bool: joyDocFieldData[i].tipVisible ?? false)
        
        chart.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(chart, at: i)
    }
    
    //MARK: - RichText Field
    func configureRichTextFieldCell(tableView: UITableView, i: Int, value: ValueUnion?) {
        richTextIndexPath = i
        
        // RichText value based on indexPath from JoyDoc
        switch value {
        case .string(let string):
            richTextValue.insert(string, at: richTextIndexPath)
        case .integer(_): break
        case .valueElementArray(_): break
        case .array(_): break
        case .none: break
        case .some(.null): break
        }
        
        let richText = RichText()
        let height = (richText.labelTextData.height(withConstrainedWidth: tableView.bounds.width - 40, font: richText.textLabel.font))
        tableView.rowHeight = height
        componentTableViewCellHeight[i] = tableView.rowHeight
        
        richText.frame = CGRect(x: 10, y: 5, width: tableView.bounds.width - 20, height: tableView.rowHeight)
        cellView.insert(richText, at: i)
    }
    
    // MARK: - Field onChange methods
    func handleFieldChange(text: Any, isEditingEnd: Bool, index: Int) {
        let change = ["value": text]
        _ = fieldOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970))
    }
    
    // MARK: - Signature onChange methods
    func handleSignatureUpload(sign: Any, signer: String, index: Int) {
        let change = ["value": sign,
                      "signer": signer]
        _ = fieldOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970))
    }
    
    // MARK: - Table onChange methods
    func handleDeleteRow(rowId: String, rowIndex: Int, isEditingEnd: Bool, index: Int) {
        let change = ["rowId": rowId, "targetRowIndex": rowIndex] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowDelete")
    }
    
    func handleMoveRowUp(rowId: String, rowIndex: Int, isEditingEnd: Bool, index: Int) {
        let change = ["rowId": rowId, "targetRowIndex": rowIndex] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowMove")
    }
    
    func handleMoveRowDown(rowId: String, rowIndex: Int, isEditigEnd: Bool, index: Int) {
        let change = ["rowId": rowId, "targetRowIndex": rowIndex] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowMove")
    }
    
    func handleDuplicateRow(row: [String : Any], rowIndex: Int, isEditingEnd: Bool, index: Int) {
        let change = row
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowCreate")
    }
    
    func handleAddBelowRow(row: [String : Any], rowIndex: Int, isEditingEnd: Bool, index: Int) {
        let change = ["row": row, "targetRowIndex": rowIndex] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowCreate")
    }
    
    func handleCreateRow(row: [String : Any], rowIndex: Int, isEditingEnd: Bool, index: Int) {
        let change = ["row": row, "targetRowIndex": rowIndex] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowCreate")
    }
    
    func handleTextCellChangeValue(row: [String : Any], rowId: String, isEditingEnd: Bool, index: Int) {
        let change = ["row": row, "rowId": rowId] as [String : Any]
        _ = tableOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[index].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[index].id ?? "",
                          fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                          change: change,
                          createdOn: Int(Date().timeIntervalSince1970),
                          target: "field.value.rowUpdate")
    }
    
    // MARK: - Chart onChange methods
    func handleLineChange(line: Int, indexPath: Int) {
        chartValueElement[chartIndexPath][addPointButtonIndexPath].points?.removeAll(where: { $0.id == chartPointsId[line][addPointButtonIndexPath][indexPath] })
        chartPointsId[line][addPointButtonIndexPath].remove(at: indexPath)
        
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        
        for i in 0..<chartValueElement[line].count {
            let element = chartValueElement[line]
            var singleElementData: [String: Any] = [
                "_id": element[i].id ?? "",
                "deleted": element[i].deleted ?? false,
                "title": element[i].title ?? "",
                "description": element[i].description ?? "",
                "points": [[String: Any]]()
            ]
            
            if let points = element[i].points {
                var pointsData: [[String: Any]] = []
                for point in points {
                    let pointData: [String: Any] = [
                        "_id": point.id ?? "",
                        "label": point.label ?? "",
                        "y": point.y ?? 0,
                        "x": point.x ?? 0
                    ]
                    pointsData.append(pointData)
                }
                singleElementData["points"] = pointsData
            }
            transformedDataArray.append(singleElementData)
            elementData = ["value": transformedDataArray]
        }
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleLineDelete(line: Int, indexPath: Int) {
        chartValueElement[line].remove(at: indexPath)
        
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        
        for i in 0..<chartValueElement[line].count {
            let element = chartValueElement[line]
            var singleElementData: [String: Any] = [
                "_id": element[i].id ?? "",
                "deleted": element[i].deleted ?? false,
                "title": element[i].title ?? "",
                "description": element[i].description ?? "",
                "points": [[String: Any]]()
            ]
            
            if let points = element[i].points {
                var pointsData: [[String: Any]] = []
                for point in points {
                    let pointData: [String: Any] = [
                        "_id": point.id ?? "",
                        "label": point.label ?? "",
                        "y": point.y ?? 0,
                        "x": point.x ?? 0
                    ]
                    pointsData.append(pointData)
                }
                singleElementData["points"] = pointsData
            }
            transformedDataArray.append(singleElementData)
            elementData = ["value": transformedDataArray]
        }
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleLineData(rowId: String, line: Int, indexPath: Int, newYValue: Int, newXValue: Int, newLabelValue: String) {
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        
        for i in 0..<chartValueElement[line].count {
            var singleElementData = [
                "_id": chartValueElement[line][i].id ?? "",
                "deleted": chartValueElement[line][i].deleted ?? false,
                "title": chartValueElement[line][i].title ?? "",
                "description": chartValueElement[line][i].description ?? "",
                "points": [[String: Any]]()
            ] as [String : Any]
            
            if let points = chartValueElement[line][i].points {
                var pointsData: [[String: Any]] = []
                for point in points {
                    var pointData: [String: Any] = [
                        "_id": point.id ?? ""
                    ]
                    
                    // Check if the current point matches the rowId
                    if point.id == rowId {
                        pointData["y"] = newYValue
                        pointData["x"] = newXValue
                        pointData["label"] = newLabelValue
                    } else {
                        pointData["y"] = point.y ?? 0
                        pointData["x"] = point.x ?? 0
                        pointData["label"] = point.label ?? ""
                    }
                    
                    pointsData.append(pointData)
                }
                singleElementData["points"] = pointsData
            }
            transformedDataArray.append(singleElementData)
        }
        elementData = ["value": transformedDataArray]
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleLineCreate(line: Int) {
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        
        for i in 0..<chartValueElement[line].count {
            let element = chartValueElement[line]
            var singleElementData: [String: Any] = [
                "_id": element[i].id ?? "",
                "deleted": element[i].deleted ?? false,
                "title": element[i].title ?? "",
                "description": element[i].description ?? "",
                "points": [[String: Any]]()
            ]
            
            if let points = element[i].points {
                var pointsData: [[String: Any]] = []
                for point in points {
                    let pointData: [String: Any] = [
                        "_id": point.id ?? "",
                        "label": point.label ?? "",
                        "y": point.y ?? 0,
                        "x": point.x ?? 0
                    ]
                    pointsData.append(pointData)
                }
                singleElementData["points"] = pointsData
            }
            transformedDataArray.append(singleElementData)
            elementData = ["value": transformedDataArray]
        }
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handlePointCreate(rowId: String, line: Int, indexPath: Int) {
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        
        let pointId = generateObjectId()
        let newPointElement: [String: Any] = [
            "_id": pointId,
            "label": "",
            "y": 0,
            "x": 0
        ]
        let newPoint = Point(id: pointId,
                             label: "",
                             y: 0,
                             x: 0)
        chartPointsId[line][indexPath].append(pointId)
        chartValueElement[line][indexPath].points?.append(newPoint)
        
        for i in 0..<chartValueElement[line].count {
            let element = chartValueElement[line]
            var singleElementData: [String: Any] = [
                "_id": element[i].id ?? "",
                "deleted": element[i].deleted ?? false,
                "title": element[i].title ?? "",
                "description": element[i].description ?? "",
                "points": [[String: Any]]()
            ]
            
            if let points = element[i].points {
                var pointsData: [[String: Any]] = []
                for point in points {
                    let pointData: [String : Any] = [
                        "_id": point.id ?? "",
                        "label": point.label ?? "",
                        "y": point.y ?? 0,
                        "x": point.x ?? 0
                    ]
                    pointsData.append(pointData)
                }
                
                if element[i].id == rowId {
                    pointsData.append(newPointElement)
                }
                
                singleElementData["points"] = pointsData
            }
            transformedDataArray.append(singleElementData)
            elementData = ["value": transformedDataArray]
        }
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleYMinCoordinates(line: Int, newValue: Int) {
        let elementData: [String: Any] = [
            "yMin": newValue
        ]
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleYMaxCoordinates(line: Int, newValue: Int) {
        let elementData: [String: Any] = [
            "yMax": newValue
        ]
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleXMinCoordinates(line: Int, newValue: Int) {
        let elementData: [String: Any] = [
            "xMin": newValue
        ]
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    func handleXMaxCoordinates(line: Int, newValue: Int) {
        let elementData: [String: Any] = [
            "xMax": newValue
        ]
        onChangeFunctionCall(line: line, elementData: elementData)
    }
    
    // MARK: - Image onChange methods
    func handleUpload(indexPath: Int) {
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        for picture in 0..<selectedPicture[indexPath].count {
            let data: [String: Any] = [
                "id": generateObjectId(),
                "url": selectedPicture[indexPath][picture]
            ]
            transformedDataArray.append(data)
        }
        elementData = ["value": transformedDataArray]
        onChangeFunctionCall(line: indexPath, elementData: elementData)
    }
    
    func handleDelete(indexPath: Int) {
        var elementData = [String: Any]()
        var transformedDataArray = [[String: Any]]()
        for picture in 0..<selectedPicture[indexPath].count {
            let data: [String: Any] = [
                "id": generateObjectId(),
                "url": selectedPicture[indexPath][picture]
            ]
            transformedDataArray.append(data)
        }
        elementData = ["value": transformedDataArray]
        onChangeFunctionCall(line: indexPath, elementData: elementData)
    }
    
    func onChangeFunctionCall(line: Int, elementData: [String: Any]) {
        _ = chartOnChange(id: joyDocId,
                          identifier: joyDocIdentifier,
                          fileId: joyDocFieldData[line].file ?? "",
                          pageId: joyDocPageId[pageIndex],
                          fieldId: joyDocFieldData[line].id ?? "",
                          fieldIdentifier: joyDocFieldData[line].identifier ?? "",
                          fieldPositionId: joyDocFieldPositionData?[line].id ?? "",
                          change: elementData,
                          createdOn: Int(Date().timeIntervalSince1970))
    }
    
    // MARK: - Page onChange methods
    func handlePageDuplicate(change: [String: Any], fieldChange: [[String: Any]]) {
        _ = pageDuplicateOnChange(id: joyDocId,
                                  identifier: joyDocIdentifier,
                                  fileId: joyDocFileId,
                                  createdOn: Int(Date().timeIntervalSince1970),
                                  target: "page.create",
                                  change: change,
                                  fieldChange: fieldChange)
    }
    
    func handlePageDelete(pageId: String) {
        _ = pageDeleteOnChange(id: joyDocId,
                               identifier: joyDocIdentifier,
                               fileId: joyDocFileId,
                               pageId: pageId,
                               createdOn: Int(Date().timeIntervalSince1970),
                               target: "page.delete")
    }
    
    // MARK: - onChange function
    // MARK: - Fields onChange Method
    func fieldOnChange(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, change: [String: Any], createdOn: Int) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": "field.update",
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId,
            "change": change,
            "createdOn": createdOn
        ] as [String : Any]
        
        convertDocToJson()
        changelogs.append(dict)
        docChangeLogs = ["changelogs": changelogs]
        saveDelegate?.handleOnChange(docChangelog: dict, doc: doc)
        return dict
    }
    
    // MARK: - Table onChange Method
    func tableOnChange(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, change: [String: Any], createdOn: Int, target: String) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": target,
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId,
            "change": change,
            "createdOn": createdOn
        ] as [String : Any]
        
        convertDocToJson()
        changelogs.append(dict)
        docChangeLogs = ["changelogs" : changelogs]
        saveDelegate?.handleOnChange(docChangelog: dict, doc: doc)
        return dict
    }
    
    // MARK: - Chart onChange Method
    func chartOnChange(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, change: [String: Any], createdOn: Int) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": "field.update",
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId,
            "change": change,
            "createdOn": createdOn
        ] as [String: Any]
        
        convertDocToJson()
        changelogs.append(dict)
        docChangeLogs = ["changelogs": changelogs]
        saveDelegate?.handleOnChange(docChangelog: dict, doc: doc)
        return dict
    }
    
    // MARK: - Page onChange Method
    func pageDeleteOnChange(id: String, identifier: String, fileId: String, pageId: String, createdOn: Int, target: String) -> [String: Any] {
        let dict = [
            "_id": id,
            "sdk": "swift",
            "v": 1,
            "createdOn": createdOn,
            "fileId": fileId,
            "identifier": identifier,
            "pageId": pageId,
            "target": target
        ] as [String: Any]
        changelogs.append(dict)
        
        let mobileView = [
            "_id": id,
            "sdk": "swift",
            "v": 1,
            "createdOn": createdOn,
            "fileId": fileId,
            "identifier": identifier,
            "pageId": pageId,
            "target": target,
            "view": "mobile"
        ] as [String: Any]
        changelogs.append(mobileView)
        
        convertDocToJson()
        docChangeLogs = ["changelogs": changelogs]
        saveDelegate?.handleOnChange(docChangelog: dict, doc: doc)
        return dict
    }
    
    func pageDuplicateOnChange(id: String, identifier: String, fileId: String, createdOn: Int, target: String, change: [String: Any], fieldChange: [[String: Any]]) -> [[String: Any]] {
        let primaryPages = [
            "_id": id,
            "sdk": "swift",
            "v": 1,
            "createdOn": createdOn,
            "fileId": fileId,
            "identifier": identifier,
            "target": target,
            "change": change
        ] as [String: Any]
        changelogs.append(primaryPages)
        
        if joyDocStruct?.files?[0].views?.count != 0 {
            let mobileView = [
                "_id": id,
                "sdk": "swift",
                "v": 1,
                "createdOn": createdOn,
                "fileId": fileId,
                "identifier": identifier,
                "target": target,
                "change": change,
                "view": "mobile",
                "viewId": mobileViewId
            ] as [String: Any]
            changelogs.append(mobileView)
        }
        
        for i in 0..<fieldChange.count {
            let fields = [
                "_id": id,
                "sdk": "swift",
                "v": 1,
                "createdOn": createdOn,
                "fileId": fileId,
                "identifier": identifier,
                "target": "field.create",
                "change": fieldChange[i]
            ] as [String: Any]
            changelogs.append(fields)
        }
        
        convertDocToJson()
        docChangeLogs = ["changelogs": changelogs]
        saveDelegate?.handleOnChange(docChangelog: docChangeLogs, doc: doc)
        return changelogs
    }
    
    // MARK: - Field Focus and Blur Method
    func handleBlur(index: Int) {
        _ = fieldBlur(id: joyDocId,
                       identifier: joyDocIdentifier,
                       fileId: joyDocFieldData[index].file ?? "",
                       pageId: joyDocPageId[pageIndex],
                       fieldId: joyDocFieldData[index].id ?? "",
                       fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                      fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                       target: "fieldPosition.blur")
    }
    
    func handleFocus(index: Int) {
        _ = fieldFocus(id: joyDocId,
                       identifier: joyDocIdentifier,
                       fileId: joyDocFieldData[index].file ?? "",
                       pageId: joyDocPageId[pageIndex],
                       fieldId: joyDocFieldData[index].id ?? "",
                       fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                       fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                       target: "fieldPosition.focus")
    }
    
    func handleTableOnFocus(rowId: String, columnId: String, columnIdentifier: String, index: Int) {
        _ = tableFieldFocus(id: joyDocId,
                            identifier: joyDocIdentifier,
                            fileId: joyDocFieldData[index].file ?? "",
                            pageId: joyDocPageId[pageIndex],
                            fieldId: joyDocFieldData[index].id ?? "",
                            fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                            fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                            target: "fieldPosition.focus",
                            columnId: columnId,
                            columnIdentifier: columnIdentifier,
                            rowId: rowId)
    }
    
    func handleTableOnBlur(rowId: String, columnId: String, columnIdentifier: String, index: Int) {
        _ = tableFieldBlur(id: joyDocId,
                           identifier: joyDocIdentifier,
                           fileId: joyDocFieldData[index].file ?? "",
                           pageId: joyDocPageId[pageIndex],
                           fieldId: joyDocFieldData[index].id ?? "",
                           fieldIdentifier: joyDocFieldData[index].identifier ?? "",
                           fieldPositionId: joyDocFieldPositionData?[index].id ?? "",
                           target: "fieldPosition.blur",
                           columnId: columnId,
                           columnIdentifier: columnIdentifier,
                           rowId: rowId)
    }
    
    func fieldBlur(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, target: String) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": target,
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId
        ] as [String : Any]
        
        blurAndFocusParams = dict
        saveDelegate?.handleOnBlur(blurAndFocusParams: blurAndFocusParams)
        return dict
    }
    
    func fieldFocus(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, target: String) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": target,
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId
        ] as [String : Any]
        
        blurAndFocusParams = dict
        saveDelegate?.handleOnFocus(blurAndFocusParams: blurAndFocusParams)
        return dict
    }
    
    func tableFieldFocus(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, target: String, columnId: String, columnIdentifier: String, rowId: String) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": target,
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId,
            "fieldRowId": rowId,
            "fieldColumnId": columnId,
            "fieldColumnIdentifier": columnIdentifier
        ] as [String : Any]
        
        blurAndFocusParams = dict
        saveDelegate?.handleOnFocus(blurAndFocusParams: blurAndFocusParams)
        return dict
    }
    
    func tableFieldBlur(id: String, identifier: String, fileId: String, pageId: String, fieldId: String, fieldIdentifier: String, fieldPositionId: String, target: String, columnId: String, columnIdentifier: String, rowId: String) -> [String: Any] {
        let dict = [
            "sdk": "swift",
            "v": 1,
            "target": target,
            "_id": id,
            "identifier": identifier,
            "fileId": fileId,
            "pageId": pageId,
            "fieldId": fieldId,
            "fieldIdentifier": fieldIdentifier,
            "fieldPositionId": fieldPositionId,
            "fieldRowId": rowId,
            "fieldColumnId": columnId,
            "fieldColumnIdentifier": columnIdentifier
        ] as [String : Any]
        
        blurAndFocusParams = dict
        saveDelegate?.handleOnBlur(blurAndFocusParams: blurAndFocusParams)
        return dict
    }
    
    func convertDocToJson() {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let docToJson = try jsonEncoder.encode(joyDocStruct)
            if let jsonObject = try JSONSerialization.jsonObject(with: docToJson, options: []) as? [String: Any] {
                doc = jsonObject
            }
        } catch {
            print("Error encoding the Page struct to JSON: \(error)")
        }
    }
}
