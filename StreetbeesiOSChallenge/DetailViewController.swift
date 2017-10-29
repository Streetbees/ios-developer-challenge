//
//  DetailViewController.swift
//  StreetbeesiOSChallenge
//
//  Created by Joe Kletz on 27/10/2017.
//  Copyright © 2017 Joe Kletz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHash

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var charactersLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    var comics:[Comic] = [Comic]()
    
    var currComic = 0
    
    var getComics = GetComicsNetworkService()
    
    var offset = 0
    
    func setImage(url:String) {
        Alamofire.request(url).responseImage { response in
            
            if let image = response.result.value {
                self.coverImage.image = image
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getComics.delegate = self
        getComics.comics = self.comics
        
        loadComic()
        
        swipeGestures()
    }
    
    func swipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func createCharacterList(characters:[String]) -> String {
        
        var characterString = ""
        
        characterString = characters.joined(separator: ", ")

        return characterString
    }
    
    var detailItem: NSDate? {
        didSet {
            // Update the view.
            //configureView()
        }
    }
    
    @objc func swipedRight() {

        if currComic > 0 {
            clearCurrent()
            currComic -= 1
            loadComic()
        }
    }
    @objc func swipedLeft() {
        
        clearCurrent()

        if currComic < comics.count - 1 {
            currComic += 1
            loadComic()
        }else{
            if !getComics.loading{
                self.offset += 20
                getComics.getComics(offset: self.offset)
            }
        }
        
    }
    
    func clearCurrent() {
        coverImage.image = nil
        titleLabel.text = "Loading..."
        descriptionLabel.text = nil
        charactersLabel.text = nil
    }
    
    func loadComic() {
        descriptionLabel.text = String(describing: comics[currComic].id)
        setImage(url: comics[currComic].coverURL!)
        descriptionLabel.text = comics[currComic].description!
        titleLabel.text = comics[currComic].title!
        charactersLabel.text = createCharacterList(characters: comics[currComic].characters)
    }
    
}

extension DetailViewController:GetComicDelegate{
    func receivedComicData(comics: [Comic]) {
        self.comics = comics
        swipedLeft()
    }
    
}

