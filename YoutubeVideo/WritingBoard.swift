//
//  WritingBoard.swift
//  YoutubeVideo
//
//  Created by Vimal Das on 28/10/23.
//

import Foundation

struct MainModel {
    let recommended: RecommendedFeedModel
    let topRated: TopRatedFeedModel
    let newRelease: NewReleaseFeedModel
}

protocol MainLoader {
    typealias LoaderResult = Result<MainModel, Error>
    func load(completion: @escaping (LoaderResult)->Void)
}

class MainLoaderAdapter: MainLoader {
    let recommendedLoader: RecommendedFeedLoader
    let topRatedLoader: TopRatedFeedLoader
    let newReleaseLoader: NewReleaseFeedLoader
    private let queue = DispatchQueue(label: "MainLoaderAdapter.queue")

    init(recommendedLoader: RecommendedFeedLoader, topRatedLoader: TopRatedFeedLoader, newReleaseLoader: NewReleaseFeedLoader) {
        self.recommendedLoader = recommendedLoader
        self.topRatedLoader = topRatedLoader
        self.newReleaseLoader = newReleaseLoader
    }
    
    struct PartialResult {
        var recommended: RecommendedFeedModel? { didSet { checkCompletion() } }
        var topRated: TopRatedFeedModel? { didSet { checkCompletion() } }
        var newRelease: NewReleaseFeedModel? { didSet { checkCompletion() } }
        var error: Error? { didSet { checkCompletion() } }
        var completion: ((LoaderResult) -> Void)?
        
        private mutating func checkCompletion() {
            if let error = error {
                completion?(.failure(error))
                completion = nil
            } else if let recommendedResult = recommended,
                      let topRatedResult = topRated,
                      let newReleaseResult = newRelease {
                completion?(.success(MainModel(recommended: recommendedResult,
                                               topRated: topRatedResult,
                                               newRelease: newReleaseResult)))
                completion = nil
            }
        }
    }
    
    func load(completion: @escaping (LoaderResult) -> Void) {
        var partialResult = PartialResult(completion: completion)
        
        recommendedLoader.load(completion: { (recommendedResult) in
            self.queue.sync {
                switch recommendedResult {
                case let .failure(error):
                    partialResult.error = error
                    
                case let .success(recommendedModel):
                    partialResult.recommended = recommendedModel
                }
            }
        })
        
        topRatedLoader.load(completion: { (topRatedResult) in
            self.queue.sync {
                switch topRatedResult {
                case let .failure(error):
                    partialResult.error = error
                    
                case let .success(topRatedModel):
                    partialResult.topRated = topRatedModel
                }
            }
        })
        
        newReleaseLoader.load(completion: { (newReleaseResult) in
            self.queue.sync {
                switch newReleaseResult {
                case let .failure(error):
                    partialResult.error = error
                    
                case let .success(newReleaseModel):
                    partialResult.newRelease = newReleaseModel
                }
            }
        })
    }
}
