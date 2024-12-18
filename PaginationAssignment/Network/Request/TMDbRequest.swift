//
//  TMDbRequest.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

protocol RequestProtocol {
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    func request() throws -> URLRequest
}

struct TMDbRequest: RequestProtocol {
    let httpMethod: HTTPMethod = .GET
    let url: URL?
    
    init(path: TMDbEndpoint.Paths, page: Int) {
        let endpoint = TMDbEndpoint.tmdb(path: path)
        self.url = DefaultURLFactory.createURL(from: endpoint, page: page)
    }

    func request() throws -> URLRequest {
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}
