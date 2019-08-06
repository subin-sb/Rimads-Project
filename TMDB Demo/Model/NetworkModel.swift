//
//  NetworkModel.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation

class NetworkModel {
    
}

enum REQUEST {
    case TOKEN
    case LOGIN
    case POPULAR
    case TOPRATED
    case IMAGE
}

protocol NetworkProtocol {
    func onTokenResponseStatus(status: Bool)
    func onResponseStatusWithRequestCode(request: REQUEST,status: Bool)
}
