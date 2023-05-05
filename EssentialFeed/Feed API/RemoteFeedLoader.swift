//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import Foundation

public protocol HTTPClient {
    func load(from url: URL)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
        
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.load(from: url)
    }
}
