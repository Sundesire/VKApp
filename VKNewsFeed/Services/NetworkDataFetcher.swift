//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation

protocol NetworkDataFetcherProtocol {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
    func addLike(owner: Int, item: Int)
    func deleteLike(owner: Int, item: Int)
}

struct NetworkDataFetcher: NetworkDataFetcherProtocol {

    
    
    
    let networking: NetworkServiceProtocol
    private let authService: AuthService
    
    init(networking: NetworkServiceProtocol, authService: AuthService = AppDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId,"fields": "photo_100"]
        networking.request(path: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requested data: \(error.localizedDescription)")
                response(nil)
            }
            let decoder = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoder?.response.first)
        }
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requested data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoder = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoder?.response)
            
        }
    }
    
    func addLike(owner: Int, item: Int) {
        let params = ["type": "post", "owner_id": String(owner), "item_id": String(item)]
        networking.requestLikes(path: API.addLike, params: params)
    }
    
    func deleteLike(owner: Int, item: Int) {
        let params = ["type": "post", "owner_id": String(owner), "item_id": String(item)]
        networking.requestLikes(path: API.deleteLike, params: params)
    }

    private func decodeJSON<T: Decodable> (type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil}
        return response
    }
}
