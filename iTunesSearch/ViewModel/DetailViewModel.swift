//
//  DetailViewModel.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 4.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit
import AVKit

class DetailViewModel: ViewModel {
  
  weak var view: DetailVC!
  var didDestroy: VoidBlock?
  var deleteItem: ((String) -> Void)?
  let media: iTunesMedia
  private let navigator: UINavigationController
  private var isDeleted: Bool = false
  
  init(_ media: iTunesMedia, navigator: UINavigationController) {
    self.media = media
    self.navigator = navigator
  }
  
  func viewDidLoad(_ view: DetailVC) {
    view.navigationItem.title = media.mediaType.name
    view.lblName.text = media.trackName
    view.lblGenre.text = media.primaryGenreName
    view.lblRelease.text = media.releaseDate
    if let price = media.priceString {
      let priceLocal = "Price".local
      view.lblPrice.text = String(format: priceLocal, price)
      view.lblPrice.isHidden = false
    } else {
      view.lblPrice.isHidden = true
    }
    
    if let desc = media.longDescription {
      view.lblDescription.text = desc
      view.lblDescription.isHidden = false
    } else {
      view.lblDescription.isHidden = true
    }
    view.btnPlay.isHidden = media.previewUrl == nil
    view.img60.setImage(with: media.artworkUrl60)
    view.imgPreview.setImage(with: media.artworkUrl100)
    let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(askForSure))
    view.navigationItem.rightBarButtonItem = deleteButton
    view.playButtonClicked = {[weak self] in
      self?.playPreview()
    }
  }
  
  func viewDidDestroy() {
    if isDeleted {
      deleteItem?(media.trackId)
    }
  }
  
  @objc private func itemDelete() {
    navigator.popViewController(animated: true)
    isDeleted = true
  }
  
  @objc private func askForSure() {
    let localMessage = "If you click yes the %@ will delete.".local
    let message = String(format: localMessage, media.trackName ?? "")
    let alertView = UIAlertController(title: "Are You Sure For Delete ?".local, message: message, preferredStyle: .alert)
    
    alertView.addAction(UIAlertAction(title: "Yes".local, style: .cancel, handler: { [weak self] (_) in
      self?.itemDelete()
    }))
    
    alertView.addAction(UIAlertAction(title: "No".local, style: .default, handler: nil))
    
    navigator.present(alertView, animated: true, completion: nil)
  }
  
  private func playPreview() {
    guard let urlString = media.previewUrl,
    let url = URL(string: urlString) else {return}
    let player = AVPlayer(url: url)
    let vcPlayer = AVPlayerViewController()
    vcPlayer.player = player
    navigator.present(vcPlayer, animated: true, completion: nil)
  }
}
