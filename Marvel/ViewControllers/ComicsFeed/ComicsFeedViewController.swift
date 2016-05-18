//
//  ComicsFeedViewController.swift
//  Marvel
//
//  Created by Gabriel Massana on 17/5/16.
//  Copyright © 2016 Gabriel Massana. All rights reserved.
//

import UIKit

import CoreDataFullStack
import PureLayout

let NavigationBarHeight: CGFloat = 64.0

class ComicsFeedViewController: UIViewController {

    //MARK: - Accessors

    /**
     Table view to display data.
     */
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView.newAutoLayoutView()
        
        return tableView
    }()
    
    /**
     Adapter to  manage the common logic and data of the tableView.
     */
    lazy var adapter: ComicsFeedAdapter = {
        
        let adapter = ComicsFeedAdapter()
        
        adapter.delegate = self
        
        return adapter
    }()
    
    //MARK: - ViewLifeCycle

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        /*-------------------*/
        
        view.addSubview(tableView)
        
        adapter.tableView = tableView
        
        /*-------------------*/
        
        adapter.paginate()
        
        /*-------------------*/
        
        updateViewConstraints()
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        /*-------------------*/
        
        tableView.autoPinEdgesToSuperviewEdges()
    }
}

extension ComicsFeedViewController : ComicsFeedAdapterDelegate {
    
    
}
