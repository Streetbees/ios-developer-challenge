import Foundation
import Argo
import Curry

struct ComicDataWrapper {
    let code: Int?
    let status: String?
    let data: ComicDataContainer?
}

extension ComicDataWrapper: Decodable {
    static func decode(j: ArgoJSON) -> Decoded<ComicDataWrapper> {
        return curry(ComicDataWrapper.init)
            <^> j <|? "code"
            <*> j <|? "status"
            <*> j <|? "data"
    }
}

struct ComicDataContainer {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Comic]?
}

extension ComicDataContainer: Decodable {
    static func decode(j: ArgoJSON) -> Decoded<ComicDataContainer> {
        return curry(ComicDataContainer.init)
            <^> j <|? "offset"
            <*> j <|? "limit"
            <*> j <|? "total"
            <*> j <|? "count"
            <*> j <||? "results"
    }
}

struct Comic {
    let id: Int?
    let title: String?
    let thumbnailPath: String?
    let thumbnailExtension: String?
}

extension Comic: Decodable {
    static func decode(j: ArgoJSON) -> Decoded<Comic> {
        return curry(Comic.init)
            <^> j <|? "id"
            <*> j <|? "title"
            <*> j <|? ["thumbnail", "path"]
            <*> j <|? ["thumbnail", "extension"]
    }
}
