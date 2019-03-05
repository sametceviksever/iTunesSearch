//
//  URLRequest.swift
//  BaseProject
//
//  Created by Samet Çeviksever on 12.02.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol URLRequestProtocol {
  var request: URLRequest? {get}
  var methodType: MethodType {get}
  var contentType: ContentType {get}
  var timeOut: TimeInterval {get}
  var cachePolicy: URLRequest.CachePolicy {get}
  var url: String {get}
  var body: JSON {get}
  var headers: [String: String] {get}
  var errorType: RequestError.Type {get}
}

public extension URLRequestProtocol {
  
  var request: URLRequest? {return createRequest()}
  
  private func createRequest() -> URLRequest? {
    guard let url = URL(string: url) else {return nil}
    var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeOut)
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.httpMethod = methodType.rawValue
    urlRequest.timeoutInterval = timeOut
    if contentType != .none{
      urlRequest.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
    }
    setBody(to: &urlRequest)
    
    return urlRequest
  }
  
  private func setBody(to request:inout URLRequest) {
    switch methodType {
    case .post:
      request.httpBody = try? body.rawData(options: .prettyPrinted)
    case .get:
      guard let body = body.dictionaryObject ,
        var urlString = request.url?.absoluteString else {return}
      var bodyString = "?"
      body.forEach({bodyString = String(format: "%@%@=\($0.value)&",bodyString,$0.key)})
      bodyString = String(bodyString.dropLast())
      urlString += bodyString
      request.url = URL(string: urlString)
    default:
      break
    }
  }
}
