//
//  MoviesModels.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 15/3/24.
//

import Foundation

// MARK: - Pagination
struct TVShowsData: Codable {
    let page: Int
    let results: [Show]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Show
struct Show: Codable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int
    let name: String
    let originCountry: [String]?
    let originalLanguage: String
    let originalName: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int

    var category: String = ""

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Show Item
struct TVShowItem: Identifiable {
    let title: String
    let date: String
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let showId: Int
    let id = UUID()
}

// MARK: - Movies Category
enum MoviesCategory: CaseIterable {
    case nowPlaying
    case popular
    case topRated
    case upComing
}

extension MoviesCategory {
    var label: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upComing:
            return "Upcoming"
        }
    }
}
