//
//  RemotFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import XCTest

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoader {
    
}

final class RemotFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
                        
        XCTAssertNil(client.requestedURL)
    }
    
}
