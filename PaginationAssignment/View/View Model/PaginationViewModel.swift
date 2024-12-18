//
//  PaginationViewModel.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import Foundation

@Observable
class PaginationViewModel {
    var movies: [Movie] = []
    var hasMoreData = true
    var viewState: ViewState = .idle
    
    @ObservationIgnored
    private var currentPage = 1
    
    @ObservationIgnored
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    @MainActor
    func loadMoreData() async {
        guard viewState != .loading && hasMoreData else { return }
        self.viewState = .loading
        do {
            let request = TMDbRequest(path: .movies, page: currentPage)
            let newItems: TMDbWrapper = try await networkService.perform(request: request)
            self.movies.append(contentsOf: newItems.movies)
            self.currentPage += 1
            self.hasMoreData = newItems.movies.count == Constants.PAGE_SIZE
            self.viewState = .idle
        } catch {
            self.viewState = .failure(error: error)
        }
    }
    
    private struct Constants {
        static let PAGE_SIZE = 20
    }
}

enum ViewState: Equatable {
    case idle
    case loading
    case failure(error: Error)
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.failure(error: _), .failure(error: _)): return true
        default: return false
        }
    }
}
