//
//  TMDbWrapper.swift
//  PaginationAssignment
//
//  Created by Ali on 12/18/24.
//

import Foundation

struct TMDbWrapper: Decodable {
    let movies: Array<Movie>
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

