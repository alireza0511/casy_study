//
//  BaseVC.swift
//  interview-sample
//
//  Created by Alireza Khakpout on 9/15/19.
//  Copyright © 2019 Alireza Khakpout. All rights reserved.
//

import Foundation
import UIKit

class BaseVC: UIViewController {
    var activitySpinner: ActivitySpinnerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showSpinner() {
        activitySpinner = Bundle.main.loadNibNamed("ActivitySpinnerView", owner: self, options: nil)?.first as? ActivitySpinnerView
        let size = self.view.frame.size
        activitySpinner?.center = CGPoint(x: size.width/2, y: size.height/2)
        self.view.addSubview(activitySpinner!)
    }
    
    func removeSpinner() {
        self.activitySpinner?.removeFromSuperview()
        
    }
    
    func showNoConnectionAlert() {
        
        let alertController = UIAlertController(title: nil, message: "No Network Connection Available", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showConnectionResponseError(errorMessage: String) {
        
        let alertController = UIAlertController(title: "Error", message: "something went wrong: " + errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showGoToSettingsAlert(reason: String) {
        
        let alertController = UIAlertController(title: nil,
                                                message: reason,
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
            
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
