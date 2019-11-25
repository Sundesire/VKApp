//
//  AuthService.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 18.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import VKSdkFramework

protocol AuthServiceDelegate: class {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceDidSignInFail()
}

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    private let appId = "7213666"
    private let vkSdk: VKSdk
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("sucess init")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    
    // MARK: - VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    // MARK: - VKSdkUIDelegate
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        delegate?.authServiceShouldShow(controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
    func wakeUpSession() {
        let scope = ["offline", "photos", "wall", "friends"]
        
        VKSdk.wakeUpSession(scope) {[delegate] (state, error) in
            if state == VKAuthorizationState.authorized {
                print(VKAuthorizationState.authorized)
                delegate?.authServiceSignIn()
            } else if state == VKAuthorizationState.initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
                
            } else {
                print("auth problem, state \(state), error \(String(describing: error))")
                delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    
}
