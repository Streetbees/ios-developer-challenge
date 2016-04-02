import Foundation
import Argo
import Curry

struct ComicDataContainer {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let comics: [Comic]?
}

extension ComicDataContainer: Decodable {
    static func decode(j: ArgoJSON) -> Decoded<ComicDataContainer> {
        return curry(ComicDataContainer.init)
            <^> j <|? ["data", "offset"]
            <*> j <|? ["data", "limit"]
            <*> j <|? ["data", "total"]
            <*> j <|? ["data", "count"]
            <*> j <||? ["data", "results"]
    }
}
