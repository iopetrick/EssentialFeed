//
//  RemotFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pratikkumar Prajapati on 05/05/23.
//

import XCTest
import EssentialFeed

final class RemotFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        // arrange part
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        // Act part
        sut.load()
        //result
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // arrange part
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        // Act part
        sut.load()
        sut.load()
        //result
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliverErrorOnClientError() {
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        var capturedError: RemoteFeedLoader.Error?
        sut.load { error in capturedError = error }
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // MARK: - Helper
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut:RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func load(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
