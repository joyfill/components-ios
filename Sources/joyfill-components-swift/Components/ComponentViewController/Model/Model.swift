import Foundation

public var componentType = [String]()
public var dropdownOptions = [String]()
public var multiSelectOptions = [String]()
public var componentHeaderText = [String]()

public var textAreaString: String?
public var textFieldString: String?
public var blockFieldString: String?
public var numberFieldString: Double?

public var blockTextSize = Int()
public var blockTextColor = String()
public var blockTextStyle = String()
public var blockTextWeight = String()
public var blockTextAlignment = String()

var pageCount = Int()
var fieldCount = Int()
var optionCount = Int()
var tableColumnsCount = Int()
var componentTypeValue = String()

// MARK: - Welcome
struct JoyfillApi: Codable {
    let id, type, stage: String?
    let metadata: Metadata?
    let identifier, name: String?
    let createdOn: Int?
    let files: [File]?
    let fields: [JoyfillApiField]?
    let categories: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, stage, metadata, identifier, name, createdOn, files, fields, categories
    }
}

// MARK: - WelcomeField
struct JoyfillApiField: Codable {
    let file, id, field, type: String?
    let identifier, title: String?
    let value: TentacledValue?
    let metadata: Metadata?
    let options: [PurpleOption]?
    let tableColumns: [PurpleTableColumn]?

    enum CodingKeys: String, CodingKey {
        case file
        case id = "_id"
        case field, type, identifier, title, value, metadata, options, tableColumns
    }
}

// MARK: - Metadata
struct Metadata: Codable {
}

// MARK: - PurpleOption
struct PurpleOption: Codable {
    let value: String?
    let deleted: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case value, deleted
        case id = "_id"
    }
}

// MARK: - PurpleTableColumn
struct PurpleTableColumn: Codable {
    let title, type, identifier: String?
    let optionOrder: [JSONAny]?
    let width, maxImageWidth, maxImageHeight: Int?
    let deficiencies, requireDeficiencyTitle, requireDeficiencyDescription, requireDeficiencyPhoto: Bool?
    let blockImport, deleted: Bool?
    let id: String?
    let options: [PurpleOption]?

    enum CodingKeys: String, CodingKey {
        case title, type, identifier, optionOrder, width, maxImageWidth, maxImageHeight, deficiencies, requireDeficiencyTitle, requireDeficiencyDescription, requireDeficiencyPhoto, blockImport, deleted
        case id = "_id"
        case options
    }
}

enum TentacledValue: Codable {
    case purpleValueArray([PurpleValue])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PurpleValue].self) {
            self = .purpleValueArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(TentacledValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for TentacledValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .purpleValueArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - PurpleValue
struct PurpleValue: Codable {
    let id: String?
    let deleted: Bool?
    let cells: Metadata?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deleted, cells
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
    let views: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, version, styles, pages, views
    }
}

// MARK: - Page
struct Page: Codable {
    let id: String?
    let metadata: Metadata?
    let name: String?
    let width, height, cols, rowHeight: Int?
    let layout, presentation: String?
    let margin, padding, borderWidth: Int?
    let fields: [PageField]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, width, height, cols, rowHeight, layout, presentation, margin, padding, borderWidth, fields
    }
}

// MARK: - PageField
struct PageField: Codable {
    let type: String?
    let displayType: DisplayType?
    let title, identifier, id, field: String?
    let value: StickyValue?
    let x, y: Int?
    let options: [FluffyOption]?
    let multi: Bool?
    let format: String?
    let fontSize: Int?
    let fontColor, fontWeight, fontStyle, textAlign: String?
    let textDecoration, textTransform, yTitle: String?
    let yMax, yMin: Int?
    let xTitle: String?
    let xMax, xMin: Int?
    let rowOrder, tableColumnOrder: [String]?
    let tableColumns: [FluffyTableColumn]?

    enum CodingKeys: String, CodingKey {
        case type, displayType, title, identifier
        case id = "_id"
        case field, value, x, y, options, multi, format, fontSize, fontColor, fontWeight, fontStyle, textAlign, textDecoration, textTransform, yTitle, yMax, yMin, xTitle, xMax, xMin, rowOrder, tableColumnOrder, tableColumns
    }
}

enum DisplayType: String, Codable {
    case original = "original"
}

// MARK: - FluffyOption
struct FluffyOption: Codable {
    let id, value: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case value
    }
}

// MARK: - FluffyTableColumn
struct FluffyTableColumn: Codable {
    let id, title, type, identifier: String?
    let value: String?
    let options: [FluffyOption]?
    let maxImageWidth, maxImageHeight: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, type, identifier, value, options, maxImageWidth, maxImageHeight
    }
}

enum StickyValue: Codable {
    case double(Double)
    case fluffyValueArray([FluffyValue])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([FluffyValue].self) {
            self = .fluffyValueArray(x)
            return
        }
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(StickyValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for StickyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .fluffyValueArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - FluffyValue
struct FluffyValue: Codable {
    let id: String?
    let url: String?
    let points: [Point]?
    let cells: Cells?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url, points, cells
    }
}

// MARK: - Cells
struct Cells: Codable {
    let the62Be03C708965De549C195Aa, the62Be03C708965De549C195Bb: String?
    let the62Be03C708965De549C195Cc: [The62Be03C708965De549C195Cc]?

    enum CodingKeys: String, CodingKey {
        case the62Be03C708965De549C195Aa = "62be03c708965de549c195aa"
        case the62Be03C708965De549C195Bb = "62be03c708965de549c195bb"
        case the62Be03C708965De549C195Cc = "62be03c708965de549c195cc"
    }
}

// MARK: - The62Be03C708965De549C195Cc
struct The62Be03C708965De549C195Cc: Codable {
    let id: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url
    }
}

// MARK: - Point
struct Point: Codable {
    let id, label: String?
    let y: CGFloat?
    let x: CGFloat?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case label, y, x
    }
}

// MARK: Extension to fetch data from model
var pointCount = Int()
extension JoyfillApi {
    static func loadFromJSON() -> [JoyfillApi]? {
        // Deinitialize arrays to protect memory leakage
        componentType.removeAll()
        dropdownOptions.removeAll()
        multiSelectOptions.removeAll()
        componentHeaderText.removeAll()
        
        guard let fileURL = Bundle.main.url(forResource: "APIJson", withExtension: "json") else {
            print("APIJson.json file not found.")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(JoyfillApi.self, from: jsonData)
            
            pageCount = apiResponse.files?[0].pages?.count ?? 0
            for i in 0..<pageCount {
                fieldCount = apiResponse.files?[0].pages?[i].fields?.count ?? 0
                for j in 0..<fieldCount {
                    componentType.append(apiResponse.files?[0].pages?[i].fields?[j].type ?? "")
                    componentHeaderText.append(apiResponse.files?[0].pages?[i].fields?[j].title ?? "")
                    componentTypeValue = apiResponse.files?[0].pages?[i].fields?[j].type ?? ""

                    // MARK: Functions call
                    if let value = apiResponse.files?[0].pages?[i].fields?[j].value {
                        switch value {
                        case .string(let string):
                            if componentType[j] == "textarea" {
                                textAreaString = string
                            }
                            if componentType[j] == "block" {
                                blockFieldString = string
                                blockTextSize = apiResponse.files?[0].pages?[i].fields?[j].fontSize ?? 18
                                blockTextStyle = apiResponse.files?[0].pages?[i].fields?[j].fontStyle ?? ""
                                blockTextWeight = apiResponse.files?[0].pages?[i].fields?[j].fontWeight ?? ""
                                blockTextColor = apiResponse.files?[0].pages?[i].fields?[j].fontColor ?? "#000000"
                                blockTextAlignment = apiResponse.files?[0].pages?[i].fields?[j].textAlign ?? "left"
                            }
                            if componentType[j] == "text" {
                                textFieldString = string
                            }
                            
                        case .fluffyValueArray(let valueElements):
                            if componentType[j] == "chart" {
                                for k in 0..<valueElements.count {
                                    var graphLabelSubArray: [String] = []
                                    var graphXCoordinateSubArray: [CGFloat] = []
                                    var graphYCoordianteSubArray: [CGFloat] = []
                                    if let points = valueElements[k].points {
                                        for l in 0..<points.count {
                                            let label = points[l].label ?? ""
                                            graphLabelSubArray.append(label)
                                            
                                            let xCoordinate = points[l].x ?? 0
                                            graphXCoordinateSubArray.append(xCoordinate)
                                            
                                            let yCoordinate = points[l].y ?? 0
                                            graphYCoordianteSubArray.append(yCoordinate)
                                        }
                                    }
                                    graphLabelData.append(graphLabelSubArray)
                                    xCoordinates.append(graphXCoordinateSubArray)
                                    yCoordinates.append(graphYCoordianteSubArray)
                                }
                            }
                            
                            if componentType[j] == "image" {
                                for k in 0..<valueElements.count {
                                    pickedImg.append(valueElements[k].url ?? "")
                                }
                            }
                            
                        case .double(let double):
                            if componentType[j] == "number" {
                                numberFieldString = double
                            }
                        }
                    }
                    
                    
                    optionCount = apiResponse.files?[0].pages?[i].fields?[j].options?.count ?? 0
                    for n in 0..<optionCount {
                        if componentTypeValue == "dropdown" {
                            dropdownOptions.append(apiResponse.files?[0].pages?[i].fields?[j].options?[n].value ?? "")
                        }
                        if componentTypeValue == "multiSelect" {
                            multiSelectOptions.append(apiResponse.files?[0].pages?[i].fields?[j].options?[n].value ?? "")
                        }
                    }
                }
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
}
