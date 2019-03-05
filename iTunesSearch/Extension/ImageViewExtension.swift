//
//  ImageViewExtension.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit
import Kingfisher

public extension UIImageView {
  public func setImage(with url: URL?, placeHolder: UIImage? = nil) {
    kf.setImage(with: url, placeholder: placeHolder)
  }
  
  public func setImage(with urlString: String?, placeHolder: UIImage? = nil) {
    guard let urlString = urlString else {return}
    setImage(with: URL(string: urlString), placeHolder: placeHolder)
  }
}
