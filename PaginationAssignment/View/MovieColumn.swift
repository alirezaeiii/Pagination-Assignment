//
//  MovieColumn.swift
//  PaginationAssignment
//
//  Created by Ali on 12/17/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieColumn: View {
    let movie: Movie
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        let placeHolder = shape.foregroundColor(.secondary)
            .frame(width: Constants.frameWidth, height: Constants.frameHeight)
        VStack {
            if let posterPath = movie.posterPath {
                WebImage(url: URL(string: String(format: Constants.BASE_WIDTH_342_PATH, posterPath))) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(shape)
                } placeholder: {
                    placeHolder
                }
            } else {
                placeHolder
            }
            Text(movie.name).font(.title3).lineLimit(1).minimumScaleFactor(0.5).truncationMode(.tail)
        }.padding()
        
    }
    
    private struct Constants {
        static let cornerRadius: Double = 20
        static let frameWidth: Double = 150
        static let frameHeight: Double = 240
        static let BASE_WIDTH_342_PATH = "http://image.tmdb.org/t/p/w342%@"
    }
}

#Preview {
    let movie = Movie(id: 1, name: "Ali", posterPath: "https://avatars.githubusercontent.com/u/2465559?v=4")
    return MovieColumn(movie: movie)
}
