//
//  ViewController.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 29/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {

    static let reuseIdentifier: String = "comicDetailCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var comic: Comic?
    
    private var comicInfoArray: [(title: String, subtitle: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicInfoArray = buildComidInfoArray()
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let comicUrlString = comic?.thumbnail.buildString(size: .portrait_uncanny) {
            headerImage.download(image: comicUrlString)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildComidInfoArray() -> [(title: String, subtitle: String)] {
        var array: [(title: String, subtitle: String)] = []
        
        guard let comic = self.comic else {
            return array
        }
        
        array.append( (title: "Title", subtitle: comic.title) )
        array.append( (title: "Format", subtitle: comic.format) )
        array.append( (title: "Number of Pages", subtitle: String(comic.pageCount)) )
        array.append( (title: "Description", subtitle: comic.description ?? "No description Avaiable") )
        
        return array
    }
}

extension ComicDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ComicDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: ComicDetailViewController.reuseIdentifier) as! ComicDetailTableViewCell
        
        let info = comicInfoArray[indexPath.row]
        
        cell.textLabel?.text = info.title

        if let attributedString = try? NSAttributedString(data: Data(info.subtitle.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            cell.detailTextLabel?.text = attributedString.string
        } else {
            cell.detailTextLabel?.text = info.subtitle
        }
        
        return cell
    }
}
