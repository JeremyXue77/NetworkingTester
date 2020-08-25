//
//  Request.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum ContentType: String {
    case json = "application/json"
    case urlForm = "application/x-www-form-urlencoded; charset=utf-8"
}

protocol Request {
    
    associatedtype Response: Decodable
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get }
    var contentType: ContentType { get }
    var headers: [String: String] { get }
}

extension Request {
    
    func buildRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = headers
        request.allHTTPHeaderFields?["Content-Type"] = contentType.rawValue
        switch method {
        case .GET:
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false)!
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value as? String)
            }
            request.url = components.url
        case .POST:
            switch contentType {
            case .json:
                request.httpBody = try? JSONSerialization
                    .data(withJSONObject: parameters, options: [])
            case .urlForm:
                request.httpBody = parameters
                    .map { "\($0.key)=\($0.value)" }
                    .joined(separator: "&")
                    .data(using: .utf8)
            }
        }
        return request
    }
}
