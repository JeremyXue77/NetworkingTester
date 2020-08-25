//
//  ViewController.swift
//  NetworkingTester
//
//  Created by Jeremy Xue on 2020/8/25.
//  Copyright © 2020 JeremyXue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum EnterType: Int {
        case login = 0, register
    }
    
    // MARK: Properties
    var authManager: AuthManager = .init()
    var enterType: EnterType = .login
    var username: String = ""
    var password: String = ""
    
    // MARK: IBOutlets
    @IBOutlet weak var enterTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: IBActions
    @IBAction func enterTypeChanged(_ sender: UISegmentedControl) {
        guard let enterType = EnterType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        self.enterType = enterType
    }
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text ?? ""
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    @IBAction func enter(_ sender: UIButton) {
        switch enterType {
        case .login:
            authManager.login(username: username,
                              password: password) { (result) in
                                switch result {
                                case .success(let res):
                                    self.updateMessageLabel(.success(res.message))
                                case .failure(let error):
                                    self.updateMessageLabel(.failure(error))
                                }
            }
        case .register:
            authManager.register(username: username,
                                 password: password,
                                 checkPassword: password) { (result) in
                                    switch result {
                                    case .success(let res):
                                        self.updateMessageLabel(.success(res.message))
                                    case .failure(let error):
                                        self.updateMessageLabel(.failure(error))
                                    }
            }
        }
        
        
    }
    
    private func updateMessageLabel(_ result: Result<String, Error>) {
        switch result {
        case .success(let text):
            messageLabel.textColor = .green
            messageLabel.text = "👌🏻 \(text)"
        case .failure(let error):
            messageLabel.textColor = .red
            if let responseError = error as? ResponseError {
                messageLabel.text = "⚠️ Error: \(responseError.localizedDescription)"
            } else {
                messageLabel.text = "⚠️ Error: \(error.localizedDescription)"
            }
        }
    }
}

