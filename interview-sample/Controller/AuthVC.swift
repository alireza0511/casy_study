//
//  ViewController.swift
//  interview-sample
//
//  Created by Jazzb Dev on 9/15/19.
//  Copyright © 2019 Jazzb Dev. All rights reserved.
//

import UIKit

class AuthVC: BaseVC {

    // MARK: Properties
    var keyboardOnScreen = false
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTxf: UITextField!
    @IBOutlet weak var passTxf: UITextField!
    @IBOutlet weak var confirmPassTxf: UITextField!
    @IBOutlet weak var registerSwitchBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionRegisterSwitch(_ sender: Any) {
    }
    
    @IBAction func actionRegister(_ sender: Any) {
    }
    

}

// MARK: - extension Configuration
 extension AuthVC: UITextFieldDelegate {
    
    func setUserDefaults() {
        UserDefaults.standard.setValue(emailTxf.text, forKey:"email")
        UserDefaults.standard.setValue(emailTxf.text, forKey:"password")
    }
    
    func setUIEnabled(_ enabled: Bool,  registerMode: RegisterMode) {
        
        emailTxf.isEnabled = enabled
        passTxf.isEnabled = enabled
        registerSwitchBtn.isEnabled = enabled
        registerSwitchBtn.setTitle("Register", for: .normal)
        registerBtn.isEnabled = enabled
        registerBtn.setTitle("Login", for: .normal)
        confirmPassTxf.isHidden = true
        
        if enabled {
            registerBtn.alpha = 1.0
            registerSwitchBtn.alpha = 1.0
        } else {
            registerBtn.alpha = 0.5
            registerSwitchBtn.alpha = 0.5
        }
        
        if registerMode == RegisterMode.singUp {
            confirmPassTxf.isHidden = false
            confirmPassTxf.isEnabled = enabled
            registerBtn.setTitle("Singup", for: .normal)
            registerSwitchBtn.setTitle("Back to Login", for: .normal)
        }
    }
    
    func configureUI() {
        emailTxf.text = UserDefaults.standard.value(forKey: "email") as? String
        passTxf.text = UserDefaults.standard.value(forKey: "password") as? String
        
        configureTextField(emailTxf)
        configureTextField(passTxf)
        configureTextField(confirmPassTxf)
    }
    
    func configureTextField(_ textField: UITextField){
        textField.delegate = self
    }
    
    func switchRegisterMode( uiEnabled: Bool, registerMode: RegisterMode) {
        
        emailTxf.isEnabled = uiEnabled
        passTxf.isEnabled = uiEnabled
        registerSwitchBtn.isEnabled = uiEnabled
        registerSwitchBtn.setTitle("check", for: .normal)
        registerBtn.isEnabled = uiEnabled
        registerBtn.setTitle("Login", for: .normal)
        
        if registerMode == RegisterMode.singUp {
            registerSwitchBtn.setTitle("check", for: .normal)
            registerBtn.isEnabled = uiEnabled
            registerBtn.setTitle("Login", for: .normal)
        }
    }
}

enum RegisterMode{
    case signIn, singUp
}
