//
//  User1Preference.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/6/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation


class UserPreference{
    
    var genreId:Int?
    var actorId:Int?
    var minReleaseYear: String?
    var maxReleaseYear: String?
    
    var user1Genre: Int?
    var user2Genre: Int?
    var user1Actor: Int?
    var user2Actor: Int?

    
    init(genreId:Int?,actorId:Int?,minReleaseYear:String?,maxReleaseYear:String?){
        self.genreId = genreId
        self.actorId = actorId
        self.minReleaseYear = minReleaseYear
        self.maxReleaseYear = maxReleaseYear
    }
    init(user1Genre:Int?,user2Genre:Int?,user1Actor:Int?,user2Actor:Int?,minReleaseYear:String?,maxReleaseYear:String?){
        self.user1Genre = user1Genre
        self.user2Genre = user2Genre
        self.user1Actor = user1Actor
        self.user2Actor = user2Actor
        self.minReleaseYear = minReleaseYear
        self.maxReleaseYear = maxReleaseYear
    }
}
