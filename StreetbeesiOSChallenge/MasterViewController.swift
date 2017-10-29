//
//  MasterViewController.swift
//  StreetbeesiOSChallenge
//
//  Created by Joe Kletz on 27/10/2017.
//  Copyright © 2017 Joe Kletz. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftHash


class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    
    var comics:[Comic] = [Comic]()
    
    var offset = 0
    
    var getComics = GetComicsNetworkService()
    
    let activity = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        getComics.delegate = self
        getComics.getComics(offset: offset)
        
        addActivityIndicator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.isFirstLaunch() {
            alert()
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "Heads up!", message: "Marvel did not provide a description or characters for some of the latest issues", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addActivityIndicator() {
        
        activity.activityIndicatorViewStyle = .gray
        view.addSubview(activity)
        view.bringSubview(toFront: activity)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: activity, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: activity, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -50)
        view.addConstraints([horizontalConstraint, verticalConstraint])
    }

    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.comics = comics
                controller.currComic = indexPath.row
                controller.offset = self.offset
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ComicMasterCell
        
        cell.selectionStyle = .none
        
        cell.coverURL = comics[indexPath.row].thumbnailURL!
        cell.titleLabel.text = comics[indexPath.row].title!
        cell.id = comics[indexPath.row].id
        
        if indexPath.row == comics.count - 5 { // last cell
            self.offset += 20
            self.getComics.getComics(offset: offset)
        }
        
        return cell
    }
}

extension MasterViewController: GetComicDelegate{
    func receivedComicData(comics: [Comic]) {
        self.comics = comics
        tableView.reloadData()
        self.activity.stopAnimating()
    }
}

class ComicMasterCell: UITableViewCell {
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var coverImage:UIImageView!
    
    var id:Int?
    
    var coverURL:String?{
        didSet{
            setImage(url: coverURL!)
        }
    }
    
    func setImage(url:String) {
        Alamofire.request(url).responseImage { response in
            
            if let image = response.result.value {
                self.coverImage.image = image
            }
        }
    }
    
}

