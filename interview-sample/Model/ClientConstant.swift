//
//  FirebaseConstant.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/15/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation

extension TheClient {
    // MARK: Constants
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "node.jazzb.com"
        static let ApiPath = "/api"
        // https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
        static let AuthHost = "identitytoolkit.googleapis.com"
        static let AuthPath = "/v1/accounts:"
        
        static let ApiKey = "AIzaSyAHZeF9e8qMTj-S6d4yuXr6QsPayfVAqcA"
    }
    
    // MARK: Methods
    struct Methods {
        
        
        // MARK: Sign in
        static let Signin = "signInWithPassword"
        // MARK: Sign up
        static let Signup = "signUp"
        
        // MARK: User Info
        static let UserInfo = "/user/phone_user"
        // MARK: CompanyInfo
        static let CompanyInfo = "/admin/cifo_s/"
       
        
       
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "message"
        static let StatusCode = "responseCode"
        static let results = "response"
        
        // MARK: Account
        static let UserID = "userId"
        static let UserType = "userType"
        static let UserToken = "token"
        static let UserObject = "userObject"
        
        
        // MARK: Config
        static let MangoId = "_id"
        
        // MARK: Company
        static let CompanyID = "Company_ID"
        static let CompanyCategoryID = "Category_ID"
        static let CompanyCategoryType = "Category_type"
        static let CompanySubCategoryType = "Sub_Category_desc"
        static let CompanyName = "Company_name"
        static let CompanyLogo = "Company_Logo"
        static let CompanyWeb = "Company_Website"
        static let CompanyPhone = "Company_Phone_no"
        static let CompanyAddress = "Company_Address"
      
        
    }
    
    struct ParameterKeys {
        static let Key = "key"
    }
    // MARK: Messages
    struct Messages {
        
        // MARK: URLs
        static let NetworkConnectionError = "No Network Connection Available!"
    }
}
