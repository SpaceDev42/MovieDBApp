//
//  TVShowsTarget.swift
//  MovieDBApp
//
//  Created by Vladimir Guevara on 15/3/24.
//

import Foundation

enum TVShowsTarget: MovieDBTargetType {
    case nowPlaying(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
}

extension TVShowsTarget {
    var path: String {
        switch self {
        case .popular:
            return "/3/tv/popular"
        case .topRated:
            return "/3/tv/top_rated"
        case .upcoming:
            return "/3/tv/upcoming"
        case .nowPlaying:
            return "/3/tv/now_playing"
        }
    }

    var parameters: [String : Any]? {
        var parameters: [String : Any] = ["api_key": Constant.apiKey]

        switch self {
        case .popular(let page):
            parameters["page"] = String(page)
        case .topRated(let page):
            parameters["page"] = String(page)
        case .nowPlaying(let page):
            parameters["page"] = String(page)
        case .upcoming(let page):
            parameters["page"] = String(page)
        }

        return parameters
    }

    var method: RequestMethod {
        .get
    }
}
