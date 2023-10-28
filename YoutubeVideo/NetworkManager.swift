//
//  NetworkManager.swift
//  YoutubeVideo
//
//  Created by Vimal Das on 28/10/23.
//

import Foundation

struct RecommendedFeedModel {}

class RecommendedFeedLoader {
    func load(completion: @escaping (Result<RecommendedFeedModel, Error>) -> ()) {}
}

struct NewReleaseFeedModel {}

class NewReleaseFeedLoader {
    func load(completion: @escaping (Result<NewReleaseFeedModel, Error>) -> ()) {}
}

struct TopRatedFeedModel {}

class TopRatedFeedLoader {
    func load(completion: @escaping (Result<TopRatedFeedModel, Error>) -> ()) {}
}

