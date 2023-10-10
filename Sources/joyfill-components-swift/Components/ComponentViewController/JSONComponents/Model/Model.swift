import Foundation
import UIKit

public var componentType2 = [String]()
public var dropdownOptions2 = [String]()
public var multiSelectOptions2 = [String]()
public var componentHeaderText2 = [String]()

public var textAreaString2: String?
public var textFieldString2: String?
public var blockFieldString2: String?
public var numberFieldString2: Double?

public var blockTextSize2 = Int()
public var blockTextColor2 = String()
public var blockTextStyle2 = String()
public var blockTextWeight2 = String()
public var blockTextAlignment2 = String()

var pageCount2 = Int()
var fieldCount2 = Int()
var optionCount2 = Int()
var tableColumnsCount2 = Int()
var componentTypeValue2 = String()

// MARK: - JoyfillApi
public struct JoyfillApi2: Codable {
    let id, type, stage: String?
    let metadata: Metadata2?
    let identifier, name: String?
    let createdOn: Int?
    let files: [File2]?
    let fields: [JoyfillApiField2]?
    let categories: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, stage, metadata, identifier, name, createdOn, files, fields, categories
    }
}

// MARK: - JoyfillApiField
struct JoyfillApiField2: Codable {
    let file, id, field, type: String?
    let identifier, title: String?
    let value: TentacledValue?
    let metadata: Metadata2?
    let options: [PurpleOption2]?
    let tableColumns: [PurpleTableColumn2]?

    enum CodingKeys: String, CodingKey {
        case file
        case id = "_id"
        case field, type, identifier, title, value, metadata, options, tableColumns
    }
}

// MARK: - Metadata
struct Metadata2: Codable {
}

// MARK: - PurpleOption
struct PurpleOption2: Codable {
    let value: String?
    let deleted: Bool?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case value, deleted
        case id = "_id"
    }
}

// MARK: - PurpleTableColumn
struct PurpleTableColumn2: Codable {
    let title, type, identifier: String?
    let optionOrder: [JSONAny]?
    let width, maxImageWidth, maxImageHeight: Int?
    let deficiencies, requireDeficiencyTitle, requireDeficiencyDescription, requireDeficiencyPhoto: Bool?
    let blockImport, deleted: Bool?
    let id: String?
    let options: [PurpleOption2]?

    enum CodingKeys: String, CodingKey {
        case title, type, identifier, optionOrder, width, maxImageWidth, maxImageHeight, deficiencies, requireDeficiencyTitle, requireDeficiencyDescription, requireDeficiencyPhoto, blockImport, deleted
        case id = "_id"
        case options
    }
}

enum TentacledValue: Codable {
    case purpleValueArray([PurpleValue2])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([PurpleValue2].self) {
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
struct PurpleValue2: Codable {
    let id: String?
    let deleted: Bool?
    let cells: Metadata2?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deleted, cells
    }
}

// MARK: - File
struct File2: Codable {
    let id: String?
    let metadata: Metadata2?
    let name: String?
    let version: Int?
    let styles: Metadata2?
    let pages: [Page2]?
    let views: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, version, styles, pages, views
    }
}

// MARK: - Page
struct Page2: Codable {
    let id: String?
    let metadata: Metadata2?
    let name: String?
    let width, height, cols, rowHeight: Int?
    let layout, presentation: String?
    let margin, padding, borderWidth: Int?
    let fields: [PageField2]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, width, height, cols, rowHeight, layout, presentation, margin, padding, borderWidth, fields
    }
}

// MARK: - PageField
struct PageField2: Codable {
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
    let points: [Point2]?
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
struct Point2: Codable {
    let id, label: String?
    let y: CGFloat?
    let x: CGFloat?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case label, y, x
    }
}

// MARK: - Extension to fetch data from model
extension JoyfillApi2 {
    public static func loadFromJSON() -> [JoyfillApi2]? {
        // Deinitialize arrays to protect memory leakage
        componentType2.removeAll()
        dropdownOptions2.removeAll()
        multiSelectOptions2.removeAll()
        componentHeaderText2.removeAll()
        
        guard let fileURL = Bundle.main.url(forResource: "APIJson", withExtension: "json") else {
            print("APIJson.json file not found.")
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(JoyfillApi2.self, from: jsonData)
            
            pageCount2 = apiResponse.files?[0].pages?.count ?? 0
            for i in 0..<pageCount2 {
                fieldCount2 = apiResponse.files?[0].pages?[i].fields?.count ?? 0
                for j in 0..<fieldCount2 {
                    componentType2.append(apiResponse.files?[0].pages?[i].fields?[j].type ?? "")
                    componentHeaderText2.append(apiResponse.files?[0].pages?[i].fields?[j].title ?? "")
                    componentTypeValue2 = apiResponse.files?[0].pages?[i].fields?[j].type ?? ""

                    // MARK: Functions call
                    if let value = apiResponse.files?[0].pages?[i].fields?[j].value {
                        switch value {
                        case .string(let string):
                            if componentType2[j] == "textarea" {
                                textAreaString2 = string
                            }
                            if componentType2[j] == "block" {
                                blockFieldString2 = string
                                blockTextSize2 = apiResponse.files?[0].pages?[i].fields?[j].fontSize ?? 18
                                blockTextStyle2 = apiResponse.files?[0].pages?[i].fields?[j].fontStyle ?? ""
                                blockTextWeight2 = apiResponse.files?[0].pages?[i].fields?[j].fontWeight ?? ""
                                blockTextColor2 = apiResponse.files?[0].pages?[i].fields?[j].fontColor ?? "#000000"
                                blockTextAlignment2 = apiResponse.files?[0].pages?[i].fields?[j].textAlign ?? "left"
                            }
                            if componentType2[j] == "text" {
                                textFieldString2 = string
                            }
                            
                        case .fluffyValueArray(let valueElements):
                            if componentType2[j] == "chart" {
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
//                                    graphLabelData.append(graphLabelSubArray)
//                                    xCoordinates.append(graphXCoordinateSubArray)
//                                    yCoordinates.append(graphYCoordianteSubArray)
                                }
                            }
                            
//                            if componentType2[j] == "image" {
//                                for k in 0..<valueElements.count {
//                                    pickedImg.append(valueElements[k].url ?? "")
//                                    DispatchQueue.main.async {
//                                        componentTableView.reloadData()
//                                    }
//                                }
//                            }
                            
                        case .double(let double):
                            if componentType2[j] == "number" {
                                numberFieldString2 = double
                            }
                        }
                    }
                    
                    
                    optionCount2 = apiResponse.files?[0].pages?[i].fields?[j].options?.count ?? 0
                    for n in 0..<optionCount2 {
                        if componentTypeValue2 == "dropdown" {
                            dropdownOptions2.append(apiResponse.files?[0].pages?[i].fields?[j].options?[n].value ?? "")
                        }
                        if componentTypeValue2 == "multiSelect" {
                            multiSelectOptions2.append(apiResponse.files?[0].pages?[i].fields?[j].options?[n].value ?? "")
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
