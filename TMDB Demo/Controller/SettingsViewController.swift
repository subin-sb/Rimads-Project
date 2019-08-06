//
//  SettingsViewController.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/5/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsProtocol {
    
    let settingsModel = SettingsModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settingsModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Network.shared.setCurrentObserver(obs: settingsModel)
    }
    
    
    @IBAction func onLogoutButtonTap(_ sender: UIButton) {}
    func onTokenResponseStatus(status: Bool) {}
    func onResponseStatusWithRequestCode(request: REQUEST, status: Bool) {}
}
