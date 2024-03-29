//
//  FirebaseClient.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/15/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation

class TheClient: NSObject {
    // shared session
    var session = URLSession.shared
    
    var userStruct: UserStruct?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func taskForPOSTMethod(_ method: String, parameters: [String:AnyObject]?, jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            completionHandlerForPOST(nil, TheClient.Messages.NetworkConnectionError)
        }
        
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, isAuth: true))
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                completionHandlerForPOST(nil, error)
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode ,
                statusCode != 400  && statusCode <= 200 && statusCode >= 299 {
                sendError("Your request returned a status code other than 2xx!")
                
                return
            }
            
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: GET with
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            completionHandlerForGET(nil, TheClient.Messages.NetworkConnectionError)
        }
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, isAuth: false))
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                completionHandlerForGET(nil, error)
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    // create a URL from parameters
    private func urlFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil, isAuth : Bool) -> URL {
        
        var components = URLComponents()
        components.scheme = TheClient.Constants.ApiScheme
        if isAuth {
            components.host = TheClient.Constants.AuthHost
            components.path = TheClient.Constants.AuthPath + (withPathExtension ?? "")
        } else {
            components.host = TheClient.Constants.ApiHost
            components.path = TheClient.Constants.ApiPath + (withPathExtension ?? "")
        }
        
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        print("-----------------")
        print(components.url!)
        return components.url!
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let error = "Could not parse the data as JSON: '\(data)'"
            completionHandlerForConvertData(nil, error)
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> TheClient {
        struct Singleton {
            static var sharedInstance = TheClient()
        }
        return Singleton.sharedInstance
    }
}
