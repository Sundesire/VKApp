//
//  NewsfeedInteractor.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright (c) 2019 Ivan Babushkin. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        switch request {
        case .getNewsFeed:
            service?.getFeed(completion: {[weak self] (revealPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealPostIds: revealPostIds))
            })
        case .getUser:
            service?.getUser(completion: {[weak self] (user) in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
        case .revealPostIds(let postId):
            service?.revealPostIds(forPostId: postId, completion: {[weak self] (revealPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealPostIds: revealPostIds))
            })
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)
            
            service?.getNextBatch(completion: { (revealPostIds, feed) in
                self.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealPostIds: revealPostIds))
            })
        case .addLike(let sourceId, let postId):
            service?.addLike(sourceId: sourceId, postId: postId)
        case .removeLike(let sourceId, let postId):
            service?.deleteLike(sourceId: sourceId, postId: postId)
        }
    }
}
