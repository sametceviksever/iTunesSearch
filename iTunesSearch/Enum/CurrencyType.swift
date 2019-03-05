//
//  CurrencyType.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation

public enum CurrencyType: String {
  case usd = "USD"
  
  public init(_ currency: String) {
    guard let item = CurrencyType(rawValue: currency) else {
      self = .usd
      return
    }
    self = item
  }
  
  public var symbol: String {
    switch self {
    case .usd:
      return "$"
    }
  }
}
