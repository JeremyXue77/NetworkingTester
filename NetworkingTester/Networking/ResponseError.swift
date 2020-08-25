//
//  ResponseError.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

enum ResponseError: Error {
    case nilData
    case nonHTTPResponse
    case tokenError
    case apiError(error: APIError, statusCode: Int)
    
    var localizedDescription: String {
        switch self {
        case .nilData:          return "沒有資料"
        case .nonHTTPResponse:  return "沒有回應"
        case .tokenError:       return "token 無效"
        case .apiError(error: let apiError, statusCode: _):
            switch apiError.reason {
            case .single(let str):
                return str
            case .mutiple(let strs):
                return strs.joined(separator: "\n")
            }
        }
    }
}

struct APIError: Decodable {
    
    enum Reason: Decodable {
        case single(String)
        case mutiple([String])
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .single(string)
                return
            }
            if let dic = try? container.decode([String: [String]].self) {
                let reasons = dic.reduce(into: []) { (array, element) in
                    array += element.value
                }
                self = .mutiple(reasons)
                return
            }
            throw DecodingError.typeMismatch(APIError.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong Type for Reason"))
        }
    }
    
    let message: String
    let reason: Reason
    
    enum CodingKeys: String, CodingKey {
        case message, reason
    }
    
    
}
