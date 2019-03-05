//
//  ListVC.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public class ListVC: UIViewController {
  
  var viewModel: ListViewModel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  deinit {
    print("ListVC Deinit")
    viewModel.didDestroy?()
  }
  override public func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad(self)
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

extension ListVC: UIPopoverPresentationControllerDelegate {
  public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}
