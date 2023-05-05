//
//  RemotFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.load(from: url)
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
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)
                        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        // arrange part
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        // Act part
        sut.load()
        
        //result
        XCTAssertEqual(client.requestedURL, sut.url)
    }
}
