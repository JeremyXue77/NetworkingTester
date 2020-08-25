//
//  Client.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import Foundation

class Clinet {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func send<Req: Request>(
        _ request: Req,
        handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        let urlRequest = request.buildRequest()
        
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            
            DispatchQueue.main.async {
                
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                guard let data = data else {
                    handler(.failure(ResponseError.nilData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    handler(.failure(ResponseError.nonHTTPResponse))
                    return
                }
                
                self.responseHandler(request, response: response, data: data, handler: handler)
            }
        }
        task.resume()
    }
    
    private func responseHandler<Req: Request>(_ request: Req,
                                               response: HTTPURLResponse,
                                               data: Data,
                                               handler: @escaping (Result<Req.Response, Error>) -> Void)
    {
        let decoder = JSONDecoder()
        switch response.statusCode {
        case 200...299:
            do {
                let decoded = try decoder.decode(Req.Response.self, from: data)
                handler(.success(decoded))
            } catch let modelDecodeError {
                do {
                    let apiError = try decoder.decode(APIError.self, from: data)
                    handler(.failure(ResponseError.apiError(error: apiError, statusCode: response.statusCode)))
                } catch {
                    handler(.failure(modelDecodeError))
                }
            }
        case 401:
            // refresh resend
            break
        default:
            do {
                let apiError = try decoder.decode(APIError.self, from: data)
                handler(.failure(ResponseError.apiError(error: apiError, statusCode: response.statusCode)))
            } catch {
                handler(.failure(error))
            }
        }
    }
}
