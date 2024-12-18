//
//  DefaultURLFactory.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

protocol URLFactory {
    static func createURL(from endpoint: Endpoint, page: Int) -> URL?
}

struct DefaultURLFactory: URLFactory {
    
    static func createURL(from endpoint: Endpoint, page: Int) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            urlComponents.queryItems = [URLQueryItem(name: Constants.API_KEY, value: apiKey), URLQueryItem(name: Constants.PAGE_KEY, value: String(page))]
        }
        return urlComponents.url
    }
    
    private struct Constants {
        static let API_KEY = "api_key"
        static let PAGE_KEY = "page"
    }
}
