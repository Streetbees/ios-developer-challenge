import Foundation
import RxSwift
import SwiftyDropbox

enum DropboxError: ErrorType {
    case GeneralError(String)
}

class ImageLoaderService: NSObject {
    static let service = ImageLoaderService()
    
    private override init() {
        super.init()
    }
 
    var dropboxLinked: Bool {
        if let _ = Dropbox.authorizedClient {
            return true
        }
        return false
    }
    
    func downloadComicThumbnailFromDropbox(comic: Comic, completion: UIImage? -> ()) {
        guard let id = comic.id, let client = Dropbox.authorizedClient else {
            return
        }
        
        let imageName = generateFilenameWithExtension(id)
        
        func destination(temporaryURL: NSURL, response: NSHTTPURLResponse) -> NSURL {
            let path = generatePathForImage(imageName)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch {}
            
            return NSURL(fileURLWithPath: path)
        }
        
        client.files.download(path: "/\(imageName)", destination: destination).response { response, error in
            if let (_, url) = response {
                let data = NSData(contentsOfURL: url)!
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(.None)
            }
        }
    }
    
    func uploadImageForComic(comic: Comic, image: UIImage, progress: Float -> (), completion: DropboxError? -> ()) {
        guard let id = comic.id, let client = Dropbox.authorizedClient else {
            completion(DropboxError.GeneralError("Dropbox not linked"))
            return
        }
        
        let imageName = generateFilenameWithExtension(id)
        let fileData = UIImagePNGRepresentation(image)!
        
        client.files.upload(path: "/\(imageName)", mode: .Overwrite, autorename: false, clientModified: .None, mute: false, body: fileData)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                let value = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                progress(value)
            }
            .response { response, error in
                if let e = error {
                    completion(DropboxError.GeneralError(e.description))
                } else {
                    completion(.None)
                }
            }
    }
    
    func deleteImageForComic(comic: Comic, completion: DropboxError? -> ()) {
        guard let id = comic.id, let client = Dropbox.authorizedClient else {
            completion(DropboxError.GeneralError("Dropbox not linked"))
            return
        }
        
        let imageName = generateFilenameWithExtension(id)
        
        client.files.delete(path: "/\(imageName)").response { response, error in
            if let e = error {
                completion(DropboxError.GeneralError(e.description))
            } else {
                completion(.None)
            }
        }
    }
    
    private func generateFilenameWithExtension(comicId: Int) -> String {
        return "\(comicId).png"
    }
    
    private func generatePathForImage(name: String) -> String {
        return (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(name)
    }
}
