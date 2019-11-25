//
//  NewsfeedWorker.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright (c) 2019 Ivan Babushkin. All rights reserved.
//

import UIKit

class NewsfeedService {
    var authService: AuthService
    var networking: NetworkServiceProtocol
    var dataFetcher: NetworkDataFetcherProtocol
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?
    
    init() {
        self.authService = AppDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.dataFetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        dataFetcher.getUser { (userResponse) in
            completion(userResponse)
        }
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        dataFetcher.getFeed(nextBatchFrom: nil) {[weak self] (feedResponse) in
            self?.feedResponse = feedResponse
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }
    
    func addLike(sourceId: Int, postId: Int) {
        dataFetcher.addLike(owner: sourceId, item: postId)
    }
    
    func deleteLike(sourceId: Int, postId: Int) {
        dataFetcher.deleteLike(owner: sourceId, item: postId)
    }
    
    func getNextBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        dataFetcher.getFeed(nextBatchFrom: newFromInProcess) {[weak self] (feed) in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
                self?.feedResponse?.nextFrom = feed.nextFrom
                
                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter { (oldProfile) -> Bool in
                        !feed.profiles.contains(where: {$0.id == oldProfile.id })
                    }
                    profiles.append(contentsOf: oldProfilesFiltered)
                    
                    
                }
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { (oldGroup) -> Bool in
                        !feed.groups.contains(where: {$0.id == oldGroup.id })
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                    
                    
                }
                self?.feedResponse?.groups = groups
                self?.feedResponse?.profiles = profiles
            }
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
}
