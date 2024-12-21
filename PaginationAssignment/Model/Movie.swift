//
//  Movie.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

struct Movie : Decodable, Equatable {
    let id: Int
    let name: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "title"
        case posterPath = "poster_path"
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}
