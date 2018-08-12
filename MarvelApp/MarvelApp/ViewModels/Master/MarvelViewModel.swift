//
//  MarvelCollectionViewModel.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation
import UIKit

class MarvelCollectionViewModel: NSObject {
    
    var view : MarvelCollectionViewControllerProtocol?
    var comicDataWrapper: ComicDataWrapper?
    var screenTitle: String
    var dataService: DataService!
    
    init(setView view: MarvelCollectionViewControllerProtocol?, screenTitle: String) {
        
        // Assigning view referrence in view model's view property
        if let view = view { self.view = view }
        
        // Assigning screen title referrence in view model's screenTitle property
        self.screenTitle = screenTitle
        
        super.init()

        // Setting up dataService, passing view model as a delegation to that
        dataService = DataService(delegate: self)
        
        // Requestion data service to start fetching data from API
        dataService.fetchComicsFromAPI()
    }
    
}


//MARK:- Data Service Delegation Methods
extension MarvelCollectionViewModel: MarvelDataServiceDelegate {
    
    // If dataService returned data successfully:
    func didSucceedToFetchComics(withComicDataWrapper comicDataWrapper: ComicDataWrapper) {
        
        // Assigning returned comicDataWrapper object to a local property
        self.comicDataWrapper = comicDataWrapper
        
        // Unwrapping the view and sending a request to update items
        if let view = view {
            view.updateComicsInCollectionView()
        }
    }
    
    // If dataService returned with error:
    func didFailToFetchComics(withError error: Error) {
        
        // Creating an error title and description based on returned error
        let errorTitle = "Loading Failed"
        let errorDescription = error.localizedDescription
        
        // Unwrapping the view and sending a request to display the error view with constructed error
        guard let view = view else { return }
        view.updateView(withErrorTitle: errorTitle, errorDescription: errorDescription)
    }
    
    
}

extension MarvelCollectionViewModel: MarvelCollectionViewModelProtocol {
    
    // Performing inital setup on view
    func performInitialSetup() {
        
        guard let view = view else { return }

        // Creating a contentInset for view's collectionView
        let contentInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        // Setting up collection view with specified content inset
        view.setupCollectionView(contentInset: contentInset)
        
        // Setting up view's navigation title with specified screen title
        view.setNavigationTitle(title: screenTitle)
    }

    // Providing number of sections for view's collectionView
    func numberOfSections() -> Int {
        return 1
    }

    // Providing number of items for each section
    func numberOfItemsInSection(forSection section: Int) -> Int {
        
        // Unwrapping comicDataWrapper and it's descendants to get number of comics available to display
        guard let comicDataWrapper = comicDataWrapper,
        let data = comicDataWrapper.data,
        let results = data.results else {
            return 0
        }
        
        // Returning results count (number of comics in returned data object)
        return results.count
    }

    
    // Creating cell view model with comic model on the specified index path
    func cellViewModelForItemAtIndexPath(forIndexPath indexPath: IndexPath) -> MarvelCellViewModel? {
        
        guard let comicDataWrapper = comicDataWrapper,
            let data = comicDataWrapper.data,
            let results = data.results,
            let comic = results[indexPath.row] else {
                return nil
            }
        return MarvelCellViewModel(withComicModel: comic)
    }

    
    // Returning size of each item for collection view based on the received content size
    func sizeForItemAtIndex(forIndexPath indexPath: IndexPath, withContentSize contentSize: CGSize) -> CGSize {
        
        // Implementing adoptive layout based on device screen size
        let screenSize = UIDevice.current.screenSize
        
        var adoptiveHeight: CGFloat
        
        // Display 4 items in each column on "Large" screen sizes
        // "iPhone X, iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        if screenSize == .Large {
            adoptiveHeight = ((contentSize.height - 20) / 4)
        }
        
        // Display 3 items in each column on "Regular" screen sizes
        // "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        else if screenSize == .Regular {
            adoptiveHeight = ((contentSize.height - 16) / 3)
        }
        
        // Display 2 items in each column on "Small" screen sizes
        // "iPhone 4 or iPhone 4S, iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        else if screenSize == .Small {
            adoptiveHeight = ((contentSize.height - 12) / 2)
        }
        
        // Display 1 item in each column on "Unknown" screen sizes
        else {
            adoptiveHeight = (contentSize.height - 8)
        }

        // Calculating with based on the adoptive height
        let adoptiveWidth = adoptiveHeight * 0.7
        return CGSize(width: adoptiveWidth, height: adoptiveHeight)
    }
    
    // Providing minimum interim spacing between cells
    func minimumInteritemSpacing(forSection section: Int) -> CGFloat {
        return 4
    }
    
    // Providing minimum line spacing for each section
    func minimumLineSpacing(forSection section: Int) -> CGFloat {
        return 10
    }

    // Providing Comic model for specified indexPath
    func model(forIndexPath indexPath: IndexPath) -> Comic? {
        guard let comicDataWrapper = comicDataWrapper,
            let data = comicDataWrapper.data,
            let results = data.results,
            let comic = results[indexPath.row] else {
                return nil
        }
        return comic
    }
    
    // Providing collection view scrolling direction
    func collectionViewScrollDirection() -> UICollectionViewScrollDirection {
        return UICollectionViewScrollDirection.horizontal
    }
    
    // Performing tasks on retry button taps
    func retryButtonTapped(sender: Any) {
        
        // Unwrapping view and requesting to 
        guard let view = view else { return }
        
        // Letting user know that we're trying again to fetch comics by adding a loading indicator on screen
        view.updatingViewForBetterUserExprienceWhileLoadingComics()
        
        // Requesting dataService to try and fetch comics from API
        dataService.fetchComicsFromAPI()
    }
    
    
    
}
