//
//  APIServiceRequestable.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

protocol APIServiceRequestable {
  func requestComics(offset: Int, _ completion: @escaping ComicsResultSuccess, _ failure: @escaping ServiceFailure)
  func requestCharacters(comicId: Int, _ completion: @escaping CharacterResultSuccess, _ failure: @escaping ServiceFailure)
}
