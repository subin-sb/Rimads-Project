//
//  Utils.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import Foundation

class Utils {
    
    static let shared = Utils()
    
    private init() {}
    
    /// Checks the token validity (60 min)
    func isTokenValid() -> Bool {
        var bRet = false
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'T''Z'"

        if let tokenTime = UserDefaults.standard.string(forKey: Constants.DEFAULTS_TOKEN_TIME) {
            if let tokenDateTime = formatter.date(from: "\(tokenTime)") {
                let currentTime = Date()
                let diffTime = currentTime.timeIntervalSince(tokenDateTime)
                
                if diffTime > (( 3600 * 4 ) - 600) {
                    print("Request new token")
                } else {
                    print("Use current token")
                    bRet = true
                }
            }
        }
        
        return bRet
    }
}
