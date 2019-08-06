//
//  Network.swift
//  TMDB Demo - Uses AlamoFire and SwiftyJSON for network operations
//
//  Created by Subin Sundaran Baby Sarojam on 8/4/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class Network {
    
    static let shared = Network()
    var currObserver : NetworkProtocol?

    private init() {}
    
    func setCurrentObserver(obs: NetworkProtocol) {
        currObserver = obs
    }
    
    /// Requests for the token
    func createRequestToken() {
        Alamofire.request("\(Constants.BASE_URL)\(Constants.NEW_TOKEN_URL_SUBSCRIPT)\(Constants.API_KEY)").responseJSON{
            response in
            
            var bStatus = false
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)
                UserDefaults.standard.set("\(jsonResponse["request_token"])", forKey: Constants.DEFAULTS_TOKEN)
                UserDefaults.standard.set("\(jsonResponse["expires_at"])", forKey: Constants.DEFAULTS_TOKEN_TIME)
                bStatus = true
            } else {
                print("Error = \(String(describing: response.result.error))")
            }
            
            self.currObserver?.onTokenResponseStatus(status: bStatus)
        }
    }
    
    /// Sign in request
    func userLoginRequest(userName: String, password: String) -> Bool {
        var bRet = false;
        if let token = UserDefaults.standard.string(forKey: Constants.DEFAULTS_TOKEN) {
            bRet = true
            let parameters: Parameters = [  "username" : "\(userName)",
                                            "password" : "\(password)",
                                            "request_token" : "\(token)"]
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.USER_LOGIN_URL_SUBSCRIPT)\(Constants.API_KEY)", method: .post, parameters: parameters).responseJSON {
                (response) in
                
                var bResultStatus = false
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value!)
                    UserDefaults.standard.set("\(jsonResponse["request_token"])", forKey: Constants.DEFAULTS_TOKEN)
                    UserDefaults.standard.set("\(jsonResponse["expires_at"])", forKey: Constants.DEFAULTS_TOKEN_TIME)
                    
                    if "\(jsonResponse["success"])" == "true" {
                        bResultStatus = true
                    }
                } else {
                    print("Error = \(String(describing: response.result.error))")
                }
                
                // Notify the status of login to UI
                self.currObserver?.onResponseStatusWithRequestCode(request: .LOGIN, status: bResultStatus)
            }
        }
        
        return bRet
    }
    
    // Gets movie details for both Popular and Top Rated categories
    func getMovieDetails(type: CARDTYPE) {
        
        let homeProtocol = self.currObserver as! HomeProtocol
        let requestString : String?
        if type == .POPULAR {
            homeProtocol.resetPopular()
            requestString = "\(Constants.BASE_URL)\(Constants.POPULAR_MOVIES_URL_SUBSCRIPT_1)\(Constants.API_KEY)\(Constants.POPULAR_MOVIES_URL_SUBSCRIPT_2)"
        } else {
            homeProtocol.resetTopRated()
            requestString = "\(Constants.BASE_URL)\(Constants.TOPRATED_MOVIES_URL_SUBSCRIPT_1)\(Constants.API_KEY)\(Constants.TOPRATED_MOVIES_URL_SUBSCRIPT_2)"
        }
        
        Alamofire.request(requestString!).responseJSON {
    
            response in

            var bStatus = false
            if response.result.isSuccess {
                let jsonResponse = JSON(response.result.value!)

                var totalItems = Int("\(jsonResponse["total_results"])")
                if totalItems! > Constants.MAX_CARDS {
                    totalItems = Constants.MAX_CARDS
                }

                // Fills up the model with the response data
                for idx in 0...20 {
                    if idx < totalItems! {
                        let cardModel = CardModel()
                        cardModel.title = "\(jsonResponse["results"][idx]["title"])"
                        cardModel.rating = "\(jsonResponse["results"][idx]["vote_average"])"
                        cardModel.rating = cardModel.rating!.count > 3 ? "\(cardModel.rating?.prefix(3) ?? "0.0")" : cardModel.rating
                        cardModel.year = String("\(jsonResponse["results"][idx]["release_date"])".prefix(4))
                        cardModel.imageUrl = URL.init(string: "\(Constants.IMAGE_URL)\(jsonResponse["results"][idx]["poster_path"])")

                        homeProtocol.onCardDataResponse(cardData: cardModel, type: type)
                    }
                }

                bStatus = true
            } else {
                print("Error = \(String(describing: response.result.error))")
            }

            var req : REQUEST?
            if type == .POPULAR {
                req = .POPULAR
            } else if type == .TOPRATED {
                req = .TOPRATED
            } else {
                req = .TOKEN
            }
        
            self.currObserver?.onResponseStatusWithRequestCode(request: req!, status: bStatus)
        }
    }
    
    /// AlamofireImage Pod for downloading images
    func downloadImage(url: URL, type: CARDTYPE, index: Int) {
        Alamofire.request(url).responseImage{
            response in
            
            if let image = response.result.value {
                let homeProtocol = self.currObserver as! HomeProtocol
                homeProtocol.onImageDownloaded(image: image, url: url, type: type, index: index)
            }
        }
    }
    
}
