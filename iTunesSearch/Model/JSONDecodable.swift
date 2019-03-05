//
//  JSONDecodable.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 4.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol JSONDecodable {
  init(with json: JSON)
}

public protocol JSONCollectionDecodable: JSONDecodable {}

public extension JSONCollectionDecodable {
  static func getCollection(with array: [JSON]) -> [Self] {
    var items: [Self] = []
    for json in array {
      items.append(Self(with: json))
    }
    
    return items
  }
}
