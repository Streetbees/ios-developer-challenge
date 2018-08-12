//
//  MarvelCollectionViewController.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MarvelCell"
private let detailControllerIdentifier = "MarvelDetailViewController"

class MarvelCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var screenLoadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    
    // Referrence to parallel ViewModel object
    var viewModel: MarvelCollectionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.viewModel == nil) {
            
            // Instantiate ViewModel object and set current view as a delegate for ViewModel object
            self.viewModel = MarvelCollectionViewModel(setView: self, screenTitle: "Comics")
        }
        
        // Call performInitialSetup() on parallel ViewModel object
        self.viewModel?.performInitialSetup()
        
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // Unwrapping viewModel object and ask for number of sections.
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Unwrapping viewModel object and ask for number of items we need to display for each section.
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfItemsInSection(forSection: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Obtain a dequeued cell with for specified reuse identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Unrapping viewModel object
        guard let viewModel = viewModel,
        // Checking if obtained cell is an actual MarvelCell
        let marvelCell = cell as? MarvelCollectionViewCell,
        // Getting a cell view model for the current cell
        let marvelCellViewModel = viewModel.cellViewModelForItemAtIndexPath(forIndexPath: indexPath)
            else { return cell }
        
        // Assigning cellViewModel object to viewModel property of MarvelCell
        marvelCell.viewModel = marvelCellViewModel
        
        // Assigning MarvelCell as a delegation for cellViewModel
        marvelCellViewModel.setView(view: marvelCell)
        
        // Configure cell by calling setup method
        marvelCell.setup()
    
        return marvelCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Unwrapping viewModel object and ask for current cell size.
        guard let viewModel = viewModel else { return CGSize.zero }
        return viewModel.sizeForItemAtIndex(forIndexPath: indexPath, withContentSize: collectionView.contentSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        // Unwrapping viewModel object and ask for minimum interitem spacing of current section
        guard let viewModel = viewModel else { return 0.0 }
        return viewModel.minimumInteritemSpacing(forSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        // Unwrapping viewModel object and ask for minimum line spacing of current section
        guard let viewModel = viewModel else { return 0.0 }
        return viewModel.minimumLineSpacing(forSection: section)
    }

    @IBAction func onRetryButtonTap(_ sender: Any) {
        
        // Sending retry button tap message to retryButtonTap of viewModel object
        viewModel?.retryButtonTapped(sender: sender)
    }
    
    @IBAction func onRetryBarButtonTap(_ sender: Any) {
        
        // Clearing all the data from the data source
        viewModel?.comicDataWrapper = nil
        
        // Reloading cells to delete them all while data source is empty
        collectionView?.reloadData()
        
        // Sending retry button tap message to retryButtonTap of viewModel object
        viewModel?.retryButtonTapped(sender: sender)
        
    }
    
}

extension MarvelCollectionViewController: MarvelCollectionViewControllerProtocol {

    // Setting navigation title from viewModel object
    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }
    
    // Setting collectionView config from viewModel object
    func setupCollectionView(contentInset: UIEdgeInsets) {
        
        // Start animating the loading indicator while we're setting up the collectionView and getting items back
        screenLoadingActivityIndicator.startAnimating()
        
        // Unwrapping viewModel and collection view flow layout
        guard let viewModel = viewModel, let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        // Setting the collection view direction layout with returned direction value from viewModel
        layout.scrollDirection = viewModel.collectionViewScrollDirection()
        
        // Setting the collection view content inset with returned content inset value from viewModel
        collectionView?.contentInset = contentInset
    }
    
    // Update collection view when data source has been updated and is ready to display items
    func updateComicsInCollectionView() {
        
        collectionView?.reloadData()
        screenLoadingActivityIndicator.stopAnimating()
    }
    
    // Display an error view with parameters coming back from viewModel
    func updateView(withErrorTitle errorTitle: String, errorDescription: String) {
        
        // Stop animating the loading indicator
        screenLoadingActivityIndicator.stopAnimating()
        
        // Update error title and description labels with returned texts from viewModel
        errorTitleLabel.text = errorTitle
        errorDescriptionLabel.text = errorDescription
        
        // Display the error view with animation
        UIView.animate(withDuration: 0.6) {
            self.emptyView.alpha = 1
        }
    }
    
    // Try again to load items when we had an error previously
    func updatingViewForBetterUserExprienceWhileLoadingComics() {
        
        // Empty error labels
        errorTitleLabel.text = ""
        errorDescriptionLabel.text = ""
        
        // Start animating loading indicator while we're trying to fetch items again
        screenLoadingActivityIndicator.startAnimating()
        
        // Hiding error view from screen while we're trying to fetch items from the API
        UIView.animate(withDuration: 0.6) {
            self.emptyView.alpha = 0
        }
    }
    
    
}


// MARK:- UICollectionViewDelegate
extension MarvelCollectionViewController {
    
    // Make sure that item selection is available
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handling items selection in collection view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Obtaining detail controller from current storyboard with specified identifier,
        guard let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: detailControllerIdentifier) as? MarvelDetailViewController,
        // Unrapping viewModel object
        let viewModel = viewModel else { return }
        
        // Passing selected comic view model to detail controller
        detailViewController.comic = viewModel.model(forIndexPath: indexPath)
        
        // Displaying detail controller
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
