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
                if(!viewModel.movies.isEmpty) {
                    Spacer()
                    loadingOrErrorView()
                }
            }
            if(viewModel.movies.isEmpty) {
                loadingOrErrorView()
            }
        }.task {
            await viewModel.loadMoreData()
        }
    }
    
    @ViewBuilder
    private func loadingOrErrorView() -> some View {
        if viewModel.isLoading  {
            ProgressView()
        } else if let error = viewModel.errorMessage  {
            errorView(error: error)
        }
    }
    
    private func errorView(error: String) -> some View {
        VStack {
            Text(error)
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
