//
//  LoginChecking.swift
//  LoginChecker
//
//  Created by Taras Kreknin on 31.07.2020.
//  Copyright © 2020 SKGWAZAP. All rights reserved.
//

import Foundation

protocol LoginChecking {
    func isValid(login: String) -> Result<Void, LoginCheckError>
}

enum LoginCheckError: Error {
    
    case incorrectLength(actualLength: Int) // для формирования текста ошибки
    case incorrectSymbolsFound // TODO тоже можно добавить параметр для формирования текста ошибки
    case incorrectLogin
    case notAnEmail
    
}

final class LoginChecker: LoginChecking {
    
    private static let validLenghtRange = 3...32
    
    private static let dotChar: Character = "."
    private static let atChar: Character = "@"
    private static let dashChar: Character = "-"
    private static let specialChars = CharacterSet(charactersIn: "\(dotChar)\(atChar)\(dashChar)")
    private static let allowedChars: CharacterSet = {
        let capitalLetters = CharacterSet(charactersIn: "A"..."Z")
        let lowerCaseLetters = CharacterSet(charactersIn: "a"..."z")
        let digits = CharacterSet(charactersIn: "0"..."9")
        
        return CharacterSet.decimalDigits
            .union(lowerCaseLetters)
            .union(capitalLetters)
            .union(specialChars)
    }()
    
    func isValid(login: String) -> Result<Void, LoginCheckError> {
        // Length check
        guard Self.validLenghtRange.contains(login.count) else {
            return .failure(LoginCheckError.incorrectLength(actualLength: login.count))
        }
        
        // Allowed chars check
        let loginCharset = CharacterSet(charactersIn: login)
        guard Self.allowedChars.isSuperset(of: loginCharset) else {
            return .failure(LoginCheckError.incorrectSymbolsFound)
        }
        
        if login.contains(Self.atChar) {
            return isEmailValid(candidate: login)
        } else {
            return isNicknameValid(nickname: login)
        }
        
    }
    
    private func isNicknameValid(nickname: String) -> Result<Void, LoginCheckError> {
        let nicknameRegex = "^[A-Za-z](?:[A-Za-z\\d]|[-.](?=[A-Za-z\\d])){2,31}$"
        if NSPredicate(format: "SELF MATCHES %@", nicknameRegex).evaluate(with: nickname) {
            return .success(())
        } else {
            return .failure(LoginCheckError.incorrectLogin)
        }
    }

    private func isEmailValid(candidate: String) -> Result<Void, LoginCheckError> {
        // https://emailregex.com/
        let emailRegex = "^[A-Za-z](?:[A-Za-z\\d]|[-.](?=[A-Za-z\\d]))*@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate) {
            return .success(())
        } else {
            return .failure(LoginCheckError.notAnEmail)
        }
    }
    
}
