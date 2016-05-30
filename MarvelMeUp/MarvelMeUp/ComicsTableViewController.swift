//
//  ComicsTableViewController.swift
//  MarvelMeUp
//
//  Created by Dimitar Chakarov on 5/23/16.
//  Copyright © 2016 JI Apps Ltd. All rights reserved.
//

import UIKit
import SwiftyDropbox

protocol CoverUpdateDelegate {
    func coverDidUpdate()
}

class ComicsTableViewController: UITableViewController, CoverUpdateDelegate {

    var comics: [Comic] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var dropboxManager = DropboxManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadComics()
    }

    func loadComics() {
        SwiftSpinner.show("Loading")
        APIClient.sharedInstance.fetchComics { [unowned self] (inner) in
            defer {
                SwiftSpinner.hide()
            }
            do {
                let (totalCount, comicsData) = try inner()
                for comicDict in comicsData {
                    if let comic = Comic(fromDict: comicDict) {
                        self.comics.append(comic)
                    }
                }
            } catch let error as NSError {
                self.showError(error.localizedDescription)
            }
        }
    }

    func showError(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: "Retry", style: .Cancel) { (_) in
            self.loadComics()
        }
        alertController.addAction(retryAction)
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true) {}
        })
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComicsTableViewController.coverDidUpdate), name: "CoverSaved", object: nil)
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func coverDidUpdate() {
        if !dropboxManager.connected {
            dropboxManager = DropboxManager()
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("comicCell", forIndexPath: indexPath) as! ComicTableViewCell
        var comic = comics[indexPath.row]
        cell.titleLabel.text = comic.title
        cell.imageUrl = comic.thumbnailURL
        cell.cellImageView?.alpha = 0

        if (comic.replaced == nil || comic.replaced! == true) && dropboxManager.connected {
            dropboxManager.comicCoverExists(comic.id) { replaced in
                if replaced {
                    self.dropboxManager.loadImage(comic.id, thumb: true) { imageData, error in
                        if let imageData = imageData where cell.imageUrl == comic.thumbnailURL {
                            comic.replaced = true
                            cell.cellImageView.image = UIImage(data: imageData)
                            UIView.animateWithDuration(0.3) {
                                cell.cellImageView.alpha = 1
                            }
                        } else {
                            print(error?.localizedDescription)
                        }
                    }
                } else {
                    comic.replaced = false
                    if let image = comic.thumbnailURL.cachedImage {
                        cell.cellImageView?.image = image
                        cell.cellImageView?.alpha = 1
                    } else {
                        comic.thumbnailURL.fetchImage { image in
                            if cell.imageUrl == comic.thumbnailURL {
                                cell.cellImageView.image = image
                                UIView.animateWithDuration(0.3) {
                                    cell.cellImageView.alpha = 1
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if let image = comic.thumbnailURL.cachedImage {
                cell.cellImageView?.image = image
                cell.cellImageView?.alpha = 1
            } else {
                comic.thumbnailURL.fetchImage { image in
                    if cell.imageUrl == comic.thumbnailURL {
                        cell.cellImageView.image = image
                        UIView.animateWithDuration(0.3) {
                            cell.cellImageView.alpha = 1
                        }
                    }
                }
            }
        }


        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowComic", sender: self)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowComic" {
            let dest = segue.destinationViewController as! ComicViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let comic = comics[indexPath.row]
            dest.comic = comic
            dest.title = comic.title
            dest.delegate = self
        }
    }

}
