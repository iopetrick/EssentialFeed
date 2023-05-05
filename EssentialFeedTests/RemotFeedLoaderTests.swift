//
//  RemotFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.load(from: URL(string: "https://a-url.com")!)
    }
}

protocol HTTPClient {
    func load(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func load(from url: URL) {
        requestedURL = url
    }
}

final class RemotFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(client: client)
                        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // arrange part
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client)
        
        // Act part
        sut.load()
        
        //result
        XCTAssertNotNil(client.requestedURL)
    }
}
