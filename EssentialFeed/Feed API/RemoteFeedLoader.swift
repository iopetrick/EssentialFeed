//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import Foundation

public protocol HTTPClient {
    func load(from url: URL, completion: @escaping (Error) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (RemoteFeedLoader.Error) -> Void) {
        client.load(from: url) { _ in
            completion(.connectivity)
        }
    }
}
