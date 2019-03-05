//
//  Network.swift
//  BaseProject
//
//  Created by Samet Çeviksever on 12.02.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias NetworkResponseBlock<T> = ((URLResponseType<T>) -> Void)

public final class Network {
  static var shared: Network = Network()
  
  public final func call<T> (with request: URLRequestProtocol,then: @escaping NetworkResponseBlock<T>) where T: Decodable{
    call(with: request) { [unowned self] (response) in
      switch response {
      case .error(let error):
        then(.error(error))
      case .success(let data):
        switch data {
        case .json(let json):
          if let item: T = self.decodeItem(with: json) {
            then(.success(.decoded(item)))
          }
        default:
          let defaultError = DefaultError(with: .wrong)
          then(.error(defaultError))
        }
        
      }
    }
  }
  
  private func decodeItem<T> (with json: JSON) -> T? where T: Decodable {
    guard let data = try? json.rawData() else {return nil}
    do {
      let item = try JSONDecoder().decode(T.self, from: data)
      return item
    } catch (let e) {
      print(e)
    }
    
    return nil
  }
  
  public final func call<T> (with request: URLRequestProtocol,then: @escaping NetworkResponseBlock<T>) where T: JSONDecodable {
    call(with: request) { [unowned self] (response) in
      switch response {
      case .error(let error):
        then(.error(error))
      case .success(let data):
        switch data {
        case .json(let json):
          then(.success(.decoded(T(with: json))))
        default:
          let defaultError = DefaultError(with: .wrong)
          then(.error(defaultError))
        }
        
      }
    }
  }
  
  public final func call(with request: URLRequestProtocol,then: @escaping NetworkResponseBlock<JSON>){
    guard let urlRequest = request.request else {
      //TODO: duzelt tek error olmali
      let defaultError = DefaultError(with: .wrong)
      then(.error(defaultError))
      return
    }
    print("Request URL: \(urlRequest.url)")
    URLSession.shared.dataTask(with: urlRequest) {[unowned self] (data, urlResponse, error) in
      DispatchQueue.main.async {
        if let error = error {
          let reqError = request.errorType.init(with: error)
          then(.error(reqError))
          return
        } else if let error = request.errorType.init(with: urlResponse) {
          then(.error(error))
          return
        }
        
        guard let data = data else {
          let defaultError = DefaultError(with: .wrong)
          then(.error(defaultError))
          return
        }
        
        if let json = try? JSON(data: data) {
          then(.success(.json(json)))
          return
        }
        let defaultError = DefaultError(with: .wrong)
        then(.error(defaultError))
        return
      }
      }.resume()
  }
}
