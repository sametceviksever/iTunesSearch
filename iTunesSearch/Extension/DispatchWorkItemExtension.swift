//
//  DispatchWorkItemExtension.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation

public extension DispatchWorkItem {
  public func execute(after time: Double) {
    let time: DispatchTime = .now() + time
    DispatchQueue.main.asyncAfter(deadline: time, execute: self)
  }
}
