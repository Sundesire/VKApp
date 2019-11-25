//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 18.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 10
        authService = AppDelegate.shared().authService
    }
    

    @IBAction func signInTouch() {
        authService.wakeUpSession()
    }
    
}
