//
//  MediaTypeVC.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public class MediaTypeVC: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var viewModel: MediaTypeViewModel!
  var okButtonPressed: VoidBlock?
  
  deinit {
    print("MediaTypeVC Deinit")
    viewModel.viewDidDestroy()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad(self)
    tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
  }
  
  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
    var size = tableView.contentSize
    size.height += 45
    size.width = 150
    preferredContentSize = size
  }
  
  @IBAction func buttonPressed() {
    okButtonPressed?()
    dismiss(animated: true, completion: nil)
  }
}
