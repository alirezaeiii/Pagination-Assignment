//
//  NetworkService.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func perform(request: RequestProtocol) async throws -> Data
    func perform<T: Decodable>(request: RequestProtocol) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    private static var urlCache: URLCache {
        let cacheSizeMemory = 0
        let cacheSizeDisk = 0
        let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "URLCacheDirectory")
        return cache
    }
    
    init(session: URLSession? = nil) {
        let config = URLSessionConfiguration.default
        config.urlCache = NetworkService.urlCache
        config.requestCachePolicy = .reloadRevalidatingCacheData
        self.session = session ?? URLSession(configuration: config)
    }
    
    func perform(request: RequestProtocol) async throws -> Data {
        return try await session.data(for: request.request()).0
    }
    
    func perform<T: Decodable>(request: RequestProtocol) async throws -> T {
        let data = try await perform(request: request)
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
}
