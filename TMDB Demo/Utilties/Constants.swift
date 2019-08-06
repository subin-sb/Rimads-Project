//
//  Constants.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/4/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: URL Path
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let NEW_TOKEN_URL_SUBSCRIPT = "/authentication/token/new?api_key="
    static let USER_LOGIN_URL_SUBSCRIPT = "/authentication/token/validate_with_login?api_key="
    static let POPULAR_MOVIES_URL_SUBSCRIPT_1 = "/movie/popular?api_key="
    static let POPULAR_MOVIES_URL_SUBSCRIPT_2 = "&language=en-US&page=1"
    static let IMAGE_URL = "https://image.tmdb.org/t/p/w500/"
    static let TOPRATED_MOVIES_URL_SUBSCRIPT_1 = "/movie/top_rated?api_key="
    static let TOPRATED_MOVIES_URL_SUBSCRIPT_2 = "&language=en-US&page=1"
    
    // MARK: Network Constants
    static let API_KEY = "b8f81555c28db4bf873ce583c24ff223"
    
    // MARK: User Defaults
    static let DEFAULTS_TOKEN = "TOKEN"
    static let DEFAULTS_TOKEN_TIME = "TOKEN_TIME"
    
    // MARK: Hard coded values
    static let MAX_CARDS = 20
}
