//
//  ConfigProvider.swift
//  Marvel Comics
//
//  Created by Rafi on 01/04/2018.
//  Copyright © 2018 Rafi. All rights reserved.
//

import Foundation

struct ConfigProvider {
  static func getAPIKeys() -> [String: String]? {
    if let path = Bundle.main.path(forResource: "AppConfig", ofType: "plist"), let keys = NSDictionary(contentsOfFile: path) as? [String: String] {
      return ["publicKey": keys["MarvelPublicKey"]!, "privateKey": keys["MarvelPrivateKey"]!]
    }
    return nil
  }
}
