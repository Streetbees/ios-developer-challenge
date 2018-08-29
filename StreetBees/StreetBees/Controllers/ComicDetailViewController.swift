//
//  ComicDetailViewController.swift
//  StreetBees
//
//  Created by Richard Willis on 29/08/2018.
//  Copyright © 2018 Rich Text Format Ltd. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var dismissButton: UIButton!
	
	var image: UIImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		dismissButton.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
	}
	
	@objc func onTouchUpInside() {
		dismiss(animated: true)
	}
}
