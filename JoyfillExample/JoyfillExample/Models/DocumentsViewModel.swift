import Foundation
import Combine
import SwiftyJSON

class DocumentsViewModel: ObservableObject {
    var JoyDocModel = JoyDocViewModel()
    
    // This @Published property stores the array of Document instances.
    // SwiftUI views can bind to thsi property and be notified when it changes.
    @Published var documents: [Document] = []
    @Published var documentsLoading = false
    @Published var error: String?
    
    @Published var documentsJoyDocJSON: Any?
    @Published var documentsJoyDocLoading = false
    
    @Published var submissions: [Document] = []
    @Published var submissionsLoading = false
    @Published var submissionsError: String?
    
    @Published var activeSubmissionIdentifier: String?
        
    @Published var userAccessToken = Constants.userAccessToken
    
    func setActiveSubmissionIdentifier(identifier: String) {
        self.activeSubmissionIdentifier = identifier
    }
    
    // MARK: - Templates (Fetches documents or templates from Joyfill API)
    func fetchDocuments() {
        
        // The URL for the GET request
        guard let url = URL(string: "\(Constants.baseURL)?limit=25&page=1&type=template&stage=published") else {
            print("invalid url")
            return
        }
        
        print("Url \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let documents = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    
                    print("Retrieved \(documents.data.count) documents")
                    
                    // This dispatches on the main thread an update to our  @Published
                    // variable where our UI is also listening on the main thread for
                    // changes to occur to, when it does it rerenders the UI
                    DispatchQueue.main.async {
                        self.documentsLoading = false
                        self.documents = documents.data
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.documentsLoading = false
                        self.error = error.localizedDescription
                    }
                    
                    print("Decoding error: \(error)")
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.documentsLoading = false
                    self.error = error?.localizedDescription ?? "Fetching error"
                }
                
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    // MARK: - Submissions
    func fetchDocumentSubmissions(identifier: String) {
        
        // The URL for the GET request
        guard let url = URL(string: "\(Constants.baseURL)?template=\(identifier)&page=1&limit=25") else {
            print("invalid url")
            return
        }
        
        print("Url \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let submissions = try JSONDecoder().decode(DocumentListResponse.self, from: data)
                    
                    print("Retrieved \(submissions.data.count) document submissions")
                    
                    // This dispatches on the main thread an update to our  @Published
                    // variable where our UI is also listening on the main thread for
                    // changes to occur to, when it does it rerenders the UI
                    DispatchQueue.main.async {
                        self.submissionsLoading = false
                        self.submissions = submissions.data
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.submissionsLoading = false
                        self.submissionsError = error.localizedDescription
                    }
                    
                    print("Decoding error: \(error)")
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.submissionsLoading = false
                    self.submissionsError = error?.localizedDescription ?? "Fetching error"
                }
                
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    func createDocumentSubmission(identifier: String, completion: @escaping ((Any) -> Void)) {
        // First we fetch the current template this document is sourced from
        JoyDocModel.fetchJoyDoc(identifier: identifier, userAccessToken: userAccessToken, completion: { joyDocJSON in
            
            print("First Loaded createDocumentSubmission joyDocJSON ", joyDocJSON)
            print("First Loaded createDocumentSubmission identifier ", identifier)
            
            guard let url = URL(string: "\(Constants.baseURL)") else {
                print("Invalid json url")
                return
            }
            var request = URLRequest(url: url)
            var json = JSON(joyDocJSON)

            // Using SwiftyJson we remove some of the uneeded keys, specifically changing the "type" to "document"
            json.dictionaryObject?.removeValue(forKey: "_id")
            json.dictionaryObject?.removeValue(forKey: "createdOn")
            json.dictionaryObject?.removeValue(forKey: "deleted")
            json.dictionaryObject?.removeValue(forKey: "categories")
            json.dictionaryObject?.removeValue(forKey: "stage")
            json.dictionaryObject?.removeValue(forKey: "identifier")
            json.dictionaryObject?.removeValue(forKey: "metadata")
            json.dictionaryObject?.updateValue("document", forKey: "type")
            json.dictionaryObject?.updateValue(identifier, forKey: "template")
            json.dictionaryObject?.updateValue(identifier, forKey: "source")
            
            let jsonData = json.rawString(options: .fragmentsAllowed)?.data(using: .utf8)
            
            /* To see the JoyDoc before creation use this.
             let jsonString = String(data: jsonData!, encoding: .utf8)!
             print(jsonString)
             */

            // Make our request to create a document submission
            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("Bearer \(self.userAccessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error creating submission: \(error)")
                } else if let data = data {
                    let jsonRes = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    let _ = jsonRes as? NSDictionary
                    
                    print("COMPLETE CREATED DOC jsonRes: ", jsonRes ?? "TEST")
                    
                    completion(jsonRes!)
                }
            }.resume()
        })

    }
}
