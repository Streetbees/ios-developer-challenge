//
//  Errors.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

enum ServiceError: Swift.Error, CustomStringConvertible {
  case networkError(message: String)
  case responseError
  case parseError
  case unkownError
  
  public var description: String {
    switch self {
    case .networkError(let message):
      return message
    case .responseError:
      return Constants.Error.APIResult
    case .parseError:
      return Constants.Error.ParseJSON
    default:
      return Constants.Error.Generic
    }
  }
}
