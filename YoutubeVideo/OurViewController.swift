//
//  OurViewController.swift
//  YoutubeVideo
//
//  Created by Vimal Das on 28/10/23.
//

import UIKit

class OurViewController: UIViewController {
    var adapter: MainLoaderAdapter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adapter = MainLoaderAdapter(recommendedLoader: RecommendedFeedLoader(),
                                    topRatedLoader: TopRatedFeedLoader(),
                                    newReleaseLoader: NewReleaseFeedLoader())
    }
    
    func loadData() {
        adapter?.load { (result) in
            switch result {
            case let .success(model):
                print(model.newRelease, model.recommended, model.topRated)
                
            case let .failure(error):
                print("Error: \(error)")
            }
        }
    }
}

extension OurViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
