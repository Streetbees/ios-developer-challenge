//
//  ActivityIndicatorPresenter.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import UIKit

protocol ActivityIndicatorPresenter {
  func showActivityIndicator()
  func hideActivityIndicator()
}

extension ActivityIndicatorPresenter where Self: UIViewController {
  func showActivityIndicator() {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.startAnimating()
    DispatchQueue.main.async {
      self.view.addSubview(activityIndicator)
    }
  }
  
  func hideActivityIndicator() {
    DispatchQueue.main.async {
      if let activityIndicator = self.view.subviews.flatMap({ $0 as? UIActivityIndicatorView }).first {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      }
    }
  }
}
