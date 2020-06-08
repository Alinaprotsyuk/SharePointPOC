//
//  AuthManager.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 5/28/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation
import WebKit
import ADAL

class AuthHelper {
    let applicationContext: ADAuthenticationContext
    lazy var webView = WKWebView(frame: UIScreen.main.bounds)
    let infoPlist: PlistManager
    
    init(infoPlist: PlistManager) {
        self.infoPlist = infoPlist
        applicationContext = ADAuthenticationContext(authority: infoPlist.getAuthority() ?? "", error: nil)
    }
    
    func currentAccount() -> ADTokenCacheItem? {
        // We retrieve our current account by getting the last account from cache. This isn't best practice. You should rely
        // on AcquireTokenSilent and store the UPN separately in your application. For simplicity of the sample, we just use the cache.
        // In multi-account applications, account should be retrieved by home account identifier or username instead
        guard let cachedTokens = ADKeychainTokenCache.defaultKeychain().allItems(nil) else {
            print("Didn't find a default cache. This is very unusual.")
            return nil
        }
        
        if !(cachedTokens.isEmpty) {
            // In the token cache, refresh tokens and access tokens are separate cache entries.
            // Therefore, you need to keep looking until you find an entry with an access token.
            for (_, cachedToken) in cachedTokens.enumerated() {
                if cachedToken.accessToken != nil {
                    return cachedToken
                }
            }
        }
        return nil
    }
    
    func acquireToken(completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        applicationContext.webView = webView
        
        DispatchQueue.main.async {
            if let topController =  UIApplication.shared.keyWindow?.rootViewController{
                topController.view.addSubview(self.webView)
            }
        }
        
        /**
         
         Acquire a token for an account
         
         - withResource:        The resource you wish to access. This will the Microsoft Graph API for this sample.
         - clientId:            The clientID of your application, you should get this from the app portal.
         - redirectUri:         The redirect URI that your application will listen for to get a response of the
         Auth code after authentication. Since this a native application where authentication
         happens inside the app itself, we can listen on a custom URI that the SDK knows to
         look for from within the application process doing authentication.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */
        
        applicationContext.acquireToken(withResource: infoPlist.getScope(),
                                        clientId: infoPlist.getClientID(),
                                        redirectUri: infoPlist.getRedirectURI()
        ){ (result) in
            DispatchQueue.main.async {
                self.applicationContext.webView.removeFromSuperview()
            }
            guard let result = result else {
                completion(false, "Could not acquire token: No result returned")
                return
            }
            
            if (result.status != AD_SUCCEEDED) {
                
                if result.error.domain == ADAuthenticationErrorDomain
                    && result.error.code == ADErrorCode.ERROR_UNEXPECTED.rawValue {
                    completion(false, "Unexpected internal error occured: \(result.error.description))")
                    
                } else {
                    completion(false, result.error.description)
                }
            }
            completion(true, nil)
        }
    }
    
    func acquireTokenSilently(completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        /**
         Acquire a token for an existing account silently
         - withResource:        The resource you wish to access. This will the Microsoft Graph API for this sample.
         - clientId:            The clientID of your application, you should get this from the app portal.
         - redirectUri:         The redirect URI that your application will listen for to get a response of the
         Auth code after authentication. Since this a native application where authentication
         happens inside the app itself, we can listen on a custom URI that the SDK knows to
         look for from within the application process doing authentication.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         
         */
        applicationContext.acquireTokenSilent(withResource: infoPlist.getScope(),
                                              clientId: infoPlist.getClientID(),
                                              redirectUri: infoPlist.getRedirectURI()
        ) { (result) in
            guard let result = result else {
                completion(false, "Could not acquire token: No result returned")
                return
            }
            
            if (result.status != AD_SUCCEEDED) {
                
                // USER_INPUT_NEEDED means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.
                
                if result.error.domain == ADAuthenticationErrorDomain
                    && result.error.code == ADErrorCode.ERROR_SERVER_USER_INPUT_NEEDED.rawValue {
                    
                    DispatchQueue.main.async {
                        self.acquireToken() { (success, error) -> Void in
                            if success {
                                completion(true, nil)
                            } else {
                                completion(false, error)
                            }
                        }
                    }
                }
                completion(false, result.error.description)
            }
            completion(true, nil)
        }
    }
    
    func signOut() {
        ADKeychainTokenCache.defaultKeychain().removeAll(forClientId: infoPlist.getClientID() ?? "", error: nil)
    }
}
