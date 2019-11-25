//
//  UserResponse.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 22.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
