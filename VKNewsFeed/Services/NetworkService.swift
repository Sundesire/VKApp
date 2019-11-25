//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol{
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> ())
    func requestLikes(path: String, params: [String : String])
}

final class NetworkService: NetworkServiceProtocol {
    
    
    private let authService: AuthService
    
    init(authService: AuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> ()) {
        guard let token = authService.token else { return }
        var allparams = params
        
        allparams["access_token"] = token
        allparams["v"] = API.version
        
        let url = self.url(from: path, params: allparams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
        
        print(url)
    }
    
    func requestLikes(path: String, params: [String : String]) {
        guard let token = authService.token else { return }
        var allparams = params
        
        allparams["access_token"] = token
        allparams["v"] = API.version
        
        let url = self.url(from: path, params: allparams)
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
        
        print(url)
    }
    
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> ()) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }
    }
    
    private func url(from path: String, params:[String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
}
