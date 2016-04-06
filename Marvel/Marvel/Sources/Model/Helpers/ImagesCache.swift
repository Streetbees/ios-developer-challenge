import Foundation
import NSCacheSwift

private let countLimit = 30

class ImagesCache {
    static let instance = ImagesCache()

    let marvelCache: NSCacheSwift<Int, UIImage>
    let dropboxCache: NSCacheSwift<Int, UIImage>
    
    private init() {
        self.marvelCache = NSCacheSwift<Int, UIImage>()
        self.marvelCache.countLimit = countLimit
        
        self.dropboxCache = NSCacheSwift<Int, UIImage>()
        self.dropboxCache.countLimit = countLimit
    }
}
