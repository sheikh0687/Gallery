//
//  Switcher.swift
//  Gallery
//
//  Created by Sheikh Arbaz on 7/20/24.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC()
    {
        let status = k.userDefault.bool(forKey: k.google.userStatus)
        
        if status {
            let mainViewController = kStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            let vc = UINavigationController(rootViewController: mainViewController)
            kAppDelegate.window?.rootViewController = vc
            kAppDelegate.window?.makeKeyAndVisible()
        } else {
            let loginVC = kStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let vc = UINavigationController(rootViewController: loginVC)
            kAppDelegate.window?.rootViewController = vc
            kAppDelegate.window?.makeKeyAndVisible()
        }
    }
}
