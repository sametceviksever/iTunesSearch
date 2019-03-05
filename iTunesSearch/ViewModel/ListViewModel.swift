//
//  ListViewModel.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public class ListViewModel: NSObject, ViewModel {
  
  public weak var view: ListVC!
  private weak var searchController: UISearchController!
  
  public var didDestroy: VoidBlock?
  fileprivate var selectedType: MediaType = .all
  fileprivate var searchText: String = ""
  private var medias: [iTunesMedia] = []
  private var workItem: DispatchWorkItem?
  private let navigator: UINavigationController
  
  init(_ navigator: UINavigationController) {
    self.navigator = navigator
  }
  
  public func viewDidLoad(_ view: ListVC) {
    view.collectionView.registerCell(type: ListCVC.self)
    let rightButton = createRightButton()
    searchController = createSearchController()
    NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    
    view.navigationItem.searchController = searchController
    view.navigationItem.setRightBarButton(rightButton, animated: false)
    view.collectionView.dataSource = self
    view.collectionView.delegate = self
    view.navigationItem.title = "iTunes Search".local
    view.navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  @objc private func rotated() {
    view.collectionView.reloadData()
  }
  
  public func viewDidDestroy() {
    didDestroy?()
  }
  
  private func createSearchController() -> UISearchController{
    let controller = UISearchController(searchResultsController: nil)
    controller.searchBar.delegate = self
    controller.dimsBackgroundDuringPresentation = true
    controller.hidesNavigationBarDuringPresentation = true
    controller.isActive = true
    controller.searchBar.placeholder = "Your Search Text".local
    return controller
  }
  
  private func call() {
    if searchText == "" {
      medias = []
      view.collectionView.reloadData()
      return
    }
    let request = iTunesSearchRequest(searchText: searchText, mediaType: selectedType)
    Network.shared.call(with: request) { [weak self] (response: URLResponseType<iTunesModel>) in
      if let model = response.value?.item {
        self?.medias = model.results.filter({!$0.isDeleted})
        self?.view.collectionView.reloadData()
      }
    }
  }
}

//MARK: Navigation

extension ListViewModel {
  fileprivate func createRightButton() -> UIBarButtonItem {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    button.setTitle("Media Type".local, for: .normal)
    button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
    button.setTitleColor(UIColor.blue, for: .normal)
    return UIBarButtonItem(customView: button)
  }
  
  @objc fileprivate func buttonClicked(_ sender: UIButton) {
    popover(sender)
  }
  
  private func popover(_ sender: UIButton) {
    let viewModel = MediaTypeViewModel(selectedType)
    let vc = MediaTypeVC.init(nibName: "MediaTypeVC", bundle: nil)
    vc.viewModel = viewModel
    vc.modalPresentationStyle = .popover
    let popover = vc.presentationController as! UIPopoverPresentationController
    popover.sourceView = sender
    popover.sourceRect = sender.bounds
    //    vc.preferredContentSize = CGSize(width: 150, height: 250)
    popover.permittedArrowDirections = [.up]
    popover.delegate = view
    
    viewModel.view = vc
    viewModel.okButtonPressed = {[weak self] type in
      self?.selectedType = type
      self?.call()
    }
    
    view.present(vc, animated: true, completion: nil)
  }
}

extension ListViewModel: UISearchBarDelegate {
  
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    workItem?.cancel()
    workItem = DispatchWorkItem(block: {[weak self] in
      guard let `self` = self, let _ = self.workItem
        else { return }
      self.call()
    })
    workItem?.execute(after: 0.25)
  }
  
  public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
    searchBar.text = searchText
    return true
  }
}

extension ListViewModel: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if medias.count == 0 {
      collectionView.setEmptyMessage()
    } else {
      collectionView.restore()
    }
    
    return medias.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: ListCVC = collectionView.dequeueReusableCell(forIndexPath: indexPath)
    cell.configure(with: medias[indexPath.row])
    
    return cell
  }
}

extension ListViewModel: UICollectionViewDelegateFlowLayout {
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewWidth = collectionView.bounds.width
    if UIDevice.current.userInterfaceIdiom == .pad || UIDevice.current.orientation.isLandscape {
      let size = CGSize(width: collectionViewWidth / 2, height: 80)
      return size
    }
    
    return CGSize(width: collectionViewWidth, height: 80)
  }
}

extension ListViewModel: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    CoreData.shared.saveMedia(with: medias[indexPath.row].trackId, to: .visited)
    medias[indexPath.row].isVisited = true
    collectionView.reloadItems(at: [indexPath])
    open(medias[indexPath.row])
  }
  
  private func open(_ media: iTunesMedia) {
    let viewModel = DetailViewModel(media, navigator: navigator)
    let vc = DetailVC.init(nibName: "DetailVC", bundle: nil)
    vc.viewModel = viewModel
    viewModel.view = vc
    viewModel.deleteItem = {[weak self] id in
      self?.delete(id)
    }
    navigator.pushViewController(vc, animated: true)
  }
  
  private func delete(_ mediaId: String) {
    if let index = medias.firstIndex(where: {$0.trackId == mediaId}) {
      let indexPath = IndexPath(item: index, section: 0)
      CoreData.shared.saveMedia(with: mediaId, to: .deleted)
      medias.remove(at: index)
      view.collectionView.performBatchUpdates({
        UIView.setAnimationsEnabled(false)
        self.view.collectionView?.deleteItems(at: [indexPath])
      }) { (_) in
        UIView.setAnimationsEnabled(true)
      }
    }
  }
}
