//
//  API.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.103"
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
    static let addLike = "/method/likes.add"
    static let deleteLike = "/method/likes.delete"
}
//https://api.vk.com/method/likes.add?type=post&owner_id=1&item_id=45546&v=5.103
