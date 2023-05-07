//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Pratikkumar Prajapati on 04/05/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
