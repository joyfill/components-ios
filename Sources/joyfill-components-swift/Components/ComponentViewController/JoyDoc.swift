import Foundation
import UIKit

// Global variables
var joyDocStruct: JoyDoc?
public var componentType = [String]()
public var componentsYValueForMobileView = [Int]()

// Variables to save input values
public var numberFieldString: Int?
public var textAreaString: String?
public var textFieldString: String?
public var blockFieldString: String?
public var richTextValue = [String]()

// Variable to save block field custom style values
public var blockTextSize = [Int]()
public var blockTextColor = [String]()
public var blockTextStyle = [String]()
public var blockTextWeight = [String]()
public var blockTextAlignment = [String]()

public var componentId = [String]()
public var tableRowOrder = [[String]]()
public var tableColumnType = [[String]]()
public var tableColumnTitle = [[String]]()
public var tableCellsData = [[[String]]]()
public var tableColumnOrderId = [[String]]()
public var multiSelectOptionId: [[String]] = []

var joyDocId = String()
var valueUnion: [ValueUnion] = []
var joyDocFieldData: [JoyDocField] = []
var tableFieldValue: [[ValueElement]] = []
var chartValueElement = [[ValueElement]]()
var optionsData: [[FieldTableColumn]] = []
var joyDocFieldPositionData: [FieldPosition] = []
var joyDocPageId = [String]()

// Variable to save counts
var pageCount = Int()
var fieldCount = Int()
var optionCount = Int()
var tableColumnsCount = Int()
var componentTypeValue = String()

// MARK: - JoyDoc
struct JoyDoc: Codable {
    let id, type, stage: String?
    let metadata: Metadata?
    let identifier, name: String?
    let createdOn: Int?
    let files: [File]?
    let fields: [JoyDocField]?
    let categories: [JSONAny]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, stage, metadata, identifier, name, createdOn, files, fields, categories
    }
}

// MARK: - JoyDocField
struct JoyDocField: Codable {
    let type, id, identifier, title: String?
    let value: ValueUnion?
    let fieldRequired: Bool?
    let metadata: Metadata?
    let file: String?
    let options: [Option]?
    let tipTitle, tipDescription: String?
    let tipVisible: Bool?
    let multi: Bool?
    let yTitle: String?
    let yMax, yMin: Int?
    let xTitle: String?
    let xMax, xMin: Int?
    let rowOrder: [String]?
    let tableColumns: [FieldTableColumn]?
    let tableColumnOrder: [String]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case id = "_id"
        case identifier, title, value
        case fieldRequired = "required"
        case metadata, file, options, multi, yTitle, yMax, yMin, xTitle, xMax, xMin, rowOrder, tableColumns, tableColumnOrder
        case tipTitle, tipDescription, tipVisible
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let deficiencies, blockImport, blockAutoPopulate, requireDeficiencyTitle: Bool?
    let requireDeficiencyDescription, requireDeficiencyPhoto: Bool?
    let list, listColumn: String?
}

// MARK: - Option
struct Option: Codable {
    let value: String?
    let deleted: Bool?
    let id: String?
    let width: Int?
    
    enum CodingKeys: String, CodingKey {
        case value, deleted
        case id = "_id"
        case width
    }
}

// MARK: - FieldTableColumn
struct FieldTableColumn: Codable {
    let id, type, title: String?
    let width: Int?
    let identifier: String?
    let options: [Option]?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, title, width, identifier, options, value
    }
}

enum ValueUnion: Codable {
    case integer(Int)
    case string(String)
    case array([String])
    case valueElementArray([ValueElement])
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode([ValueElement].self) {
            self = .valueElementArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode([String].self) {
            self = .array(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(ValueUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ValueUnion"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .valueElementArray(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: - ValueElement
struct ValueElement: Codable {
    let id: String?
    let url: String?
    let fileName, filePath: String?
    let deleted: Bool?
    let title, description: String?
    var points: [Point]?
    var cells: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url, fileName, filePath, deleted, title, description, points, cells
    }
 
}

// MARK: - Point
struct Point: Codable {
    var id, label: String?
    var y, x: CGFloat?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case label, y, x
    }
}

// MARK: - File
struct File: Codable {
    let id: String?
    let metadata: Metadata?
    let name: String?
    let version: Int?
    let styles: Metadata?
    let pages: [Page]?
    let pageOrder: [String]?
    let views: [View]?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, version, styles, pages, views, pageOrder
    }
}

// MARK: - Page
struct Page: Codable {
    let name: String?
    let fieldPositions: [FieldPosition]?
    let metadata: Metadata?
    let width, height, cols, rowHeight: Int?
    let layout, presentation: String?
    let margin, padding, borderWidth: Int?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name, fieldPositions, metadata, width, height, cols, rowHeight, layout, presentation, margin, padding, borderWidth
        case id = "_id"
    }
}

// MARK: - FieldPosition
struct FieldPosition: Codable {
    let field: String?
    let displayType: String?
    let width: Double?
    let height: Double?
    let x: Double?
    let y: Double?
    let id, type, targetValue: String?
    let fontSize: Int?
    let fontColor, fontStyle, fontWeight, textAlign: String?
    let primaryDisplayOnly: Bool?
    let format: String?
    let column: String?
    
    enum CodingKeys: String, CodingKey {
        case field, displayType, width, height, x, y
        case id = "_id"
        case type, targetValue, fontSize, fontColor, fontStyle, fontWeight, textAlign, primaryDisplayOnly, format, column
    }
}

// MARK: - View
struct View: Codable {
    let type: String?
    let pageOrder: [String]?
    let pages: [Page]?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case type, pageOrder, pages
        case id = "_id"
    }
}

// MARK: - Extension to fetch data from model
public var jsonData = Data()
extension JoyDoc {
    public static func loadFromJSON() -> [JoyDoc]? {
        do {
            joyDocStruct = try JSONDecoder().decode(JoyDoc.self, from: jsonData)
            
            // It will prevent tasks to perform on main thread
            DispatchQueue.main.async {
                // Deinitialize arrays to protect memory leakage
                cellView.removeAll()
                yPointsData.removeAll()
                xPointsData.removeAll()
                optionsData.removeAll()
                componentId.removeAll()
                signedImage.removeAll()
                yCoordinates.removeAll()
                xCoordinates.removeAll()
                joyDocPageId.removeAll()
                chartPointsId.removeAll()
                richTextValue.removeAll()
                tableRowOrder.removeAll()
                componentType.removeAll()
                graphLabelData.removeAll()
                tableCellsData.removeAll()
                dropdownOptions.removeAll()
                tableColumnType.removeAll()
                joyDocFieldData.removeAll()
                tableFieldValue.removeAll()
                tableColumnTitle.removeAll()
                chartValueElement.removeAll()
                tableColumnOrderId.removeAll()
                multiSelectOptions.removeAll()
                multiSelectOptionId.removeAll()
                joyDocFieldPositionData.removeAll()
                componentTableViewCellHeight.removeAll()
                multiChoiseSelectedIndexPath.removeAll()
                componentsYValueForMobileView.removeAll()
                selectedDropdownOptionIndexPath.removeAll()
                
                fetchDataFromJoyDoc()
                
                componentTableView.delegate = viewForDataSource as? any UITableViewDelegate
                componentTableView.dataSource = viewForDataSource as? any UITableViewDataSource
                componentTableView.reloadData()
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
}

// MARK: - Function to get data from API
func fetchDataFromJoyDoc() {
    joyDocId = joyDocStruct?.id ?? ""
    if joyDocStruct?.files?[0].views?.count == 0 {
        // Fetch data for primary view
        pageCount = joyDocStruct?.files?[0].pages?.count ?? 0
        
        for i in 0..<pageCount {
            joyDocPageId.append(joyDocStruct?.files?[0].pages?[i].id ?? "")
            fieldCount = joyDocStruct?.files?[0].pages?[i].fieldPositions?.count ?? 0
            joyDocPageId.append(joyDocStruct?.files?[0].pages?[i].id ?? "")
            for j in 0..<fieldCount {
                // Get y value of all components
                let displayType = joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].displayType
                if displayType == "original" || displayType == "inputGroup" {
                    let yFieldValue = joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].y ?? 0.0
                    componentsYValueForMobileView.append(Int(yFieldValue))
                    componentTypeValue = joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].type ?? ""
                    componentId.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].field ?? "")
                    componentType.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].type ?? "")
                    joyDocFieldPositionData.append((joyDocStruct?.files?[0].pages?[0].fieldPositions?[j])!)
                    zipAndSortComponents()
                }
                if joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].type == FieldTypes.block {
                    blockTextSize.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].fontSize ?? 18)
                    blockTextStyle.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].fontStyle ?? "")
                    blockTextWeight.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].fontWeight ?? "")
                    blockTextColor.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000")
                    blockTextAlignment.append(joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].textAlign ?? "left")
                } else {
                    blockTextSize.append(0)
                    blockTextStyle.append("")
                    blockTextWeight.append("")
                    blockTextColor.append("")
                    blockTextAlignment.append("")
                }
            }
            
            // Save field data from JoyDoc
            for k in 0..<componentId.count {
                if let field = joyDocStruct?.fields?.first(where: { $0.id == componentId[k] }){
                    joyDocFieldData.append(field)
                    initializeVariablesWithEmptyValues()
                }
            }
        }
    } else {
        // Fetch data for mobile view
        pageCount = joyDocStruct?.files?[0].views?[0].pages?.count ?? 0
        for i in 0..<pageCount {
            joyDocPageId.append(joyDocStruct?.files?[0].pages?[i].id ?? "")
            fieldCount = joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?.count ?? 0
            for j in 0..<fieldCount {
                // Get y value of all components
                let displayType = joyDocStruct?.files?[0].pages?[i].fieldPositions?[j].displayType
                if displayType == "original" || displayType == "inputGroup" {
                    let yFieldValue = joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].y ?? 0.0
                    componentsYValueForMobileView.append(Int(yFieldValue))
                    componentType.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].type ?? "")
                    componentId.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].field ?? "")
                    joyDocFieldPositionData.append((joyDocStruct?.files?[0].views?[0].pages?[0].fieldPositions?[i])!)
                    zipAndSortComponents()
                }
                if joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].type == FieldTypes.block {
                    blockTextSize.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontSize ?? 18)
                    blockTextStyle.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontStyle ?? "")
                    blockTextWeight.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontWeight ?? "")
                    blockTextColor.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].fontColor ?? "#000000")
                    blockTextAlignment.append(joyDocStruct?.files?[0].views?[0].pages?[i].fieldPositions?[j].textAlign ?? "left")
                } else {
                    blockTextSize.append(0)
                    blockTextStyle.append("")
                    blockTextWeight.append("")
                    blockTextColor.append("")
                    blockTextAlignment.append("")
                }
            }
            
            // Get values of the components from the fields
            for k in 0..<componentId.count {
                componentTypeValue = joyDocStruct?.fields?[k].type ?? ""
            }
        }
        
        // Get the title of the components
        for i in 0..<componentType.count {
            if let field = joyDocStruct?.fields?.first(where: { $0.id == componentId[i] }) {
                joyDocFieldData.append(field)
                initializeVariablesWithEmptyValues()
            }
        }
    }
}



// Zip and sort componentType and ComponentHeaderText with componentsYValueForMobileView
func zipAndSortComponents() {
    var componentIdPairedArray = Array(zip(componentsYValueForMobileView, componentId))
    var componentTypePairedArray = Array(zip(componentsYValueForMobileView, componentType))
    var fieldPositionPairedArray = Array(zip(componentsYValueForMobileView, joyDocFieldPositionData))
    componentIdPairedArray.sort { $0.0 < $1.0}
    componentTypePairedArray.sort { $0.0 < $1.0 }
    fieldPositionPairedArray.sort { $0.0 < $1.0 }
    
    // Extract the sorted values back into the original arrays
    componentId = componentIdPairedArray.map { $0.1 }
    componentType = componentTypePairedArray.map { $0.1 }
    joyDocFieldPositionData = fieldPositionPairedArray.map { $0.1 }
    componentsYValueForMobileView = componentTypePairedArray.map { $0.0 }
}

func initializeVariablesWithEmptyValues() {
    yPointsData.append([])
    xPointsData.append([])
    signedImage.append("")
    optionsData.append([])
    yCoordinates.append([])
    xCoordinates.append([])
    chartPointsId.append([])
    richTextValue.append("")
    multiSelect.append(true)
    tableRowOrder.append([])
    cellView.append(UIView())
    graphLabelData.append([])
    tableCellsData.append([])
    selectedPicture.append([])
    tableFieldValue.append([])
    dropdownOptions.append([])
    tableColumnType.append([])
    tableColumnTitle.append([])
    chartValueElement.append([])
    tableColumnOrderId.append([])
    multiSelectOptions.append([])
    multiSelectOptionId.append([])
    imageSelectionCount.append([])
    pickedSinglePicture.append([])
    componentTableViewCellHeight.append(0)
    singleChoiseSelectedIndexPath.append(0)
    multiChoiseSelectedIndexPath.append([])
    selectedDropdownOptionIndexPath.append(0)
}
