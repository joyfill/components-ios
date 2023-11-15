import Foundation
import Combine

class JoyDocViewModel: ObservableObject {
    @Published var joyDocLoading = false
    @Published var joyDocError = ""
    
    // Pulls in the JoyDoc raw JSON data for adding to our ViewController
    func fetchJoyDoc(identifier: String, userAccessToken: String, completion: @escaping ((Any) -> Void)) {
        guard let url = URL(string: "\(Constants.baseURL)/\(identifier)") else {
            print("Invalid json url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                                        
                    // This dispatches on the main thread an update to our  @Published
                    // variable where our UI is also listening on the main thread for
                    // changes to occur to, when it does it rerenders the UI
                    DispatchQueue.main.async {
                        self.joyDocLoading = false
                    }
                    
                    completion(data)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.joyDocLoading = false
                    self.joyDocError = error?.localizedDescription ?? "Fetching error"
                }
                
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    func updateDocumentChangelogs(identifier: String, userAccessToken: String, docChangeLogs: Any) {
        do {
            guard let url = URL(string: "\(Constants.baseURL)/\(identifier)/changelogs") else {
                print("Invalid json url")
                return
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: docChangeLogs, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("Bearer \(userAccessToken)", forHTTPHeaderField: "Authorization")
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
        
    /* Async alternative to loading JoyDoc JSON
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
            let _ = json as? NSDictionary
            self.joyDocJSON = json
        } catch {
            print("Error getting joydoc \(error)")
        }
     */
        
}


