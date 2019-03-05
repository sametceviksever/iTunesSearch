//
//  StringExtension.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation

public extension String {
  var local: String {
    let localized = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    if localized == "" {
      return self
    }
    
    return localized
  }
  
  public func format(from: String, to: String) -> String? {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = from
    if let date = formatter.date(from: self){
      formatter.dateFormat = to
      return formatter.string(from: date)
    }
    return nil
  }
}
