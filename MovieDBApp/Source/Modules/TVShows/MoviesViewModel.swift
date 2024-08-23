//
//  MoviesViewModel.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 15/3/24.
//

import Foundation

class MoviesViewModel: ObservableObject {
    @Published var selectedCategory: String = MoviesCategory.nowPlaying.label
}
