//
//  LoginVC.swift
//  Gallery
//
//  Created by Sheikh Arbaz on 7/20/24.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btn_GoogleSignIn(_ sender: UIButton) {
        self.googleSignIn()
    }
}

extension LoginVC {
    
    private func googleSignIn() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {
            result, error in
            if let error {
                print("Error", error)
                return
            }
            
            guard let fullName = result?.user.profile?.name else { return }
            guard let userId = result?.user.userID else { return }
            guard let emailAddress = result?.user.profile?.email else { return }
            
            k.userDefault.set(true, forKey: k.google.userStatus)
            k.userDefault.set(userId, forKey: k.google.googleClientId)
            Switcher.updateRootVC()
        }
    }
}

