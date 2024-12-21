//
//  Endpoint.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

protocol Endpoint {
    typealias Host = String
    typealias Path = String
    var scheme: Scheme { get }
    var host: Host { get }
    var path: Path { get }
}

enum TMDbEndpoint: Endpoint {
    
    case tmdb(path: TMDbEndpoint.Paths)
    
    var scheme: Scheme {
        return .http
    }
    
    var host: Host {
        switch self {
        case .tmdb: "api.themoviedb.org"
        }
    }
    
    var path: Path {
        switch self {
        case .tmdb(path: let path):
            return path.path
        }
    }
}

extension TMDbEndpoint {
    
    enum Paths {
        case movies
        
        var version: String {
            return "3"
        }
        
        var movie: String {
            return "movie"
        }
        
        var upcoming: String {
            return "upcoming"
        }
        
        var path: String {
            switch self {
            case .movies: return "/\(version)/\(movie)/\(upcoming)"
            }
        }
    }
}
