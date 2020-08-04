//
//  ViewController.swift
//  LoginChecker
//
//  Created by Taras Kreknin on 31.07.2020.
//  Copyright © 2020 SKGWAZAP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginField: UITextField!
    private let checker: LoginChecking = LoginChecker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onVerifyTapped(_ sender: Any) {
        if let text = loginField.text {
            let checkResult = checker.isValid(login: text)
            switch checkResult {
            case .success:
                print("Login \(text) is valid")
            case .failure(let error):
                print("Login is not valid \(error)") // TODO error message formatting
            }
                            
        } else {
            print("Login is not valid")
        }
    }
    
}

