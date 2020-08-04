//
//  LoginCheckerTests.swift
//  LoginCheckerTests
//
//  Created by Taras Kreknin on 31.07.2020.
//  Copyright © 2020 SKGWAZAP. All rights reserved.
//

import XCTest
@testable import LoginChecker

class LoginCheckerTests: XCTestCase {

    private var checker: LoginChecking!
    
    override func setUpWithError() throws {
        checker = LoginChecker()
    }

    func testChecker_validatesLength() throws {
        let incorrectLogins = [
            "",
            "q",
            "hi",
            "this-is-me-bender-bending-rodriguez"
        ]
        
        let correctLogins = [
            "A12",
            "skgwazap",
            "iWantAlotOfMoney@65apps.com",
            "thisStringIsExcactly32characters"
        ]
        
        incorrectLogins.forEach { login in
            let result = checker.isValid(login: login)
            XCTAssertTrue((result.error as! LoginCheckError).isIncorrectLength)
        }
        
        correctLogins.forEach { login in
            let result = checker.isValid(login: login)
            XCTAssertTrue(result.error == nil, "Login \(login) is not correct. \(result.error!)")
        }
    }
    
    func testChecker_validatesAllowedChars() throws {
        let expectedResult = [
            true,
            true,
            false,
            false
        ]
        let logins = [
            "nice-login11.1",
            "yet-another",
            "россия",
            "😀emoji"
        ]
        
        let actualResult = logins.map { checker.isValid(login: $0).error == nil } // TODO проверять тип ошибки
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testChecker_validatesFirstCharacter() throws {
        let expectedResult = [
            true,
            true,
            false,
            false,
            false
        ]
        let logins = [
            "nice-login",
            "yet-another@my.com",
            "111warning",
            "-my@email.com",
            ".NET",
        ]
        
        let actualResult = logins.map { checker.isValid(login: $0).error == nil }
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testChecker_validatesSpecialCharsCount() throws {
        let expectedResult = [
            true,
            true,
            false,
            false
        ]
        let logins = [
            "nice-log-in",
            "yet-another@my.com",
            "two.dots..here",
            "a-lot-of--dashes"
        ]
        
        let actualResult = logins.map { checker.isValid(login: $0).error == nil }
        
        XCTAssertEqual(expectedResult, actualResult)
    }
    
    func testChecker_validatesEmail() throws {
        let incorrectLogins = [
            "this-is-not-an-email@host",
            "noHost@.com",
            "noHost2@",
            "shortDomain@co.m",
            "noDomain@email",
            "noDomain2@email.",
            "-start-symbol@was-not-ok.ko",
            "sample@with-number-in.dom1ain",
            "sample@with-2-@test.tost",
        ]
        
        let correctLogins = [
            "a@a.aa",
            "skgwazap@gmail.com",
            "skg-wazap@gmail.com.edu",
            "skg.wazap@gmail.org",
            "skg.waz-ap@g-mail.co.uk",
            "iWantAlotOfMoney@65apps.com",
            "with-dash-and.dot@yo-lo.ru"
        ]
        
        incorrectLogins.forEach { login in
            let result = checker.isValid(login: login)
            switch result {
            case .success(_):
                XCTFail("\(login) is incorrect, but got success")
            case .failure(let error):
                XCTAssertTrue(error.isNotAnEmail)
                break
            }
        }
        
        correctLogins.forEach { login in
            let result = checker.isValid(login: login)
            XCTAssertTrue(result.error == nil, "Login \(login) is not correct. \(result.error!)")
        }

    }

}

extension LoginCheckError {
    var isIncorrectLength: Bool {
        switch self {
        case .incorrectLength(_):
            return true
        default:
            return false
        }
    }
    
    var isNotAnEmail: Bool {
        switch self {
        case .notAnEmail:
            return true
        default:
            return false
        }
    }
}

extension Result {
    
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
}
