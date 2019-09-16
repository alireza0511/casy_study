//
//  MediaStruct.swift
//  interview-sample
//
//  Created by Jazzb Dev on 9/16/19.
//  Copyright © 2019 Jazzb Dev. All rights reserved.
//

import Foundation

struct MediaStruct {
    
    // MARK: Properties
    let id : String
    let type: String
    let imgUrl: String
    let videoUrl: String?
    let desc: String
    
    
    // MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        
        id = dictionary["id"] as! String
        type = dictionary["type"] as! String
        if let rootImages = dictionary["images"] as? [String:AnyObject], let img = rootImages["standard_resolution"] as? [String:AnyObject]{
            imgUrl = img["url"] as! String
        } else {
            imgUrl = ""
        }
        if let rootVideo = dictionary["videos"] as? [String:AnyObject], let video = rootVideo["standard_resolution"] as? [String:AnyObject], let url = video["url"] as? String
            {
                videoUrl = url
        } else {
            videoUrl = ""
        }
        
        if let rootDesc = dictionary["caption"] as? [String:AnyObject], let descText = rootDesc["text"] as? String
        {
            desc = descText
        } else {
            desc = ""
        }
        
        
    }
    
    static func structFromResults(_ results: [[String:AnyObject]]) -> [MediaStruct] {
        
        var dataList = [MediaStruct]()
        for result in results {
            dataList.append(MediaStruct(dictionary: result))
        }
        return dataList
    }
    
}
