//
//  ComicDetailsPageController.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 18/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit

class ComicDetailsPageController: UIViewController, UIPageViewControllerDataSource {

    var currentPage : Int = 0
    var pageViewController : UIPageViewController?
    
    var viewModel : ComicListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageViewController = (self.storyboard!.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController)
        pageViewController!.dataSource = self;
        
        let viewControllers = [self.loadViewControllerAtIndex(index: currentPage)]
        pageViewController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)

        // Change the size of page view controller
        pageViewController!.view.frame = self.view.frame
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
        self.edgesForExtendedLayout = []
    }


    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentPage < viewModel.numberOfComics - 1 {
            
            currentPage += 1
            return loadViewControllerAtIndex(index: currentPage)
            
        } else {
            
            return nil
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentPage > 0 {
            
            currentPage -= 1
            return loadViewControllerAtIndex(index: currentPage)
            
        } else {
            
            return nil
            
        }
        
    }
    
    func loadViewControllerAtIndex(index: Int) -> UIViewController{
        
        guard let vc = self.storyboard!.instantiateViewController(withIdentifier: "ComicDetailsVC") as? ComicDetailsVC else { return UIViewController() }

        vc.viewModel = viewModel.viewModel(at: IndexPath(item: index, section: 0))
        
        return vc
        
    }
    
    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
