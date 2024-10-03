//
//  NetworkConfiguration.swift
//  Corner
//
//  Created by manish singh on 03/10/24.
//
import Foundation

enum NetworkEnvironment {
    case development
    case staging
    case production
}

struct NetworkConfiguration {
    let environment: NetworkEnvironment
    
    var baseURL: String {
        switch environment {
        case .development:
            return "https://app.corner.inc/app2/interview-project/"
        case .staging:
            return "https://app.corner.inc/app2/interview-project/"
        case .production:
            return "https://app.corner.inc/app2/interview-project/"
        }
    }
    
    var commonHeaders: [String: String] {
        return ["x-api-key": "manish-2e66cfb6-9175-48ae-852b-acb5006e8bca"]
    }
}
