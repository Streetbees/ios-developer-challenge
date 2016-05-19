//
//  ComicsListViewController.swift
//  MarvelStreetbees
//
//  Created by Danut Pralea on 18/05/16.
//  Copyright © 2016 MarvelStreetbees. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Infinity

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
        self.title = "Comics".localized
        self.edgesForExtendedLayout = .None
        setupBindings()
        viewModel.makeTheCall(pageSize: pageSize, page: currentPage, showLoading: true)
        
        let animator = DefaultInfiniteAnimator(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        tableView.addInfiniteScroll(animator: animator, action: { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.loadMoreData()
        })
        
        let bundle = NSBundle.mainBundle()
        let nib = UINib(nibName: "ComicCell", bundle: bundle)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    }
    
    func loadMoreData() {
        currentPage = currentPage + 1
        viewModel.makeTheCall(pageSize: pageSize, page: currentPage, showLoading: false)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
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
        if let comicDetailsController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("ComicDetailViewController") as? ComicDetailViewController,
            let contentArray = contentArray {
            comicDetailsController.viewModel.comic = contentArray[indexPath.row]
            self.navigationController?.pushViewController(comicDetailsController, animated: true)
        }
    }
}