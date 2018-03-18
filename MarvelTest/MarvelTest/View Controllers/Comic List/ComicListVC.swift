//
//  ViewController.swift
//  MarvelTest
//
//  Created by Flávio Silvério on 17/03/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import UIKit

class ComicListVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = ComicListVM()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfComics
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        print(viewModel.viewModel(at: indexPath).imageURL)
        let imageView = cell.viewWithTag(101) as! UIImageView
        imageView.set(assynchronouslyFrom: viewModel.viewModel(at: indexPath).imageURL, at: indexPath.row)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.completion = {
            success, error in
            
            if success == true {
                self.collectionView.reloadData()
            }
        }
        
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 110.0, height: 170.0)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? ComicDetailsPageController,
        let index = sender as? Int else { return }
        
        destination.viewModel = self.viewModel
        destination.currentPage = index
        
    }


}

