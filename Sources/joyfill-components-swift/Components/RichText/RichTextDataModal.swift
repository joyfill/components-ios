import Foundation

struct RichTextData: Codable {
    let blocks: [Block]
    let entityMap: [String: String]
}

struct Block: Codable {
    let key: String
    let text: String
    let type: String
    let depth: Int
    let inlineStyleRanges: [InlineStyleRange]
    let entityRanges: [String]
    let data: [String: String]
}

struct InlineStyleRange: Codable {
    let offset: Int
    let length: Int
    let style: String
}
