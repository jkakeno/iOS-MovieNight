//
//  Movies.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/6/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class Movie: NSObject, JSONDecodable{
    let id:Int
    let title:String
    let overview:String
    let release:String
    let vote:Double
    let posterPath: String
    
    required init?(json: [String:Any]){
        
        guard let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let overview = json["overview"] as? String,
            let release = json["release_date"] as? String,
            let vote = json["vote_average"] as? Double,
            let posterPath = json["poster_path"] as? String
            else {return nil}
        
        self.id = id
        self.title = title
        self.overview = overview
        self.release = release
        self.vote = vote
        self.posterPath = posterPath
        
        super.init()
    }
}
