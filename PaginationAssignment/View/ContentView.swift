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
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .padding(.vertical, 16)
                        }
                    } else if let error = viewModel.errorMessage  {
                        Spacer()
                        errorView(error: error)
                    }
                }
            }
            if(viewModel.movies.isEmpty) {
                if viewModel.isLoading  {
                    ProgressView()
                } else if let error = viewModel.errorMessage  {
                    errorView(error: error)
                }
            }
        }.task {
            await viewModel.loadMoreData()
        }
    }
    
    func errorView(error: String) -> some View {
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
