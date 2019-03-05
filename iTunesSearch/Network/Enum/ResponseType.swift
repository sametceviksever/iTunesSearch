//
//  ResponseType.swift
//  BaseProject
//
//  Created by Samet Çeviksever on 12.02.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum ResponseType<T>{
  case json(JSON)
  case decoded(T)
  
  var item: T? {
    switch self {
    case .decoded(let item):
      return item
    case .json(let dict):
      return dict as? T
    }
  }
}
