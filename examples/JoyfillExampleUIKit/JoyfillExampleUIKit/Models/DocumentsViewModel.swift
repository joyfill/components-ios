
import Foundation
import Alamofire
import SwiftyJSON

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

            let url = "\(Constants.baseURL)?limit=25&page=1&type=document&stage=published"
            print("Go get documents from \(url)")
        
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(Constants.userAccessToken)"
            ]
        
            let response = AF.request(url, method: .get, headers: headers).serializingDecodable(DocumentListResponse.self)
        
            switch await response.result {
            case .success(let res):
                self?.documents = res.data
                self?.delegate?.didFinish()
                print("Success! Retrieved \(res.data.count) docs.")
            case .failure(let error):
                print(error.localizedDescription)
            }
         
        }
    }
}
