//
//  NavController.swift
//  Marvel
//
//  Created by Ollie Stowell on 12/12/2017.
//  Copyright © 2017 Stowell. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
	//TODO: create scrolling modal view

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func backToViewController(segue: UIStoryboardSegue) {
		self.popViewController(animated: false)
	}
}

