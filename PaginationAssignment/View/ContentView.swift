//
//  ContentView.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(PaginationViewModel.self) private var viewModel
    
    var body: some View {
        ZStack {
            if(viewModel.movies.isEmpty) {
                loadingOrErrorView
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridItemSize))]) {
                        ForEach(viewModel.movies, id: \.self.id) { movie in
                            MovieColumn(movie: movie).onAppear {
                                if movie == viewModel.movies.last, viewModel.hasMoreData {
                                    Task {
                                        await viewModel.loadMoreData()
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    loadingOrErrorView
                }
            }
        }.task {
            await viewModel.loadMoreData()
        }
    }
    
    @ViewBuilder
    private var loadingOrErrorView: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView()
        case .failure(let error):
            errorView(error: error)
        case .idle:
            EmptyView()
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                Task {
                    await viewModel.loadMoreData()
                }
            }) {
                Text("Retry")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private struct Constants {
        static let gridItemSize: Double = 180
    }
}

#Preview {
    let networkService = NetworkService()
    let viewModel = PaginationViewModel(networkService: networkService)
    return ContentView().environment(viewModel)
}
