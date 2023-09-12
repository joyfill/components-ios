import Foundation

// MARK: - JoyFillAPI
struct JoyFillAPI: Codable {
    let id, type, stage: String?
    let metadata: Metadata?
    let identifier, name: String?
    let createdOn: Int?
    let files: [File]?
    let fields: [JoyFillAPIField]?
    let categories: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type, stage, metadata, identifier, name, createdOn, files, fields, categories
    }
}

// MARK: - JoyFillAPIField
struct JoyFillAPIField: Codable {
    let type, id, identifier, title: String?
    let value: ValueUnion?
    let fieldRequired: Bool?
    let metadata: Metadata?
    let file: String?
    let options: [Option]?
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
    }
}

// MARK: - Metadata
struct Metadata: Codable {
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
    case valueElementArray([ValueElement])

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
    let points: [Point]?
    var cells: [String: String]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case url, fileName, filePath, deleted, title, description, points, cells
    }
}

// MARK: - Point
struct Point: Codable {
    let id, label: String?
    let y, x: CGFloat?

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
    let views: [View]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata, name, version, styles, pages, views
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
    let displayType: DisplyType?
    let width: Double?
    let height: Double?
    let x: Double?
    let y: Double?
    let id, type, targetValue: String?
    let fontSize: Int?
    let fontColor, fontStyle, fontWeight, textAlign: String?
    let primaryDisplayOnly: Bool?

    enum CodingKeys: String, CodingKey {
        case field, displayType, width, height, x, y
        case id = "_id"
        case type, targetValue, fontSize, fontColor, fontStyle, fontWeight, textAlign, primaryDisplayOnly
    }
}

enum DisplyType: String, Codable {
    case original = "original"
}

// MARK: - View
struct View: Codable {
    let type: String?
    let pageOrder: [JSONAny]?
    let pages: [Page]?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case type, pageOrder, pages
        case id = "_id"
    }
}
