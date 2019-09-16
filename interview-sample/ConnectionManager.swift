//
//  ConnectionManager.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/15/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation
class ConnectionManager {
    static let shared = ConnectionManager()
    
    let reachability = Reachability()!
    
    var isNetworkAvailable : Bool {
        return reachability.connection != .none
    }
}
