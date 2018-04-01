//
//  ErrorDisplayable.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

protocol ErrorDisplayable {
  func handleError(_ error: ServiceError)
}
