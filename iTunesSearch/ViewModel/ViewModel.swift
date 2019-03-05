//
//  ViewModel.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public typealias VoidBlock = (() -> Void)

public protocol ViewModel: class {
  associatedtype View: UIViewController
  weak var view: View! {get set}
  var didDestroy: VoidBlock? {get set}
  
  func viewDidLoad(_ view: View)
  func viewDidDestroy()
}
