//
//  ViewController.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  let client = APIService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    client.requestComics(offset: 0, { (response) in
      print(response)
    }) { (error) in
      print(error)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

