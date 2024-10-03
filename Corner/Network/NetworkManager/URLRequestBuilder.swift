//
//  URLRequestBuilder.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//

import Foundation

class URLRequestBuilder {
    private let configuration: NetworkConfiguration
    
    init(configuration: NetworkConfiguration) {
        self.configuration = configuration
    }
    
    func buildRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.buildURL(baseURL: configuration.baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.allHTTPHeaderFields = configuration.commonHeaders
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        return request
    }
}
