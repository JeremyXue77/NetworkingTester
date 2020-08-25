//
//  GetTokenRequest.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

struct GetTokenRequset: Request {
    
    typealias Response = GetTokenResponse
    
    let url: URL = Environment.current.baseURL.appendingPathComponent("userToken")
    let method: HTTPMethod = .POST
    var parameters: [String : Any] {
        [
            "username": username,
            "password": password
        ]
    }
    let contentType: ContentType = .json
    let headers: [String : String] = [:]
    
    let username: String
    let password: String
}

struct GetTokenResponse: Decodable {
    let message: String
}
