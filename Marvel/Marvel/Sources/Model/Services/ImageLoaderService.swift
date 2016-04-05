import Foundation
import RxSwift
import SwiftyDropbox

enum UploadError: ErrorType {
    case Failed(String)
}

class ImageLoaderService: NSObject {
    static let service = ImageLoaderService()
    
    private override init() {
        super.init()
    }
 
    var downloadedImage = PublishSubject<Comic>()
    
    var dropboxLinked: Bool {
        if let _ = Dropbox.authorizedClient {
            return true
        }
        return false
    }
    
    func downloadComicThumbnailFromMarvel(comic: Comic) {
        MarvelAPI.api.loadComicThumbnail(comic, onSuccess: { image in
            comic.thumbnail = image
            self.downloadedImage.on(.Next(comic))
            }, onFailure: { failure in
                print("Failed to load image for comic")
        })
    }
    
    func downloadFileFromDropbox(comic: Comic) {
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
                comic.dropboxThumbnail = UIImage(data: data)
                
                self.downloadedImage.on(.Next(comic))
            }
        }
    }
    
    func uploadImageForComic(comic: Comic, image: UIImage, progress: Float -> (), completion: ErrorType? -> ()) {
        guard let id = comic.id, let client = Dropbox.authorizedClient else {
            completion(UploadError.Failed("Dropbox not linked"))
            return
        }
        
        let imageName = generateFilenameWithExtension(id)
        let fileData = UIImagePNGRepresentation(image)!
        
        client.files.upload(path: "/\(imageName)", mode: .Overwrite, autorename: false, clientModified: .None, mute: false, body: fileData)
        //client.files.upload(path: "/\(imageName)", body: fileData)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                let value = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                //self.uploadProgress.on(.Next(progress))
                progress(value)
            }
            .response { response, error in
                if let e = error {
                    completion(UploadError.Failed(e.description))
                } else {
                    completion(.None)
                }
            }
    }
    
    private func generateFilenameWithExtension(comicId: Int) -> String {
        return "\(comicId).png"
    }
    
    /*
    private func saveComicImage(image: UIImage, name: String) {
        let path = generatePathForImage(name)
        NSFileManager.defaultManager().createFileAtPath(path, contents: UIImagePNGRepresentation(image), attributes: .None)
    }
    
    private func deleteComicImage(name: String) {
        let path = generatePathForImage(name)
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            print("Failed to delete image from filesystem: \(path)")
        }
    }
    */
    
    private func generatePathForImage(name: String) -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return (documentsDirectory as NSString).stringByAppendingPathComponent(name)
    }
}
