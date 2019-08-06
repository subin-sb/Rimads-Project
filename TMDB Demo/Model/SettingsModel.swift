//
//  SettingsModel.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation

protocol SettingsProtocol : NetworkProtocol {
    func onTokenResponseStatus(status: Bool)
    func onResponseStatusWithRequestCode(request: REQUEST, status: Bool)
}

class SettingsModel : SettingsProtocol {
    var delegate : SettingsProtocol?
    
    func onTokenResponseStatus(status: Bool) {
        delegate?.onTokenResponseStatus(status: status)
    }
    
    func onResponseStatusWithRequestCode(request: REQUEST, status: Bool) {
        delegate?.onResponseStatusWithRequestCode(request: request, status: status)
    }
}
