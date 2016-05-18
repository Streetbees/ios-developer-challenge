//
//  ComicsListViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 Parhelion Software. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Infinity
import Refresher

let pageSize = 20

class ComicsListViewController: UITableViewController {
    let thinking = PublishSubject<HUDState>()
    let eventsSubject = PublishSubject<[MarvelComic]?>()
    let disposeBag = DisposeBag()
    
    var viewModel = ComicsListViewModel()
    
    var currentPage = 0
    
    var contentArray: [MarvelComic]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        setupBindings()
        viewModel.makeTheCall(pageSize: pageSize, page: currentPage, showLoading: true)
        
        let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.loadMoreData()
        })
    }
    
    func loadMoreData() {
        currentPage = currentPage + 1
        viewModel.makeTheCall(pageSize: pageSize, page: currentPage, showLoading: false)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let contentArray = contentArray {
            return contentArray.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? ComicCell else {
            return UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        if let contentArray = self.contentArray where contentArray.count > 0 {
            let comic = contentArray[indexPath.row]
            cell.updateCellWithComic(comic)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ComicDetail",
            let comicDetailVC = segue.destinationViewController as? ComicDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow,
            let contentArray = contentArray {
                comicDetailVC.viewModel.comic = contentArray[indexPath.row]
        }
    }
    
}