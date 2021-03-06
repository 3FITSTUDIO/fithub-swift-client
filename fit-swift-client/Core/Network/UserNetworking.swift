//
//  UserNetworking.swift
//  fit-swift-client
//
//  Created by admin on 25/12/2019.
//  Copyright © 2019 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation
import Alamofire

final class UserNetworking : NetworkingClient {
    
    weak var store: UserStore?
    private var userEndpoint = "/user"
    
    // MARK: Login View Controller, Authentication
    func getUser(forUsername login: String, inputPasswd: String, onComplete: @escaping(Swift.Result<User, NetworkError>) -> Void) {
        var params = [String: Any]()
        params["login"] = login
        let passwordToCheck = Security.sha256(str: inputPasswd)
        
        executeRequest(userEndpoint, .get, parameters: params) { (json, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                onComplete(.failure(.dataNotAvailable))
                return
            }
            else if let jsonData = json?.first {
                do {
                    let user = try User(json: jsonData)
                    if user.password == passwordToCheck {
                        onComplete(.success(user))
                        return
                    }
                    else {
                        onComplete(.failure(.noAuthentication))
                        return
                    }
                    
                } catch {
                    debugPrint("fetch_user_data: Failed to deserialize incoming data")
                    onComplete(.failure(.cannotProcessData))
                    return
                }
            }
            else {
                debugPrint("fetch_user_data: No incoming data")
                onComplete(.failure(.cannotProcessData))
                return
            }
        }
    }
    
    func fetchUserData(byId id: Int, onComplete: @escaping(Swift.Result<User, NetworkError>) -> Void) {
        let endpoint = userEndpoint + "/" + String(id)
        
        executeRequest(endpoint, .get) { (json, error) in
            if let error = error {
                debugPrint("fetch_user_data: Received error from server: \n" + error.localizedDescription)
                onComplete(.failure(.dataNotAvailable))
            }
            else if let json = json {
                do {
                    let user = try User(json: json[0])
                    onComplete(.success(user))
                } catch {
                    debugPrint("fetch_user_data: Failed to deserialize incoming data")
                    onComplete(.failure(.cannotProcessData))
                }
            }
        }
    }
    
    // MARK: Sign Up View Controller
    func postNewAccountCreated(name: String?, surname: String?, email: String?, login: String?, password: String?, sex: String?, height: String?, yearOfBirth: String?, onComplete: @escaping(Bool) -> Void) {
        guard name != nil && surname != nil && email != nil && password != nil, sex != nil, height != nil, yearOfBirth != nil else {
            onComplete(false)
            return
        }
        
        var params: [String: Any] = [:]
        if Validation.validateName(name: name!) {
            params["first_name"] = name
        }
        if Validation.validateName(name: surname!) {
            params["last_name"] = surname
        }
        if Validation.validateEmailId(emailID: email!){
            params["email"] = email
        }
        params["login"] = login
        if Validation.validatePassword(password: password!) {
            if let passwd = password {
                params["password"] = Security.sha256(str: passwd)
            }
        }
        else {
            debugPrint("Invalidate Password!")
            onComplete(false)
        }
        params["sex"] = sex
        if let height = height {
            params["height"] = Int(height)
        }
        if let year = yearOfBirth {
            params["yearOfBirth"] = Int(year)
        }
        
        executeRequest(userEndpoint, .post, parameters: params, encoding: JSONEncoding.default) { (json, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                debugPrint("fetch_user_id: Received error from server")
                onComplete(false)
            }
            else {
                onComplete(true)
            }
        }
    }
}
