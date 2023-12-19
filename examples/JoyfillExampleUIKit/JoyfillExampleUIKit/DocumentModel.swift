
import Foundation

// An individual joydoc json object
struct DocumentsResponse: Codable {
    let data: [Document]
}

struct Document: Codable {
    let email: String
    let firstName: String
    let lastName: String
}

