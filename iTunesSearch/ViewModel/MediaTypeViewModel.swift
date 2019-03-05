//
//  MediaTypeViewModel.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public class MediaTypeViewModel: NSObject, ViewModel {
  public typealias View = MediaTypeVC
  
  public weak var view: View!
  public var didDestroy: VoidBlock?
  public var okButtonPressed: ((MediaType) -> Void)?
  fileprivate var selectedMediaType:MediaType
  fileprivate var typeList: [MediaType] = [.movie, .music, .podcast, .all]
  
  public init(_ mediaType: MediaType) {
    self.selectedMediaType = mediaType
  }
  
  public func viewDidLoad(_ view: View) {
    view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.okButtonPressed = {[unowned self] in
      self.okButtonPressed?(self.selectedMediaType)
    }
    view.tableView.delegate = self
    view.tableView.dataSource = self
    view.tableView.hideEmptyCells()
  }
  
  public func viewDidDestroy() {
    didDestroy?()
  }
}

extension MediaTypeViewModel: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return typeList.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = typeList[indexPath.row].name
    cell.accessoryType = selectedMediaType == typeList[indexPath.row] ? .checkmark : .none
    cell.selectionStyle = .none
    return cell
  }
}

extension MediaTypeViewModel: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedMediaType = typeList[indexPath.row]
    tableView.reloadData()
  }
}
