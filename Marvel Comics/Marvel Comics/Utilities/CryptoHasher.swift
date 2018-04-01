//
//  CryptoHasher.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation
import CryptoSwift

class CryptoHasher {
  static func createHash(_ timestamp: String, _ privateKey: String, _ publicKey: String) -> String {
    return (timestamp + privateKey + publicKey).md5()
  }
}
