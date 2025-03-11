//
//  LoginManager.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 05/03/2025.
//

import Foundation
import Observation

@Observable
class LoginManager {
    
    var email: String = ""
    var password: String = ""
    var showAlert: Bool = false
    var errorMessage: String = ""
    
    
    // MARK: - Methods
    // ———————————————

    /// Login using Auth
    func login() {
        Task {
            do {
                try await AuthService.shared.login(email: email, password: password)
            } catch {
                errorMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
    
        
    // MARK: - Form validation
    // ————————————————————————
    var isFormValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    
    // MARK: - Email Validation
    // ————————————————————————
    var isEmailValid: Bool {
        if email.isEmpty {
            return false
        } else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
    }
    
    
    // MARK: - Password Validation
    // ———————————————————————————
    
    private var checkMinChar: Bool {
        return password.count >= 8
    }
    private var checkLetter: Bool {
        return password.rangeOfCharacter(from: .letters) != nil
    }
    private var checkSpecialChar: Bool {
        return password.rangeOfCharacter(from: CharacterSet(charactersIn: "[{!@#$%^&*}]")) != nil
    }
    private var checkNumber: Bool {
        return password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    var isPasswordValid: Bool {
        if checkLetter && checkNumber && checkSpecialChar && checkMinChar {
            return true
        } else if checkLetter && !checkNumber && !checkSpecialChar {
            return false
        } else if checkNumber && !checkLetter && !checkSpecialChar {
            return false
        } else if checkSpecialChar && !checkLetter && !checkNumber {
            return false
        } else if checkLetter && checkNumber && !checkSpecialChar {
            return false
        } else if checkSpecialChar && checkLetter && checkNumber {
            return false
        } else {
            return false
        }
    }
}


