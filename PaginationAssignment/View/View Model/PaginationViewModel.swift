//
//  PaginationViewModel.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

@Observable
class PaginationViewModel {
    var isLoading = false
    var movies: [Movie] = []
    var hasMoreData = true
    var errorMessage: String? = nil
    
    @ObservationIgnored
    private var currentPage = 1
    
    @ObservationIgnored
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @MainActor
    func loadMoreData() async {
        guard !isLoading && hasMoreData else { return }
        isLoading = true
        errorMessage = nil
        do {
            let followingRequest = TMDbRequest(path: .movies, page: currentPage)
            let newItems: TMDbWrapper = try await networkService.perform(request: followingRequest)
            self.movies.append(contentsOf: newItems.movies)
            self.currentPage += 1
            self.hasMoreData = newItems.movies.count == Constants.PAGE_SIZE
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    private struct Constants {
        static let PAGE_SIZE = 20
    }
}
