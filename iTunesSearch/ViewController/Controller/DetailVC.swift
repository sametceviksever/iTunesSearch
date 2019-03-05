//
//  DetailVC.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 4.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
  
  @IBOutlet weak var imgPreview: UIImageView!
  @IBOutlet weak var img60: UIImageView!
  @IBOutlet weak var btnPlay: UIButton!
  @IBOutlet weak var lblName: UILabel!
  @IBOutlet weak var lblRelease: UILabel!
  @IBOutlet weak var lblGenre: UILabel!
  @IBOutlet weak var lblPrice: UILabel!
  @IBOutlet weak var lblDescription: UILabel!
  
  var playButtonClicked: (() -> Void)?
  var viewModel: DetailViewModel!
  
  deinit {
    print("DetailVC Deinit")
    viewModel.viewDidDestroy()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad(self)
  }
  
  @IBAction func play() {
    playButtonClicked?()
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
