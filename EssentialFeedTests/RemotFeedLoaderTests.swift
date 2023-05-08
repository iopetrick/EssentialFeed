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
        sut.load() { _ in}
        //result
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        // arrange part
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        // Act part
        sut.load() { _ in}
        sut.load() { _ in}
        //result
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliverErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliverErrorOnNone200HTTPResponse() {
        let (sut, client) = makeSUT()

        [199, 201, 300, 400, 500].enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data("Invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "https://a-url.com")!)
                        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https://a-another-url.com")!)
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: - Helper
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut:RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeak(sut)
        trackForMemoryLeak(client)
        return (sut, client)
    }
    
    private func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        let model = FeedItem(id: id,
                             description: description,
                             location: location,
                             imageURL: imageURL)
        
        let json = [
            "id": model.id.uuidString,
            "description": model.description,
            "location": model.location,
            "image": model.imageURL.absoluteString
        ].reduce(into: [String: Any]()) { (acc, e) in
            if let value = e.value { acc[e.key] = value }
        }
        
        return (model, json)
    }
    
    private func makeItemJSON(_ items: [[String: Any]]) -> Data {
        let itemJSON = ["items": items]
        return try! JSONSerialization.data(withJSONObject: itemJSON)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
}
