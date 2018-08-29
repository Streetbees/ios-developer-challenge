//
//  RealmRepresentable.swift
//  MarvelApp
//
//  Created by Rodrigo Cardoso on 25/08/2018.
//  Copyright © 2018 Rodrigo Cardoso. All rights reserved.
//

import Foundation

protocol RealmRepresentable {
    
    associatedtype RealmType: DomainConvertibleType
    
    var _primaryKey: String { get }
    
    func asRealm() -> RealmType
}
