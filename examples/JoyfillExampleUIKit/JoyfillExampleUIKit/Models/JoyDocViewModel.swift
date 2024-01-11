
import Foundation
import Alamofire
import SwiftyJSON

protocol JoyDocViewModelDelegate: AnyObject {
    func didFinish()
    func didFail(_ error: Error)
}

// Retrieves documents (not templates)
class JoyDocViewModel {
    
    private(set) var activeJoyDoc: Any?
    
    weak var delegate: JoyDocViewModelDelegate?
    
    @MainActor
    func fetchJoyDoc(identifier: String) {
        
        Task { [weak self] in
            
            let url = "\(Constants.baseURL)/\(identifier)"
            print("Go get documents from \(url)")
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(Constants.userAccessToken)",
                "Content-Type": "application/json"
            ]
            
            AF.request(url, method: .get, headers: headers).validate().response { response in
                switch response.result {
                case .success(let value):
                    self?.activeJoyDoc = value
                    self?.delegate?.didFinish()
                    print("Success! Retrieved json (joydoc).")
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @MainActor
    func updateDocumentChangelogs(identifier: String, docChangeLogs: Any) {
        do {
            guard let url = URL(string: "\(Constants.baseURL)/\(identifier)/changelogs") else {
                print("Invalid json url")
                return
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: docChangeLogs, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("Bearer \(Constants.userAccessToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating changelogs: \(error)")
                } else if let data = data {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
                    let _ = json as? NSDictionary
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
}
