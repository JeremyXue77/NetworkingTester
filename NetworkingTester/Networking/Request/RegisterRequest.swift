//
//  RegisterRequest.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

struct RegisterRequest: Request {
    
    typealias Response = GetTokenResponse
    
    let url: URL = Environment.current.baseURL.appendingPathComponent("register")
    let method: HTTPMethod = .POST
    var parameters: [String : Any] {
        [
            "username": username,
            "password": password,
            "checkpassword": checkpassword
        ]
    }
    let contentType: ContentType = .json
    let headers: [String : String] = [:]
    
    let username: String
    let password: String
    let checkpassword: String
}

struct RegisterResponse: Decodable {
    let message: String
}

