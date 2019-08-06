//
//  LoginViewController.swift
//  TMDB Demo
//
//  Created by Subin Sundaran Baby Sarojam on 8/4/19.
//  Copyright © 2019 SSBS. All rights reserved.
//

import UIKit
import ProgressHUD
import Toast_Swift

class LoginViewController: UIViewController, LoginProtocol, UITextFieldDelegate {
    
    let loginModel = LoginModel()
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loginModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        userName.delegate = self
        password.delegate = self
        
        // dismiss keyboard on tap
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action:        #selector(UIView.endEditing(_:))))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Network.shared.setCurrentObserver(obs: loginModel)
    }
    
    //Dismiss keyboard using Return Key (Done) Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

    @IBAction func onLoginButtonPressed(_ sender: UIButton) {
        let user = userName.text
        let passtext = password.text
        
        if user != "" && passtext != "" {
            // Show Progress Bar
            ProgressHUD.show()
            Network.shared.createRequestToken()
        } else {
            self.view.makeToast("Enter valid username and password", duration: 3.0, position: .center)
        }
    }

    func onTokenResponseStatus(status: Bool) {
        if true == status {
            // Perform user login
            if Network.shared.userLoginRequest(userName: userName.text ?? "default user", password: password.text ?? "default password") {
            }
        } else {
            // Dismiss Progress Bar
            ProgressHUD.dismiss()
            
            // Show Toast Error
            self.view.makeToast("Login Error - Please try again", duration: 3.0, position: .center)
        }
    }

    func onResponseStatusWithRequestCode(request: REQUEST,status: Bool) {
        ProgressHUD.dismiss()
        if request == .LOGIN {
            if status {
                // Move to the Home page
                performSegue(withIdentifier: "goToTabBar", sender: self)
            } else {
                // Show Toast Error
                self.view.makeToast("Login Error - Please try again", duration: 3.0, position: .center)
            }
        }
    }
}

