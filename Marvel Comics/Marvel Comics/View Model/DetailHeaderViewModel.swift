//
//  DetailHeaderViewModel.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

protocol DetailHeaderPresentable {
  var imageURL: URL? { get }
  var title: String { get }
  var description: String? { get }
}

struct DetailHeaderViewModel: DetailHeaderPresentable {
  
  let comic: MarvelComic
  
  var imageURL: URL? {
    return comic.thumbnail.getImageURL(.standardFantastic)
  }
  
  var title: String {
    return comic.title
  }
  
  var description: String? {
    return comic.description
  }
}
