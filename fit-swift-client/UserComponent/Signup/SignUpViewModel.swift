//
//  SignUpViewModel.swift
//  fit-swift-client
//
//  Created by admin on 06/11/2019.
//  Copyright © 2019 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation

class SignUpViewModel {
    private var store: UserStore
    weak var vc: SignUpViewController?
        
    init() {
        store = mainStore.userStore
    }
    
    enum ValidationResult {
        case emptyFields
        case invalidPassword
        case passwordsDontMatch
        case success
        case unknownError
    }
    
    func handleSignupAction(enteredData: [String?]) {
        let result = verifyEnteredData(data: enteredData)
        handleValidationResult(result: result, data: enteredData)
    }
    
    func verifyEnteredData(data: [String?]) -> ValidationResult {
        var validationResult: ValidationResult = .success
        
        // no empty data
        var flag = true
        data.forEach {
            guard $0 != "" else {
                validationResult = .emptyFields
                flag = false
                return
            }
        }
        guard flag else { return validationResult }
        
        // passwords matching regex rules
        if let passwd = data[4]{
            guard Validation.validatePassword(password: passwd) else {
                validationResult = .invalidPassword
                return validationResult
            }
        } // empty fields
        else {
            return .emptyFields
        }
        
        // passwords matching
        guard data[4] == data[5] else {
            return .passwordsDontMatch
        }
        return validationResult
    }
    
    private func handleValidationResult(result: ValidationResult, data: [String?]) {
        switch result {
        case .emptyFields:
            vc?.displayAlert(type: .emptyFields)
        case .invalidPassword:
            vc?.displayAlert(type: .invalidPassword)
        case .passwordsDontMatch:
            vc?.displayAlert(type: .passwordsDontMatch)
        case .success:
            store.tryCreateNewUser(data: data) { [weak self] result in
                let postResult: SignUpViewController.AlertType = result ? .success : .unknownServerError
                self?.vc?.displayAlert(type: postResult)
            }
        case .unknownError:
            vc?.displayAlert(type: .unknownServerError)
        }
    }
}
