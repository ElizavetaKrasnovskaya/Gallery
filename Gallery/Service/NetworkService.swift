import Foundation
import UIKit
import Alamofire

final class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func getImagesFromNetwork(completion: @escaping([PhotoDTO]?) -> Void) {
        AF.request("https://jsonplaceholder.typicode.com/photos").responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                guard let photosResponse = PhotoDTO.getArray(from: value) else { return }
                completion(photosResponse)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
