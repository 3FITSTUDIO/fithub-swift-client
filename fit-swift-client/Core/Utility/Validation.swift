//
//  Validation.swift
//  fit-swift-client
//
//  Created by admin on 09/05/2020.
//  Copyright © 2020 Dominik Urbaez Gomez. All rights reserved.
//
// https://www.tutorialspoint.com/generic-way-to-validate-textfield-inputs-in-swift

import Foundation

class Validation {
    static func validateName(name: String) -> Bool {
        // Length be 18 characters max and 3 characters minimum, you can always modify.
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        return isValidateName
    }
    
    static func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        return isValidateEmail
    }
    
    static func validatePassword(password: String) -> Bool {
        //Minimum 8 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
}
