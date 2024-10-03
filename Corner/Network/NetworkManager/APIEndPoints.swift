//
//  APIEndPoints.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

import Foundation

enum APIEndpoints {
    case postList
}

extension APIEndpoints: Endpoint {
    var path: String {
        switch self {
        case .postList:
            return "posts"
        }
    }
    
    var method: String {
        return HTTPMethod.get.rawValue
    }
    
    var queryParams: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
}
