//
//  LoginViewController.swift
//  fit-swift-client
//
//  Created by admin on 08/10/2019.
//  Copyright © 2019 Dominik Urbaez Gomez. All rights reserved.
//

import UIKit
import EasyPeasy

class LoginViewController: UIViewController {
    enum Route: String {
        case login
        case signUp
    }
    private let router = LoginRouter()
    private let viewModel = LoginViewModel()
    
    private let loginField = TextField()
    private let passwordField = PasswordField()
    private let loginLabel = Label(label: "login")
    private let passwordLabel = Label(label: "password")
    
    private let container = UIView()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupCommonTraits()
        setup()
        resetAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommonTraits()
        setup()
        resetAppearance()
        viewModel.vc = self
    }
    
    private func setup(){
        view.addSubview(container)
        container.easy.layout(Edges())
        
        setupButtons()
        setupTextFields()
        let logo = UIImageView()
        logo.image = UIImage(named: "logo-text")
        container.addSubview(logo)
        logo.easy.layout(CenterX(), Bottom(20).to(loginLabel))
    }
    
    private func setupButtons() {
        let loginButton = Button(label: "login")
        container.addSubview(loginButton)
        loginButton.easy.layout(CenterX(), Bottom(280))
        loginButton.addGesture(target: self, selector: #selector(self.loginButtonTapped(_:)))
        
        let newAccButton = Button(type: .big, label: "create new account")
        container.addSubview(newAccButton)
        newAccButton.easy.layout(CenterX(), Bottom(125))
        newAccButton.addGesture(target: self, selector: #selector(self.signUpTapped(_:)))
    }
    
    private func  setupTextFields() {
        container.addSubviews(subviews: [loginLabel, passwordLabel, loginField, passwordField])
        loginLabel.easy.layout(Bottom(6).to(loginField), Left(78))
        passwordLabel.easy.layout(Bottom(6).to(passwordField), Left(78))
        loginField.easy.layout(CenterX(), Bottom(425))
        passwordField.easy.layout(CenterX(), Bottom(345))
    }
    
    func resetAppearance() {
        loginLabel.text = "login"
        loginField.textField.text = ""
        passwordLabel.text = "password"
        passwordField.textField.text = ""
    }
    
    func handleLoginAction(success: Bool) {
        if success {
            self.router.route(to: Route.login.rawValue, from: self)
        }
        else {
            self.loginLabel.text = "try again! - login"
            self.passwordLabel.text = "try again! - password"
            self.loginField.textField.text = ""
            self.passwordField.textField.text = ""
        }
    }
}

// MARK: Routing

extension LoginViewController {
    
    @objc private func loginButtonTapped(_ sender: UITapGestureRecognizer? = nil) {
        generator.selectionChanged()
        let login = loginField.textField.text ?? ""
        let passwd = passwordField.textField.text ?? ""
        
        viewModel.authenticateOnLogin(login: login, passwd: passwd) {}
    }
    @objc private func signUpTapped(_ sender: UITapGestureRecognizer? = nil) {
        generator.selectionChanged()
        router.route(to: Route.signUp.rawValue, from: self)
    }
}