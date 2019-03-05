//
//  DefaultError.swift
//  BaseProject
//
//  Created by Samet Çeviksever on 14.02.2019.
//  Copyright © 2019 Samet Çeviksever. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct DefaultError: RequestError {
    public var localizedError: String
    public var errorCode: String
    
    public init(with error: Error) {
        localizedError = error.localizedDescription
        errorCode = ""
    }
    
    public init?(with urlResponse: URLResponse?) {
        return nil
    }
    
    public init(with httpError: HTTPError) {
        localizedError = httpError.localizedDescription
        errorCode = httpError.rawValue
    }
}
