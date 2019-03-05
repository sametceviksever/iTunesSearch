//
//  iTunesModel.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct iTunesModel: JSONDecodable {
  let resultCount: Int
  var results: [iTunesMedia]
  
  public init(with json: JSON) {
    resultCount = json["resultCount"].intValue
    results = iTunesMedia.getCollection(with: json["results"].arrayValue)
  }
}

public struct iTunesMedia: JSONCollectionDecodable {
  let previewUrl: String?
  let artworkUrl60: String?
  let artworkUrl30: String?
  let artworkUrl100: String?
  let releaseDate: String?
  let trackName: String?
  let kind: String?
  let currency: String?
  let trackPrice: Float?
  let primaryGenreName: String?
  let longDescription: String?
  let trackId: String
  var isVisited: Bool = false
  var isDeleted: Bool = false
  
  var mediaType: MediaType {
    return MediaType(kind ?? "")
  }
  
  var currencyType: CurrencyType? {
    return CurrencyType(currency ?? "")
  }
  
  var priceString: String? {
    guard let price = trackPrice,
      let currencyType = currencyType
      else {return nil}
    
    return "\(price) \(currencyType.symbol)"
  }
  
  public init(with json: JSON) {
    if let wrapper = json["wrapperType"].string, wrapper == "audiobook" {
      trackName = json["collectionName"].stringValue
      longDescription = json["description"].stringValue
      kind = wrapper
      trackPrice = json["collectionPrice"].float
      trackId = ("\(json["collectionId"].intValue)")
    } else {
      trackName = json["trackName"].string
      longDescription = json["longDescription"].stringValue
      kind = json["kind"].string
      trackPrice = json["trackPrice"].float
      trackId = ("\(json["trackId"].intValue)")
    }
    
    previewUrl = json["previewUrl"].string
    artworkUrl60 = json["artworkUrl60"].string
    artworkUrl30 = json["artworkUrl30"].string
    artworkUrl100 = json["artworkUrl100"].string
    releaseDate = json["releaseDate"].string?.format(from: "yyyy-MM-dd'T'HH:mm:ssZ", to: "dd MMM yyyy")
    currency = json["currency"].string
    primaryGenreName = json["primaryGenreName"].string
    isVisited = CoreData.shared.visitedMedias.contains(trackId)
    isDeleted = CoreData.shared.deletedMedias.contains(trackId)
  }
}
