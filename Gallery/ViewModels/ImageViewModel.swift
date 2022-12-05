import Foundation
import UIKit
import Combine
import Alamofire
import AlamofireImage

// TODO add BaseViewModel
final class ImageViewModel {
    
    // TODO remove
    static let shared = ImageViewModel()
    
    // TODO refactor
    @Published var photos = [UIImage]()
    
    func getPhotos() {
        photos.removeAll()
        
        StorageService.shared.images.forEach{ fileName in
            if fileName.contains("http") {
                AF.request(fileName).responseImage(completionHandler: { (response) in
                    try? self.photos.append(response.result.get())
                })
                return
            }
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
            
            guard let savedData = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: savedData) else { return }
            photos.append(image)
        }
        
        NetworkService.shared.getImagesFromNetwork {
            $0?.forEach { element in
                AF.request(element.url).responseImage(completionHandler: { (response) in
                    try? self.photos.append(response.result.get())
                })
            }
        }
    }
    
    func downloadImage(by url: String) {
        AF.request(url).responseImage(completionHandler: { (response) in
            try? self.photos.append(response.result.get())
            StorageService.shared.images.append(url)
        })
    }
    
    private init() {
        getPhotos()
    }
}
