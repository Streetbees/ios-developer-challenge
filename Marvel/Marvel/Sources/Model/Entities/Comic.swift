import Foundation
import Argo
import Curry

class Comic {
    let id: Int?
    let title: String?
    let description: String?
    let modified: NSDate?
    let thumbnailPath: String?
    let thumbnailExtension: String?
    var thumbnail: UIImage?
    
    init(id: Int?, title: String?, description: String?, modified: NSDate?, thumbnailPath: String?, thumbnailExtension: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.modified = modified
        self.thumbnailPath = thumbnailPath
        self.thumbnailExtension = thumbnailExtension
    }
}

extension Comic: Decodable {
    static func decode(j: ArgoJSON) -> Decoded<Comic> {
        return curry(Comic.init)
            <^> j <|? "id"
            <*> j <|? "title"
            <*> j <|? "description"
            <*> j <|? "modified"
            <*> j <|? ["thumbnail", "path"]
            <*> j <|? ["thumbnail", "extension"]
    }
}

extension Comic: Equatable {}

func ==(lhs: Comic, rhs: Comic) -> Bool {
    return lhs.id == rhs.id
}


