import Foundation

struct PhotoDTO {
    var id: Int
    var title: String
    var url: String
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let url = json["url"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.url = url
    }
    
    static func getArray(from jsonArray: Any) -> [PhotoDTO]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        return Array(jsonArray.compactMap { PhotoDTO(json: $0) }[0..<15])
    }
}
