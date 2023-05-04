//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Pratikkumar Prajapati on 04/05/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
