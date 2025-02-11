//
//  Recipe.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import Foundation

struct Recipes: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable {
    let cuisine: String
    let name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let uuid: String
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid
        case youtubeURL = "youtube_url"
    }
}
