//
//  TheClientConvenience.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/15/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation

extension TheClient{
    
    // MARK: POST Convenience Methods
    func authRequest(method: String, jsonBody: String, completionHandlerForAuth: @escaping ( _ success: Bool, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TheClient.ParameterKeys.Key : TheClient.Constants.ApiKey]
        var mutableMethod: String
        //        mutableMethod = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        mutableMethod = method
        
        
        /* 2. Make the request */
        let _ = taskForPOSTMethod(mutableMethod, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForAuth(false, error)
            } else {
                if let dbError = results?["error"] as? [String:AnyObject], let dbMessage = dbError["message"] as? String {
                    completionHandlerForAuth(false, dbMessage)
                } else {
                    if let dbResults = results as? [String:AnyObject] {
                        self.userStruct = UserStruct.structFromResults(dbResults)
                        completionHandlerForAuth(true, nil)
                    }
                }
            }
        }
    }
    
    // MARK: GET Media Convenience Methods
    func getMediaInfo(completionHandlerForMedia: @escaping (_ result: [MediaStruct]?, _ error: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TheClient.ParameterKeys.AuthToken : userStruct?.token]
        var mutableMethod: String
        mutableMethod = TheClient.Methods.MediaInfo
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: parameters as [String : AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForMedia(nil, error)
            } else {
                if let dbResults = results  as? [[String:AnyObject]] {
                    
                    
                    let result = MediaStruct.structFromResults(dbResults)
                    completionHandlerForMedia(result,nil)
                }else {
                    completionHandlerForMedia(nil, "Could not parse get Branch Info")
                }
            }
        }
    }
}




