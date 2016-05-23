//
//  LinkToDBViewController.swift
//  Streetbees-iOS-Developer
//
//  Created by Javid Sheikh on 23/05/2016.
//  Copyright © 2016 Javid Sheikh. All rights reserved.
//

import UIKit
import SwiftyDropbox

class LinkToDBViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if (Dropbox.authorizedClient) != nil {
            self.performSegueWithIdentifier("segueToCollectionVC", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func linkToDB(sender: UIButton) {
        Dropbox.authorizeFromController(self)
        self.performSegueWithIdentifier("segueToCollectionVC", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
