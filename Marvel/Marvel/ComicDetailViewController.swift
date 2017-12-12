//
//  ComicDetailViewController.swift
//  Marvel
//
//  Created by Ollie Stowell on 12/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {
	@IBOutlet var navigationBar: UINavigationBar!
	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var descriptionTextView: UITextView!
	
	var comic: ComicObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let comic = self.comic else  {
			self.dismiss(animated: true,
						 completion: nil)
			return
		}
		
		self.title = ""
		
		if comic.portraitData != nil {
			self.backgroundImageView.image = UIImage(data: comic.portraitData!)
		} else if comic.thumbnailData != nil {
			self.backgroundImageView.image = UIImage(data: comic.thumbnailData!)
		} else {
			self.backgroundImageView.image = #imageLiteral(resourceName: "placeholder")
		}
		self.titleLabel.text = comic.title
		//TODO: clean some of the HTML from descriptions
		self.descriptionTextView.text = comic.comicDesc
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
