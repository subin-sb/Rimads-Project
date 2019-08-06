//
//  HomeViewController.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import UIKit
import ProgressHUD
import Toast_Swift

class HomeViewController: UIViewController, HomeProtocol, UICollectionViewDelegate, UICollectionViewDataSource {

    let homeModel = HomeModel()
    @IBOutlet weak var popularCollection: UICollectionView!
    @IBOutlet weak var topRatedCollection: UICollectionView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        homeModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        popularCollection.delegate = self
        popularCollection.dataSource = self
        topRatedCollection.delegate = self
        topRatedCollection.dataSource = self
        
        Network.shared.setCurrentObserver(obs: homeModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count : Int?
        
        // Returns the collection count
        if collectionView == popularCollection {
            count = homeModel.popularModelCache.countLimit
        } else if (collectionView == topRatedCollection) {
            count = homeModel.topRatedModelCache.countLimit
        } else {
            count = 0
        }
        return count!
    }
    
    /// Handles both the collections - Popular Movies and Top Rated Movies
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellGlobal : UICollectionViewCell?
        
        if collectionView == popularCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularCell", for: indexPath) as! PopularCell
            let popularModel = homeModel.popularModelCache.object(forKey: NSString(string: "\(indexPath.row)"))
            
            if popularModel?.title == nil {
                ProgressHUD.show()
                Network.shared.getMovieDetails(type: .POPULAR)
            }
            
            if popularModel?.image == nil {
                homeModel.observeForPopularImageLoad(index: indexPath.row)
            }
            
            cell.displayContent(image: popularModel?.image ?? UIImage(imageLiteralResourceName: "Logo"),
                                title: popularModel?.title ?? "title",
                                year: popularModel?.year ?? "year",
                                rating: popularModel?.rating ?? "rating")
            cellGlobal = cell
            return cell
            
        } else if collectionView == topRatedCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCell
            let topRatedModel = homeModel.topRatedModelCache.object(forKey: NSString(string: "\(indexPath.row)"))
            
            if topRatedModel?.title == nil {
                Network.shared.getMovieDetails(type: .TOPRATED)
            }
            
            if topRatedModel?.image == nil {
                homeModel.observeForTopRatedImageLoad(index: indexPath.row)
            }
            
            cell.displayContent(image: topRatedModel?.image ?? UIImage(imageLiteralResourceName: "Logo"),
                                title: topRatedModel?.title ?? "title",
                                year: topRatedModel?.year ?? "year",
                                rating: topRatedModel?.rating ?? "rating")
            cellGlobal = cell
            return cell
        } else {
            print("ERROR HomeViewController collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)")
        }
        return cellGlobal!
    }
    
    func onPopularIndexImageLoaded(index: Int) {
        popularCollection.reloadData()
    }
    
    func onTopRatedIndexImageLoaded(index: Int) {
        topRatedCollection.reloadData()
    }

    func onResponseStatusWithRequestCode(request: REQUEST, status: Bool) {
        ProgressHUD.dismiss()
        if false == status {
            self.view.makeToast("Error loading data - Please try again", duration: 3.0, position: .center)
        }
    }
    
    func onImageDownloaded(image: UIImage, url: URL, type: CARDTYPE, index: Int) {
    }
    
    // Protocol methods. Concrete Implementation not required in this class
    func resetPopular() {}
    func resetTopRated() {}
    func onTokenResponseStatus(status: Bool) {}
    func onCardDataResponse(cardData: CardModel, type: CARDTYPE) {}
}
