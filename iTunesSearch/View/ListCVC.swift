//
//  ListCVC.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

public class ListCVC: UICollectionViewCell, Reusable {
  
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblGenre: UILabel!
  @IBOutlet weak var lblRelease: UILabel!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var container: UIView!
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  public func configure(with model: iTunesMedia) {
    lblName.text = model.trackName
    lblGenre.text = model.primaryGenreName
    lblRelease.text = model.releaseDate
    img.setImage(with: model.artworkUrl60)
    container.backgroundColor = model.isVisited ? UIColor.init(red: 0.90, green: 0.90, blue: 0.95, alpha: 1) : .white
  }
}
