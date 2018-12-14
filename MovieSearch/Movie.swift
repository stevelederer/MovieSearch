//
//  Movie.swift
//  MovieSearch
//
//  Created by Steve Lederer on 12/14/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import Foundation

struct TopLevelDictionary: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title, summary: String
    let posterPath: String?
    let rating: Double
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case rating = "vote_average"
        case summary = "overview"
        case posterPath = "poster_path"
    }
}
