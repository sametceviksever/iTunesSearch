//
//  CollectionViewExtension.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  //Identifier class Name ile Aynı verilmesi gerekmektedir.
  func registerCell<T: UICollectionViewCell>(type: T.Type) where T: Reusable {
    self.register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UICollectionViewCell> (forIndexPath indexPath: IndexPath) -> T where T: Reusable {
    return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
  }
}
