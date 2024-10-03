//
//  NetworkManager.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    private let requestBuilder = URLRequestBuilder(configuration: .init(environment: .development))
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseType: T.Type = T.self,
        body: Data? = nil
    ) -> AnyPublisher<T, NetworkError> {
        
        guard let request = requestBuilder.buildRequest(for: endpoint) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else {
                    print("Response Data: (unable to convert to string)")
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                
                return data
            }
            .decode(type: responseType, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingFailed
                } else if error is URLError {
                    return NetworkError.requestFailed
                } else {
                    return NetworkError.unknownError
                }
            }
            .eraseToAnyPublisher()
    }
}
