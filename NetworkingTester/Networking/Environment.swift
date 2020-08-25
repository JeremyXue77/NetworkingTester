//
//  Environment.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

enum Environment {
    
    static var current: Environment = .dev
    
    case dev
    
    var baseURL: URL {
        switch self {
        case .dev: return URL(string: "http://35.185.131.56:8000/api")!
        }
    }
}
