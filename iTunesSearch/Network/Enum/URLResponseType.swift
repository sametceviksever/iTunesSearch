//
//  URLResponse.swift
//  BaseProject
//
//  Created by Samet Çeviksever on 12.02.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum URLResponseType<T> {
    case success(ResponseType<T>)
    case error(RequestError)
    
    var value: ResponseType<T>? {
        switch self {
        case .success(let reponse):
            return reponse
        default:
            return nil
        }
    }
    
    var error: RequestError? {
        switch self {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
}
