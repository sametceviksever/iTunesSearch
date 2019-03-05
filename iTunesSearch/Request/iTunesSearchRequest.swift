//
//  iTunesSearchRequest.swift
//  iTunesSearch
//
//  Created by Samet Çeviksever on 1.03.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

struct iTunesSearchRequest: URLRequestProtocol {
  var url: String {return "https://itunes.apple.com/search"}
  var methodType: MethodType {return .get}
  var contentType: ContentType {return .json}
  var timeOut: TimeInterval {return 60}
  var cachePolicy: URLRequest.CachePolicy {return .useProtocolCachePolicy}
  var errorType: RequestError.Type {return DefaultError.self}
  var headers: [String : String] {return [:]}
  var body: JSON
  
  init(searchText: String, mediaType: MediaType) {
    let text = searchText.replacingOccurrences(of: " ", with: "+")
    var parameters: [String: Any] = ["term": text, "limit": 100]
    if let mediaName = mediaType.requestName {
      parameters["media"] = mediaName
    }
    
    body = JSON(parameters)
  }
}
