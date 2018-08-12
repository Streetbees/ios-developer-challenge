//
//  ComicPrice.swift
//  MarvelApp
//
//  Created by Hadi Roohian on 12/08/2018.
//  Copyright © 2018 Hadi Roohian. All rights reserved.
//

import Foundation

struct ComicPrice: Decodable {

    // (string, optional): A description of the price (e.g. print price, digital price).
    let type: String?
    // (float, optional): The price (all prices in USD).
    let price: Float?

}
