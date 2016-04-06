import Foundation
import NSCacheSwift

class ImagesCache {
    static let instance = ImagesCache()

    let marvelCache: NSCacheSwift<Int, UIImage>
    let dropboxCache: NSCacheSwift<Int, UIImage>
    
    private init() {
        self.marvelCache = NSCacheSwift<Int, UIImage>()
        self.dropboxCache = NSCacheSwift<Int, UIImage>()
    }
}
