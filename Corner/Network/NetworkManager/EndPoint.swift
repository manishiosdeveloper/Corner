//
//  EndPoint.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var queryParams: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Endpoint {
    func buildURL(baseURL: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL + path) else { return nil }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams
        }
        
        return urlComponents.url
    }
}

