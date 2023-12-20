
import Foundation

protocol DocumentsViewModelDelegate: AnyObject {
    func didFinish()
    func didFail(_ error: Error)
}

// Retrieves documents (not templates)
class DocumentsViewModel {
    
    private(set) var documents = [Document]()
    
    weak var delegate: DocumentsViewModelDelegate?
    
    @MainActor
    func getDocuments() {
        
        Task { [weak self] in
                
            do {
                
                let url = URL(string: "https://reqres.in/api/users")!
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // REMOVE ME WE DONT USE SNAKE CASING IN JOYFILL....
                print("data: ", data)
                let documentsRes = try decoder.decode(DocumentsResponse.self, from: data)
                self?.documents = documentsRes.data
                self?.delegate?.didFinish()
                
            } catch {
                
                self?.delegate?.didFail(error)
                print(error)
                
            }
            
        }
        
    }
}
