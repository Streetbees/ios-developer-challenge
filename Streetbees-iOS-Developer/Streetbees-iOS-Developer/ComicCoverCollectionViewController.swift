//
//  ComicCoverCollectionViewController.swift
//  StreetBees-iOS-Marvel
//
//  Created by Javid Sheikh on 22/05/2016.
//  Copyright © 2016 Javid Sheikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyDropbox

class ComicCoverCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Variables
    var comics = [Comic]()
    var comicIndex: Int!
    var fileExtArray: [String]!
    var offset: Int = 0
    var activityIndicator = UIActivityIndicatorView()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let linkToDBButton = UIBarButtonItem(title: "Unlink from Dropbox", style: .Plain, target: self, action: #selector(ComicCoverCollectionViewController.unlinkFromDB))
        self.navigationItem.leftBarButtonItem = linkToDBButton
        
        // MARK: download and parse Marvel comic JSON data.
        httpGetMarvelJSON(false)
        
        // MARK: download images from Dropbox and replace cover images where appropriate.
        if let client = Dropbox.authorizedClient {
            fileExtArray = defaults.objectForKey("SavedFileExtensions") as? [String] ?? [String]()
            print(fileExtArray)
            if fileExtArray != nil {
                for fileExt in fileExtArray {
                    let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                        let fileManager = NSFileManager.defaultManager()
                        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                        let UUID = NSUUID().UUIDString
                        let pathComponent = UUID + fileExt
                        return directoryURL.URLByAppendingPathComponent(pathComponent)
                    }
                    client.files.download(path: "/\(fileExt)", destination: destination).response { response, error in
                        if let (metadata, url) = response {
                            print("*** Download file ***")
                            print("Downloaded file name: \(metadata.name)")
                            print("Downloaded file url: \(url)")
                            let fileExtArr = fileExt.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                            let indexStr = fileExtArr.joinWithSeparator("")
                            let index = Int(indexStr)
                            print(index)
                            self.comics[index!].comicCoverImageURLString = url.absoluteString
                            self.collectionView?.reloadData()
                        } else {
                            print(error!)
                        }
                    }
                }
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // MARK: If client logged into Dropbox, log account info.
        if let client = Dropbox.authorizedClient {
            
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource methods.
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ComicCoverCollectionViewCell
        let comic = comics[indexPath.row]
        
        // Configure the cell
        let url = NSURL(string: comic.comicCoverImageURLString)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.comicCoverImageView.image = UIImage(data: data)
                })
            }
        }
        
        task.resume()
        
        return cell
    }
    
    // MARK: UICollectionView delegate methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        comicIndex = indexPath.row
        print(comicIndex)
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .Camera
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // MARK: UIScrollView delegate methods
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x + scrollView.frame.size.width == scrollView.contentSize.width) {
            print("Refreshing.")
            httpGetMarvelJSON(true)
        }
    }
    
    // MARK: UIImagePickerController delegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Unable to select chosen image.")
            return
        }
        let imageFileExtension = "superhero" + String(comicIndex) + ".jpg"
        fileExtArray.append(imageFileExtension)
        defaults.setObject(fileExtArray, forKey: "SavedFileExtensions")
        // Save image to Document directory
        guard let comicCoverData = UIImageJPEGRepresentation(chosenImage, 0.3) else {
            print("Could not convert chosenImage to NSData.")
            return
        }
        let filePath = getDocumentsDirectory().stringByAppendingPathComponent(imageFileExtension)
        comicCoverData.writeToFile(filePath, atomically: true)
        let filenameURL = NSURL(fileURLWithPath: filePath)
        let filenameURLString = filenameURL.absoluteString
        print(filenameURLString)
        self.comics[self.comicIndex].comicCoverImageURLString = filenameURLString
        self.collectionView?.reloadData()
        
        
        self.dismissViewControllerAnimated(true) {
            // MARK: Upload new photo to Dropbox
            if let client = Dropbox.authorizedClient{
                client.files.upload(path: "/\(imageFileExtension)", body: comicCoverData).response { response, error in
                    if let metadata = response {
                        print("*** Upload file ****")
                        print("Uploaded file name: \(metadata.name)")
                        print("Uploaded file revision: \(metadata.rev)")
                        
                    } else {
                        print(error!)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: HTTP GET request
    func httpGetMarvelJSON(isRefreshedData: Bool) {
        enableUI(false)
        
        if isRefreshedData {
            offset += 50
        }
        
        let dateRangeStr = Constants.MarvelParameterValues.startDate + getTodaysDateFormatted()
        let timestamp = generateTimestamp()
        let str = timestamp + Constants.Marvel.privateKey + Constants.Marvel.publicKey
        let hash = str.digest(CC_MD5_DIGEST_LENGTH, gen: {(data, len, md) in CC_MD5(data,len,md)})
        
        let URLParameters: [String: AnyObject] = [
            Constants.MarvelParameterKeys.format: Constants.MarvelParameterValues.format,
            Constants.MarvelParameterKeys.noVariants: Constants.MarvelParameterValues.noVariants,
            Constants.MarvelParameterKeys.dateRange: dateRangeStr,
            Constants.MarvelParameterKeys.orderBy: Constants.MarvelParameterValues.orderBy,
            Constants.MarvelParameterKeys.limit: Constants.MarvelParameterValues.limit,
            Constants.MarvelParameterKeys.offset: String(offset),
            Constants.MarvelParameterKeys.APIKey: Constants.Marvel.publicKey,
            Constants.MarvelParameterKeys.timestamp: generateTimestamp(),
            Constants.MarvelParameterKeys.hash: hash
        ]
        
        let URLStr = Constants.Marvel.baseURL + escapedParameters(URLParameters)
        print(URLStr)
        
        Alamofire.request(.GET, URLStr)
            .validate()
            .responseJSON { response in
                // if an error occurs, print it and re-enable the UI
                func displayError(error: String) {
                    print(error.debugDescription)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.enableUI(true)
                    })
                }
                guard response.result.isSuccess else {
                    displayError("Error while fetching tags: \(response.result.error)")
                    return
                }
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    displayError("Invalid tag information received from service")
                    return
                }
                guard let returnedData = responseJSON["data"] as? [String:AnyObject] else {
                    displayError("Could not find key 'data'.")
                    return
                }
                guard let results = returnedData["results"] as? [AnyObject] else {
                    displayError("Could not find key 'results'.")
                    return
                }
                for result in results {
                    // Title
                    guard let title = result["title"] as? String else {
                        displayError("Cannot find key 'title' in result")
                        return
                    }
                    // Image
                    guard let thumbnail = result["thumbnail"] as? [String:AnyObject] else {
                        displayError("Cannot find key 'thumbail' in result")
                        return
                    }
                    guard let path = thumbnail["path"] as? String else {
                        displayError("Cannot find key 'path' in result")
                        return
                    }
                    guard let ext = thumbnail["extension"] as? String else {
                        displayError("Cannot find key 'extension' in result")
                        return
                    }
                    let comicCoverImageURLString = path + "/portrait_uncanny." + ext
                    
                    let comic = Comic(comicTitle: title, comicCoverImageURLString: comicCoverImageURLString)
                    self.comics.append(comic)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.enableUI(true)
                    self.collectionView?.reloadData()
                    print(self.comics.count)
                })
                
        }
    }
    
    // MARK: Generate timestamp function
    private func generateTimestamp() -> String {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let timestamp = formatter.stringFromDate(currentDateTime)
        return timestamp
    }
    
    // MARK: Generate today's date in correct format for URL request
    private func getTodaysDateFormatted() -> String {
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = formatter.stringFromDate(currentDateTime)
        return todaysDate
    }
    
    // MARK: Escaped parameters
    private func escapedParameters(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                let stringValue = "\(value)"
                keyValuePairs.append(key + "=" + stringValue)
            }
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        }
    }
    
    // MARK: Get documents directory.
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: Disable UI while http request is being made.
    private func enableUI(enabled: Bool) {
        if !enabled {
            activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = .Gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }
    
    func unlinkFromDB(sender: UIBarButtonItem) {
        Dropbox.unlinkClient()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
