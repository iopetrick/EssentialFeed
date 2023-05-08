//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Pratikkumar Prajapati on 04/05/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
