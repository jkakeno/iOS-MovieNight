//
//  Genre.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/2/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class Genre: NSObject, JSONDecodable{
    let id:Int
    let name:String
    
    required init?(json: [String:Any]){
        
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String
            else {return nil}
        
        self.id = id
        self.name = name
        
        super.init()
    }
}

