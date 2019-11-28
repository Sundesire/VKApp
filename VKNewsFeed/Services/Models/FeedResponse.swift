//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
    var nextFrom: String?
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: Likes?
    let reposts: CountableItem?
    let views: CountableItem?
    let attachments: [Attachment]?
}

struct Attachment: Decodable {
    let photo: Photo?
    //для добавления других вложений
}

struct Photo: Decodable {
    let sizes: [PhotoSize]

    var heihgt: Int {
        return getProperSize().height

    }
    var widht: Int {
        return getProperSize().width
    }

    var srcBIG: String {
        return getProperSize().url
    }

    private func getProperSize() -> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x"}) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong url image", width: 0, height: 0)
        }
    }
}
struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountableItem: Decodable {
    let count: Int
}

struct Likes: Decodable {
    let count: Int
    let canLike: Int
}

protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileRepresentable {

    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String

    var name: String { return firstName + " " + lastName}
    var photo: String { return photo100 }

}

struct Group: Decodable, ProfileRepresentable {

    let id: Int
    let name: String
    let photo100: String

    var photo: String { return photo100 }

}


