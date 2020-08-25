//
//  AuthManager.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

class AuthManager {
    
    private let client: Clinet
    
    init(client: Clinet = .init()) {
        self.client = client
    }
    
    func login(username: String,
               password: String,
               handler: @escaping (Result<GetTokenResponse, Error>) -> Void)
    {
        let request = GetTokenRequset(username: username, password: password)
        client.send(request, handler: handler)
    }
    
    func register(username: String,
                  password: String,
                  checkPassword: String,
                  handler: @escaping (Result<GetTokenResponse, Error>) -> Void)
    {
        let request = RegisterRequest(username: username, password: password, checkpassword: checkPassword)
        client.send(request, handler: handler)
    }
}
