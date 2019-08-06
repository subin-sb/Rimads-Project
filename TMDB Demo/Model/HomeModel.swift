//
//  HomeModel.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation
import UIKit

protocol HomeProtocol : NetworkProtocol {
    func onCardDataResponse(cardData: CardModel, type: CARDTYPE)
    func onImageDownloaded(image: UIImage, url: URL, type: CARDTYPE, index: Int)
    func onPopularIndexImageLoaded(index: Int)
    func onTopRatedIndexImageLoaded(index: Int)
    func resetPopular()
    func resetTopRated()
}

class HomeModel : HomeProtocol {
    
    var delegate : HomeProtocol?
    let popularModelCache = NSCache<NSString, CardModel>()
    var popularCardIdx = 0
    var popularImageIdx = 0
    var popularImageIndexObserve = -1
    
    let topRatedModelCache = NSCache<NSString, CardModel>()
    var topRatedCardIdx = 0
    var topRatedImageIdx = 0
    var topRatedImageIndexObserve = -1
    
    let MAX_IMAGES_DEFAULT = 20
    
    init() {
        popularModelCache.countLimit = 20
        topRatedModelCache.countLimit = 20
    }
    
    func resetPopular() {
        popularCardIdx = 0
        popularImageIdx = 0
    }
    
    func resetTopRated() {
        topRatedCardIdx = 0
        topRatedImageIdx = 0
    }

    func onTokenResponseStatus(status: Bool) {
        delegate?.onTokenResponseStatus(status: status)
    }
    
    func onResponseStatusWithRequestCode(request: REQUEST, status: Bool) {
        delegate?.onResponseStatusWithRequestCode(request: request, status: status)
    }
    
    func onCardDataResponse(cardData: CardModel, type: CARDTYPE){
        if type == .POPULAR {
            if popularCardIdx < Constants.MAX_CARDS {
                popularModelCache.setObject(cardData, forKey: "\(popularCardIdx)" as NSString)
                popularCardIdx += 1
                
                // Once we get the response, immediately send the request to download the image
                if popularImageIdx < MAX_IMAGES_DEFAULT {
                    Network.shared.downloadImage(url: cardData.imageUrl ?? URL.init(string: "Logo")!, type: .POPULAR, index: popularImageIdx)
                    popularImageIdx += 1
                }
            }
        } else {
            if topRatedCardIdx < Constants.MAX_CARDS {
                topRatedModelCache.setObject(cardData, forKey: "\(topRatedCardIdx)" as NSString)
                topRatedCardIdx += 1
                
                // Once we get the response, immediately send the request to download the image
                if topRatedImageIdx < MAX_IMAGES_DEFAULT {
                    Network.shared.downloadImage(url: cardData.imageUrl ?? URL.init(string: "Logo")!, type: .TOPRATED, index: topRatedImageIdx)
                    topRatedImageIdx += 1
                }
            }
        }
    }
    
    func onImageDownloaded(image: UIImage, url: URL, type: CARDTYPE, index: Int) {
        let card : CardModel?
        if type == .POPULAR {
            card = popularModelCache.object(forKey: NSString(string: "\(index)"))
            card?.image = image
            popularModelCache.setObject(card!, forKey: NSString(string: "\(index)"))
            
            // Logic to update the Image Cards asynchronously
            if popularImageIndexObserve == index {
                onPopularIndexImageLoaded(index: index)
                popularImageIndexObserve = -1
            }
        } else if type == .TOPRATED {
            card = topRatedModelCache.object(forKey: NSString(string: "\(index)"))
            card?.image = image
            topRatedModelCache.setObject(card!, forKey: NSString(string: "\(index)"))
            
            // Logic to update the Image Cards asynchronously
            if topRatedImageIndexObserve == index {
                onTopRatedIndexImageLoaded(index: index)
                topRatedImageIndexObserve = -1
            }
        } else {}
    }
    
    func observeForPopularImageLoad(index: Int){
        popularImageIndexObserve = index
    }
    
    func onPopularIndexImageLoaded(index: Int) {
        delegate?.onPopularIndexImageLoaded(index: index)
    }
    
    func observeForTopRatedImageLoad(index: Int){
        topRatedImageIndexObserve = index
    }
    
    func onTopRatedIndexImageLoaded(index: Int) {
        delegate?.onTopRatedIndexImageLoaded(index: index)
    }
    
}

class CardModel {
    var imageUrl : URL?
    var image : UIImage?
    var title : String?
    var year : String?
    var genre : String?
    var rating : String?
    
    func loadImage(){
        
    }
}

enum CARDTYPE {
    case POPULAR
    case TOPRATED
}
