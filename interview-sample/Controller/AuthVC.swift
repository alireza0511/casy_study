//
//  ViewController.swift
//  interview-sample
//
//  Created by Alireza Khakpout on 9/15/19.
//  Copyright © 2019 Alireza Khakpout. All rights reserved.
//

import UIKit

class AuthVC: BaseVC {
    
    // MARK: Properties
    var keyboardOnScreen = false
    var signInMode = true
    
    // MARK: Outlets
    @IBOutlet weak var emailTxf: UITextField!
    @IBOutlet weak var passTxf: UITextField!
    @IBOutlet weak var confirmPassTxf: UITextField!
    @IBOutlet weak var registerSwitchBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var debugLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        switchRegisterMode(uiEnabled: true, registerMode: RegisterMode.signIn)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func actionRegisterSwitch(_ sender: Any) {
        signInMode = !signInMode
        if signInMode {
            
            switchRegisterMode(uiEnabled: true, registerMode: RegisterMode.signIn)
            
        } else {
            switchRegisterMode(uiEnabled: true, registerMode: RegisterMode.singUp)
        }
        
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        userDidTapView(self)
        
        let jsonBody = "{\"email\":\"\(emailTxf.text!)\",\"password\":\"\(passTxf.text!)\",\"returnSecureToken\":\(true)}"
        if signInMode {
            
            
            
            
            if emailTxf.text!.isEmpty || passTxf.text!.isEmpty {
                debugLbl.text = "Email or Password Empty."
            } else {
                setUIEnabled(false, registerMode: RegisterMode.signIn)
                self.setUserDefaults()
                self.showSpinner()
                
                let mutableMethod = TheClient.Methods.Signin
                print(jsonBody)
                TheClient.sharedInstance().authRequest(method: mutableMethod, jsonBody: jsonBody) { (success, error) in
                    if let error = error {
                        performUIUpdatesOnMain {
                            self.removeSpinner()
                            self.setUIEnabled(true, registerMode: RegisterMode.signIn)
                            self.debugLbl.text = "please try again."
                        }
                        self.showConnectionResponseError(errorMessage: error)
                    }
                    
                    if success {
                        performUIUpdatesOnMain {
                            self.removeSpinner()
                            self.setUIEnabled(false, registerMode: RegisterMode.signIn)
                            self.debugLbl.text = ""
                            //self.performSegue(withIdentifier: " ", sender: self)
                        }
                    }
                }
            }
            
        } else {
            if emailTxf.text!.isEmpty || passTxf.text!.isEmpty {
                debugLbl.text = "Email or Password Empty."
            } else if passTxf.text != confirmPassTxf.text{
                debugLbl.text = "Confirm Password does not match."
            } else {
                setUIEnabled(false, registerMode: RegisterMode.signIn)
                self.setUserDefaults()
                self.showSpinner()
                
                let mutableMethod = TheClient.Methods.Signup
                print(jsonBody)
                TheClient.sharedInstance().authRequest(method: mutableMethod, jsonBody: jsonBody) { (success, error) in
                    if let error = error {
                        print(error)
                    }
                    print(success)
                    
                }
            }
        }
        
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        
        resignIfFirstResponder(emailTxf)
        resignIfFirstResponder(passTxf)
        resignIfFirstResponder(confirmPassTxf)
    }
    
}

// MARK: - extension Configuration
extension AuthVC: UITextFieldDelegate {
    
    func configureTextField(_ textField: UITextField){
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)/2
            imgView.isHidden = true
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)/2
            imgView.isHidden = false
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    
    func subscribeToKeyboardNotifications(){
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(self.keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(self.keyboardWillHide))
        subscribeToNotification(UIResponder.keyboardDidShowNotification, selector: #selector(self.keyboardDidShow))
        subscribeToNotification(UIResponder.keyboardDidHideNotification, selector: #selector(self.keyboardDidHide))
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension AuthVC {
    
    func setUserDefaults() {
        UserDefaults.standard.setValue(emailTxf.text, forKey:"email")
        UserDefaults.standard.setValue(passTxf.text, forKey:"password")
    }
    
    func setUIEnabled(_ enabled: Bool,  registerMode: RegisterMode) {
        
        emailTxf.isEnabled = enabled
        passTxf.isEnabled = enabled
        registerSwitchBtn.isEnabled = enabled
        registerSwitchBtn.setTitle("Register", for: .normal)
        registerBtn.isEnabled = enabled
        registerBtn.setTitle("Login", for: .normal)
        confirmPassTxf.isHidden = true
        debugLbl.text = ""
        debugLbl.isEnabled = enabled
        
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
    
    func switchRegisterMode( uiEnabled: Bool, registerMode: RegisterMode) {
        
        
        registerSwitchBtn.setTitle("SIGNUP INSTEAD", for: .normal)
        registerBtn.setTitle("LOGIN", for: .normal)
        confirmPassTxf.isHidden = true
        
        if registerMode == RegisterMode.singUp {
            registerSwitchBtn.setTitle("LOGIN INSTEAD", for: .normal)
            confirmPassTxf.isHidden = false
            registerBtn.setTitle("SIGNUP", for: .normal)
        }
    }
    
}

enum RegisterMode{
    case signIn, singUp
}
