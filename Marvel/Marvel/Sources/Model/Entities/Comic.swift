import Foundation
import Argo
import Curry

struct Comic {
    let id: Int?
    let title: String?
    let description: String?
    let modified: NSDate?
    let thumbnailPath: String?
    let thumbnailExtension: String?
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
