//
//  Network.swift
//  BerkleyAppPOC
//
//  Created by Alina Protsiuk on 6/3/19.
//  Copyright © 2019 CoreValue. All rights reserved.
//

import Foundation

class URLSessionProvider {
    private let defaultSession: URLSession
    private let authHelper: AuthHelper
    
    init(_ authHelper: AuthHelper) {
        self.authHelper = authHelper
        defaultSession = URLSession(configuration: .default)
    }
    
    func setupReguest(httpMethod: HTTPMethod,
                      url: URL, accessToken: String,
                                  parameters: [String: Any]?) -> URLRequest {
        //defaultSession.invalidateAndCancel()
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        if let param = parameters {
            do {
                let jsonData = try? JSONSerialization.data(withJSONObject: param)
                request.httpBody = jsonData
                print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
            }
        }
        
        return request
    }
    
    func createDataTask(for request: URLRequest,
                                    retry: Bool = true,
                                    complition: @escaping (NetworkResponse) -> Void) {
        let dataTask = defaultSession.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                complition(NetworkResponse.failure("Couldn't get graph result: \(error.localizedDescription)"))
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                complition(NetworkResponse.failure("Couldn't get graph result"))
                return
            }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300,
                let data = data {
                complition(NetworkResponse.success(data))
            } else if httpResponse.statusCode == 401 {
                if retry {
                    self?.authHelper.acquireTokenSilently() { [weak self] (success, error) -> Void in
                        if success {
                            var request = request
                            request.setValue("Bearer \(self?.authHelper.currentAccount()?.accessToken ?? "")", forHTTPHeaderField: "Authorization")
                            self?.createDataTask(for: request, retry: false, complition: { (response) in
                                complition(response)
                            })
                        } else {
                            complition(NetworkResponse.failure(error ?? "Unknown error"))
                        }
                    }
                } else {
                    complition(NetworkResponse.failure("Couldn't access API with current access token, and we were told to not retry."))
                }
            } else {
                do {
                    let data = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    if let error = data?["error"] as? NSDictionary {
                        complition(NetworkResponse.failure("Error: \((error["message"] as? String) ?? "")"))
                    }
                } catch {
                    complition(NetworkResponse.failure("Unknown error"))
                }
            }
        }
        dataTask.resume()
    }
}



