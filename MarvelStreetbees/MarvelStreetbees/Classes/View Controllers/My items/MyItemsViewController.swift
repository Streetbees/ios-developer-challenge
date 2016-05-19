//
//  MyItemsViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import UIKit
import SwiftyDropbox
import TSMessages
import RxSwift
import PKHUD

class MyItemsViewController: UITableViewController {
    
    internal let disposeBag = DisposeBag()
    
    var contentArray = [MarvelComic]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    internal let viewModel = MyItemsViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        
        self.title = "My Items".localized
        
        // table settings
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ComicCell", bundle: bundle)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getComics()
    }
    
    
    
    // MARK : Table View
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ComicCell else {
            return UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        let comic = contentArray[indexPath.row]
        cell.updateCellWithComic(comic)
        cell.selectionStyle = .None
        
        return cell
    }
}
