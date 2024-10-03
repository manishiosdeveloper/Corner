//
//  NetworkManager+Utils.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingFailed
    case invalidResponse
    case unknownError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
