//
//  NasaModels.swift
//  ProgrammaticUIKit
//
//  Created by Sarwaan Ansari on 3/13/21.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let collection: Collection
}

// MARK: - Collection
struct Collection: Codable {
    let href: String
    let items: [Item]
    let version: String
    let metadata: Metadata
    let links: [CollectionLink]
}

// MARK: - Item
struct Item: Codable {
    let href: String
    let links: [ItemLink]?
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let center, mediaType: String
    let keywords: [String]
    let nasaid: String
    let datumDescription, description508: String?
    let title, dateCreated: String
    let location, photographer, secondaryCreator: String?
    let album: [String]?

    enum CodingKeys: String, CodingKey {
        case center
        case mediaType = "media_type"
        case keywords
        case nasaid = "nasa_id"
        case datumDescription = "description"
        case description508 = "description_508"
        case title
        case dateCreated = "date_created"
        case location, photographer
        case secondaryCreator = "secondary_creator"
        case album
    }
}

// MARK: - ItemLink
struct ItemLink: Codable {
    let href: String
    let render: String?
    let rel: String
}

// MARK: - CollectionLink
struct CollectionLink: Codable {
    let href: String
    let rel, prompt: String
}

// MARK: - Metadata
struct Metadata: Codable {
    let totalHits: Int

    enum CodingKeys: String, CodingKey {
        case totalHits = "total_hits"
    }
}
