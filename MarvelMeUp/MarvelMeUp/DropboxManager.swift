//
//  DropboxManager.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/24/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import Foundation
import SwiftyDropbox

struct DropboxManager {

    var dropboxClient: DropboxClient?
    var connected: Bool {
        get {
            return dropboxClient != nil
        }
    }

    init() {
        dropboxClient = Dropbox.authorizedClient
    }

    func comicCoverExists(comicId: Int, completion: (Bool) -> Void) {
        if let client = dropboxClient {
            let filename = "\(comicId).jpg"
            client.users.getCurrentAccount().response { response, error in
                if let _ = response {
                    client.files.getMetadata(path: "/\(filename)").response { response, error in
                        if let metadata = response {
                            if let _ = metadata as? Files.FileMetadata {
                                completion(true)
                                return
                            }
                        }
                        completion(false)
                    }
                } else {
                    Dropbox.unlinkClient()
                    completion(false)
                }
            }
        } else {
            print("Not connected to Dropbox")
            completion(false)
        }
    }

    func loadImage(comicId: Int, thumb: Bool, completion: (NSData?, NSError?) -> Void) {
        if let client = dropboxClient {
            let filename = "\(comicId).jpg"

            let fileManager = NSFileManager.defaultManager()
            let tempFolderPath = NSTemporaryDirectory()
            do {
                try fileManager.removeItemAtPath(tempFolderPath + filename)
            } catch {
                print("Temp file not deleted: \(error)")
            }

            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                return NSURL(fileURLWithPath: tempFolderPath + filename)
            }

            client.files.download(path: "/\(filename)", destination: destination).response { response, error in
                if let (_, url) = response {
                    let imageData = NSData(contentsOfURL: url)!
                    completion(imageData, nil)
                } else if let error = error {
                    completion(nil, NSError(domain: "DropboxManagerError", code: 888, userInfo: [NSLocalizedDescriptionKey: error.description]))
                } else {
                    completion(nil, NSError(domain: "DropboxManagerError", code: 889, userInfo: [NSLocalizedDescriptionKey: "Generic Error"]))
                }
            }
        } else {
            completion(nil, NSError(domain: "DropboxManagerError", code: 890, userInfo: [NSLocalizedDescriptionKey: "Dropbox not connected"]))
        }
    }

    func deleteImage(comicId: Int, completion: ((Bool, NSError?) -> Void)) {
        if let client = dropboxClient {
            let filename = "\(comicId).jpg"
            let thumb = "\(comicId)_thumb.jpg"
            client.files.getMetadata(path: "/\(filename)").response { response, error in
                guard let _ = response as? Files.FileMetadata else { // no image file, maybe just thumb?
                    client.files.getMetadata(path: "/\(thumb)").response { response, error in
                        guard let _ = response as? Files.FileMetadata else {
                            completion(false, nil)
                            return
                        }
                        client.files.delete(path: "/\(thumb)").response { response, error in
                            completion(true, nil)
                        }
                    }
                    return
                }
                client.files.delete(path: "/\(filename)").response { response, error in
                    client.files.getMetadata(path: "/\(thumb)").response { response, error in
                        guard let _ = response as? Files.FileMetadata else {
                            completion(false, nil)
                            return
                        }
                        client.files.delete(path: "/\(thumb)").response { response, error in
                            completion(true, nil)
                        }
                    }
                }
            }
        } else {
            completion(false, NSError(domain: "DropboxManagerError", code: 890, userInfo: [NSLocalizedDescriptionKey: "Dropbox not connected"]))
        }
    }

    func saveImage(comicId: Int, image: UIImage, completion: ((Bool, NSError?) -> Void)?) {
        if let client = dropboxClient {
            let filename = "\(comicId).jpg"
            let thumb = "\(comicId)_thumb.jpg"

            deleteImage(comicId, completion: { (deleted, error) in
                let scaledImage = image.scale(toWidth: Config.imageWidth)
                let data = UIImageJPEGRepresentation(scaledImage, Config.imageQuality)!
                let scaledThumb = image.scale(toWidth: Config.thumbWidth)
                let thumbData = UIImageJPEGRepresentation(scaledThumb, Config.thumbQuality)!

                client.files.upload(path: "/\(filename)", body: data).response { response, error in
                    if let _ = response {
                        client.files.upload(path: "/\(thumb)", body: thumbData).response { response, error in
                            if let _ = response {
                                guard let completion = completion else { return }
                                completion(true, nil)
                            } else if let error = error {
                                guard let completion = completion else { return }
                                completion(false, NSError(domain: "DropboxManagerError", code: 888, userInfo: [NSLocalizedDescriptionKey: error.description]))
                            }
                        }
                    } else if let error = error {
                        guard let completion = completion else { return }
                        completion(false, NSError(domain: "DropboxManagerError", code: 888, userInfo: [NSLocalizedDescriptionKey: error.description]))
                    }
                }
            })

        } else {
            guard let completion = completion else { return }
            completion(false, NSError(domain: "DropboxManagerError", code: 890, userInfo: [NSLocalizedDescriptionKey: "Dropbox not connected"]))
        }
    }

}