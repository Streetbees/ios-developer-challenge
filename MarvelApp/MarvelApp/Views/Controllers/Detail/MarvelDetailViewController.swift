//
//  MarvelDetailViewController.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import UIKit

class MarvelDetailViewController: UIViewController {
    
    var comic : Comic?
    var viewModel: MarvelDetailViewModelProtocol?
    
    @IBOutlet weak var backgroundCoverImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiating view model by passing self as a delegate and comic model to view model
        if (viewModel == nil) {
            viewModel = MarvelDetailViewModel(setView: self, comicModel: comic)
        }
        
        // Asking view model to perform initial setup on view
        viewModel?.performInitialSetup()
    }

}


extension MarvelDetailViewController: MarvelDetailViewControllerProtocol {
    
    // Load comic cover image with returned image url
    func loadBackroundImage(withImageUrl url: URL) {
        
        // Start animating image loading indicator while we're downloading cover image
        loadingActivityIndicator.startAnimating()
        
        //Fetch and assign cover image to background image from server
        backgroundCoverImageView.sd_setImage(with: url) { (_, _, _, _) in
            
            // Stop image loading indicator animation when image's downloaded
            self.loadingActivityIndicator.stopAnimating()
        }
    }
    
    // Setting navigation title with returned title string from view model
    func setNavigationTitle(withTitle title: String) {
        navigationItem.title = title
    }
    
    // Scheduling to display description view on the cover image with 1.5s delay
    func addDescriptionViewWithAnimation() {
        perform(#selector(animateDescriptionView), with: nil, afterDelay: 1.5)
    }
    
    // Setting caption label in description view with returned description string from view model
    func updateCaptionLabel(withDescription description: String) {
        descriptionLabel.text = description
    }
    
    // Animating description view to the scene with changing the layout constraint constant
    @objc func animateDescriptionView() {
        
        self.descriptionViewTopConstraint.constant = -(view.frame.size.height * 0.35)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseOut,
                       animations: {
                        
                        // Forcing view to upadate the layout
                        self.view.layoutIfNeeded()
                        
        })
        
    }
    
}
