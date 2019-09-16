//
//  UserStruct.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/15/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation

struct UserStruct {
    
    // MARK: Properties
    let id : String
    let token: String
    
    // MARK: Initializers
    // construct a PromoStruct from a dictionary
    init(dictionary: [String:AnyObject]) {
        id = dictionary["localId"] as! String
        token = dictionary["idToken"] as! String
    }
    
    static func structFromResults(_ results: [String:AnyObject]) -> UserStruct {
        
        return UserStruct(dictionary: results)
    }
}
